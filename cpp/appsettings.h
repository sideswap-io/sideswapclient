#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QSettings>
#include <QJsonObject>
#include <QJsonArray>

namespace BuildData {
#ifdef QT_DEBUG
    const bool isDebug = true;
#else
    const bool isDebug = false;
#endif
}

class AppSettings : public QSettings
{
    AppSettings() : QSettings() {}
    ~AppSettings() override = default;
public:
    static AppSettings* get() {
        static AppSettings settings;
        return &settings;
    }

    bool showWizard() const { return value("General/openWizard", true).toBool(); }
    void setWizardShowed() { setValue("General/openWizard", false); }
};
#endif // APPSETTINGS_H
