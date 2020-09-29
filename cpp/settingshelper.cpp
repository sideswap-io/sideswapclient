#include "settingshelper.h"
#include "appsettings.h"

SettingsHelper::SettingsHelper(QObject *parent)
    : QObject(parent)
{
}

bool SettingsHelper::showWizard() const
{
    return AppSettings::get()->showWizard();
}

void SettingsHelper::setShowWizard(bool value)
{
    Q_UNUSED(value);
    AppSettings::get()->setWizardShowed();
}

