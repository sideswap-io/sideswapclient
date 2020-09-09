#ifndef SETTINGSHELPER_H
#define SETTINGSHELPER_H

#include <QObject>
#include <appsettings.h>

class SettingsHelper : public QObject
{
    Q_OBJECT
    // Debug options
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(bool useTls READ useTls WRITE setUseTls NOTIFY useTlsChanged)
    Q_PROPERTY(bool mainnet READ mainnet WRITE setMainnet NOTIFY mainnetChanged)

public:
    SettingsHelper(QObject *parent);
    ~SettingsHelper() override = default;

    QString host() const;
    int port() const;
    bool useTls() const;
    bool mainnet() const;

public slots:
    void setHost(QString host);
    void setPort(int port);
    void setUseTls(bool value);
    void setMainnet(bool value);

signals:
    void hostChanged();
    void portChanged();
    void useTlsChanged();
    void mainnetChanged();
    void walletSettingsChanged();
};

#endif // SETTINGSHELPER_H
