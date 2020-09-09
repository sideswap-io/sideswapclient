#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QSettings>
#include <QJsonObject>
#include <QJsonArray>

namespace BuildData {
    const QString host = "api.sideswap.io";
    const int port = 443;
    const bool useTls = true;
    const bool mainnet = true;

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

    // debug property
    QString host() {
        if (BuildData::isDebug) {
            return value("Authentification/host", BuildData::host).toString();
        } else {
            return BuildData::host;
        }
    }
    void setHost(QString value) { setValue("Authentification/host", value); }

    int port() const {
        if (BuildData::isDebug) {
            return value("Authentification/port", BuildData::port).toInt();
        } else {
            return BuildData::port;
        }
    }
    void setPort(int value) { setValue("Authentification/port", value); }

    bool useTls() const {
        if (BuildData::isDebug) {
            return value("Authentification/usetls", BuildData::useTls).toBool();
        } else {
            return BuildData::useTls;
        }
    }
    void setUseTls(bool value) { setValue("Authentification/usetls", value); }

    bool mainnet() const {
        if (BuildData::isDebug) {
            return value("Authentification/mainnet", BuildData::mainnet).toBool();
        } else {
            return BuildData::mainnet;
        }
    }
    void setMainnet(bool value) { setValue("Authentification/mainnet", value); }
};
#endif // APPSETTINGS_H
