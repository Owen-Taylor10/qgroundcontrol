# build-qgc.ps1
# PowerShell script to configure, build, and install QGroundControl for Android on Windows, please check all paths before running!

# === CONFIGURE THESE PATHS ===
$QtHostPath       = "C:\Qt\6.8.3\mingw_64" # Path to your Qt installation for host (e.g., mingw_64)
$QtAndroidKitPath = "C:\Qt\6.8.3\android_arm64_v8a" # Path to your Qt Android kit
$AndroidSdkPath   = "C:\Android\Sdk" #Path to where androud sdk is installed
$AndroidNdkPath   = "$AndroidSdkPath\ndk\26.1.10909125"
$NinjaPath        = "C:\ninja"  # Path where ninja.exe is located

# Target Android ABI & SDK versions
$AndroidAbi       = "arm64-v8a"
$TargetSdk        = 35
$MinSdk           = 28

# === SET ENVIRONMENT VARIABLES ===
$env:ANDROID_SDK_ROOT = $AndroidSdkPath
$env:ANDROID_NDK_ROOT = $AndroidNdkPath
$env:PATH += ";$env:ANDROID_SDK_ROOT\platform-tools;$NinjaPath"

# Confirm Ninja is available
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Error "Ninja is not found in PATH. Please install Ninja and update \$NinjaPath."
    exit 1
}

# === CLEAN OLD BUILD ===
if (Test-Path build-android) {
    Write-Host "Removing old build folder..."
    Remove-Item -Recurse -Force build-android
}

# === CONFIGURE CMAKE USING QT ANDROID KIT ===
Write-Host "Configuring QGroundControl for Android..."
& "$QtAndroidKitPath\bin\qt-cmake.bat" -S . -B build-android `
    -DQT_HOST_PATH="$QtHostPath" `
    -DANDROID_ABI=$($AndroidAbi) `
    -DQGC_QT_ANDROID_TARGET_SDK_VERSION=$TargetSdk `
    -DQGC_QT_ANDROID_MIN_SDK_VERSION=$MinSdk `
    -DCMAKE_BUILD_TYPE=Debug `
    -G Ninja

if ($LASTEXITCODE -ne 0) {
    Write-Error "CMake configuration failed. Check output for errors."
    exit $LASTEXITCODE
}

# === BUILD THE DEBUG APK ===
Write-Host "Building QGroundControl APK..."
cmake --build build-android --target apk
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed. Check output for errors."
    exit $LASTEXITCODE
}

# === INSTALL ON CONNECTED ANDROID DEVICE ===
$DebugApkPath = "build-android\android-build\build\outputs\apk\debug\android-build-debug.apk"

if (Test-Path $DebugApkPath) {
    Write-Host "Installing APK on connected Android device..."
    adb devices
    adb install -r $DebugApkPath
    Write-Host "Installation complete."
} else {
    Write-Warning "APK not found at $DebugApkPath"
}
