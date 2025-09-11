#include "QGCPalette.h"
#include "QGCCorePlugin.h"
#include <QDebug>

QList<QGCPalette*> QGCPalette::_paletteObjects;
QGCPalette::Theme QGCPalette::_theme = QGCPalette::Dark;
QMap<int, QMap<int, QMap<QString, QColor>>> QGCPalette::_colorInfoMap;
QStringList QGCPalette::_colors;

QGCPalette::QGCPalette(QObject* parent) :
    QObject(parent),
    _colorGroupEnabled(true)
{
    if (_colorInfoMap.isEmpty()) {
        _buildMap();
    }
    _paletteObjects += this;
}

QGCPalette::~QGCPalette()
{
    bool fSuccess = _paletteObjects.removeOne(this);
    if (!fSuccess) {
        qWarning() << "Internal error";
    }
}

void QGCPalette::_buildMap()
{
    //                                      Light                 Dark
    //                                      Disabled   Enabled    Disabled   Enabled
    DECLARE_QGC_COLOR(window,               "#F5F5F5", "#F5F5F5", "#00001A", "#00001A") // Light off-white background
    DECLARE_QGC_COLOR(windowShadeLight,     "#D0D4D8", "#D0D4D8", "#1C2526", "#1C2526") // Light gray shade
    DECLARE_QGC_COLOR(windowShade,          "#C0C8CE", "#C0C8CE", "#263D4B", "#263D4B") // Medium gray shade
    DECLARE_QGC_COLOR(windowShadeDark,      "#A8B0B9", "#A8B0B9", "#2E4A5C", "#2E4A5C") // Darker gray shade
    DECLARE_QGC_COLOR(text,                 "#5C6566", "#1A2526", "#A8B0B2", "#D8E2E3") // Dark gray text for readability
    DECLARE_QGC_COLOR(warningText,          "#A94442", "#A94442", "#A94442", "#A94442") // Muted dark red for warnings
    DECLARE_QGC_COLOR(button,               "#E0E4E8", "#E0E4E8", "#1C2526", "#1C2526") // Light gray buttons
    DECLARE_QGC_COLOR(buttonBorder,         "#C0C8CE", "#C0C8CE", "#1C2526", "#1C2526") // Medium gray button borders
    DECLARE_QGC_COLOR(buttonText,           "#5C6566", "#1A2526", "#D8E2E3", "#FFFFFF") // Dark gray to black text on buttons
    DECLARE_QGC_COLOR(buttonHighlight,      "#B8C4CE", "#4A6073", "#3A6073", "#3A6073") // Brighter gray-blue for highlighted buttons
    DECLARE_QGC_COLOR(buttonHighlightText,  "#1A2526", "#FFFFFF", "#FFFFFF", "#FFFFFF") // White text for highlights
    DECLARE_QGC_COLOR(primaryButton,        "#A8B0B9", "#4A6073", "#2E4A5C", "#2E4A5C") // Darker gray-blue for primary buttons
    DECLARE_QGC_COLOR(primaryButtonText,    "#1A2526", "#FFFFFF", "#FFFFFF", "#FFFFFF") // White text for primary buttons
    DECLARE_QGC_COLOR(textField,            "#FFFFFF", "#FFFFFF", "#1C2526", "#1C2526") // White text fields
    DECLARE_QGC_COLOR(textFieldText,        "#5C6566", "#1A2526", "#A8B0B2", "#D8E2E3") // Dark gray to black text in fields
    DECLARE_QGC_COLOR(mapButton,            "#A8B0B9", "#1A2526", "#2E4A5C", "#2E4A5C") // Darker gray map buttons
    DECLARE_QGC_COLOR(mapButtonHighlight,   "#A8B0B9", "#4A6073", "#3A6073", "#3A6073") // Brighter gray-blue for map highlights
    DECLARE_QGC_COLOR(mapIndicator,         "#A8B0B9", "#4A6073", "#2E4A5C", "#2E4A5C") // Darker gray map indicators
    DECLARE_QGC_COLOR(mapIndicatorChild,    "#C0C8CE", "#5C6566", "#263D4B", "#263D4B") // Medium gray for child indicators
    DECLARE_QGC_COLOR(colorGreen,           "#6A7342", "#6A7342", "#263D4B", "#263D4B") // Olive green for consistency
    DECLARE_QGC_COLOR(colorYellow,          "#8C8B5D", "#8C8B5D", "#5C6566", "#5C6566") // Muted yellow for consistency
    DECLARE_QGC_COLOR(colorYellowGreen,     "#6A7342", "#6A7342", "#5C6566", "#5C6566") // Yellow-green for consistency
    DECLARE_QGC_COLOR(colorOrange,          "#8C5B3A", "#8C5B3A", "#5C6566", "#5C6566") // Muted orange for consistency
    DECLARE_QGC_COLOR(colorRed,             "#672F2F", "#672F2F", "#A94442", "#A94442") // Muted dark red
    DECLARE_QGC_COLOR(colorGrey,            "#5C6566", "#5C6566", "#5C6566", "#5C6566") // Consistent gray
    DECLARE_QGC_COLOR(colorBlue,            "#4A6073", "#4A6073", "#00001A", "#00001A") // Lightened dark blue
    DECLARE_QGC_COLOR(alertBackground,      "#D0D4D8", "#D0D4D8", "#1C2526", "#1C2526") // Light gray alert background
    DECLARE_QGC_COLOR(alertBorder,          "#A8B0B9", "#A8B0B9", "#263D4B", "#263D4B") // Darker gray alert border
    DECLARE_QGC_COLOR(alertText,            "#1A2526", "#1A2526", "#FFFFFF", "#FFFFFF") // Dark text for alerts
    DECLARE_QGC_COLOR(missionItemEditor,    "#E0E4E8", "#B8C4CE", "#1C2526", "#1C2526") // Light gray mission editor
    DECLARE_QGC_COLOR(toolStripHoverColor,  "#A8B0B9", "#C0C8CE", "#2E4A5C", "#2E4A5C") // Gray for hover
    DECLARE_QGC_COLOR(statusFailedText,     "#5C6566", "#A94442", "#A94442", "#A94442") // Muted dark red for failed status
    DECLARE_QGC_COLOR(statusPassedText,     "#5C6566", "#1A2526", "#D8E2E3", "#D8E2E3") // Dark gray for passed status
    DECLARE_QGC_COLOR(statusPendingText,    "#5C6566", "#1A2526", "#D8E2E3", "#D8E2E3") // Dark gray for pending status
    DECLARE_QGC_COLOR(toolbarBackground,    "#F5F5F5", "#F5F5F5", "#1C2526", "#1C2526") // Light off-white toolbar
    DECLARE_QGC_COLOR(groupBorder,          "#C0C8CE", "#C0C8CE", "#263D4B", "#263D4B") // Medium gray for group borders

    // Colors not affected by theming
    DECLARE_QGC_NONTHEMED_COLOR(brandingPurple,     "#4A2C6D", "#003366")
    DECLARE_QGC_NONTHEMED_COLOR(brandingBlue,       "#48D6FF", "#00001A")
    DECLARE_QGC_NONTHEMED_COLOR(toolStripFGColor,   "#707070", "#FFFFFF")

    // Colors not affected by theming or enable/disable
    DECLARE_QGC_SINGLE_COLOR(mapWidgetBorderLight,          "#FFFFFF")
    DECLARE_QGC_SINGLE_COLOR(mapWidgetBorderDark,           "#1C2526")
    DECLARE_QGC_SINGLE_COLOR(mapMissionTrajectory,          "#2E4A5C")
    DECLARE_QGC_SINGLE_COLOR(surveyPolygonInterior,         "#2E4A5C")
    DECLARE_QGC_SINGLE_COLOR(surveyPolygonTerrainCollision, "#A94442")

// Colors for UTM Adapter
#ifdef QGC_UTM_ADAPTER
    DECLARE_QGC_COLOR(switchUTMSP,        "#4A6073", "#4A6073", "#2E4A5C", "#2E4A5C")
    DECLARE_QGC_COLOR(sliderUTMSP,        "#C0C8CE", "#C0C8CE", "#263D4B", "#263D4B")
    DECLARE_QGC_COLOR(successNotifyUTMSP, "#4A6073", "#4A6073", "#2E4A5C", "#2E4A5C")
#endif
}

void QGCPalette::setColorGroupEnabled(bool enabled)
{
    _colorGroupEnabled = enabled;
    emit paletteChanged();
}

void QGCPalette::setGlobalTheme(Theme newTheme)
{
    if (_theme != newTheme) {
        _theme = newTheme;
        _signalPaletteChangeToAll();
    }
}

void QGCPalette::_signalPaletteChangeToAll()
{
    for (QGCPalette *palette : std::as_const(_paletteObjects)) {
        palette->_signalPaletteChanged();
    }
}

void QGCPalette::_signalPaletteChanged()
{
    emit paletteChanged();
}
