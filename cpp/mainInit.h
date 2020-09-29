#ifndef MAINREGISTER_H
#define MAINREGISTER_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>
#include <QIcon>
#include "netmanager.h"
#include "addressverificationhelper.h"
#include "clipboardhelper.h"
#include "settingshelper.h"
#include "appsettings.h"


void initQMLData(QQmlApplicationEngine &engine, QGuiApplication &app)
{
    auto *rootCtx = engine.rootContext();
    rootCtx->setContextProperty("netManager", (new NetManager(rootCtx)));
    rootCtx->setContextProperty("addrHelper", (new AddressVerificationHelper(rootCtx)));
    rootCtx->setContextProperty("clipboardHelper", (new ClipboardHelper(rootCtx)));
    rootCtx->setContextProperty("settingsHelper", (new SettingsHelper(rootCtx)));
    rootCtx->setContextProperty("debug", BuildData::isDebug);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
}

void setFont(QGuiApplication &app)
{
    QFont font("Helvetica");
    font.setPixelSize(15);
    app.setFont(font);
}

void initAppSettings() {
    QCoreApplication::setOrganizationName("sideswap");
    QCoreApplication::setOrganizationDomain("sideswap.io");
    QCoreApplication::setApplicationName("sideswap");
}

#endif // MAINREGISTER_H
