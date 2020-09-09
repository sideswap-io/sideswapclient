#include "settingshelper.h"
#include "appsettings.h"

SettingsHelper::SettingsHelper(QObject *parent)
    : QObject(parent)
{
}

QString SettingsHelper::host() const
{
    return AppSettings::get()->host();
}

int SettingsHelper::port() const
{
   return AppSettings::get()->port();
}

bool SettingsHelper::useTls() const
{
   return AppSettings::get()->useTls();
}

bool SettingsHelper::mainnet() const
{
    return AppSettings::get()->mainnet();
}

void SettingsHelper::setHost(QString host)
{
    if (AppSettings::get()->host() != host) {
        AppSettings::get()->setHost(host);
        emit hostChanged();
    }
}

void SettingsHelper::setPort(int port)
{
    if (AppSettings::get()->port() != port) {
        AppSettings::get()->setPort(port);
        emit portChanged();
    }
}

void SettingsHelper::setUseTls(bool value)
{
   if (AppSettings::get()->useTls() != value) {
       AppSettings::get()->setUseTls(value);
       emit useTlsChanged();
   }
}

void SettingsHelper::setMainnet(bool value)
{
    if (AppSettings::get()->mainnet() != value) {
        AppSettings::get()->setMainnet(value);
        emit mainnetChanged();
    }
}
