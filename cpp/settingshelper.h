#ifndef SETTINGSHELPER_H
#define SETTINGSHELPER_H

#include <QObject>
#include <appsettings.h>

class SettingsHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool showWizard READ showWizard WRITE setShowWizard NOTIFY showWizardChanged)

public:
    SettingsHelper(QObject *parent);
    ~SettingsHelper() override = default;
    bool showWizard() const;

public slots:
    void setShowWizard(bool value);

signals:
    void showWizardChanged();
};

#endif // SETTINGSHELPER_H
