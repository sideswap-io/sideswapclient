#include <mainInit.h>

#include "client_rs_lib.h"

#include <QApplication>
#include <QDir>
#include <QLockFile>
#include <QMessageBox>
#include <QStandardPaths>

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    initAppSettings();

    auto dataPath = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    dataPath.mkpath(".");
    QLockFile lockFile(dataPath.filePath("data.lock"));
    if (!lockFile.tryLock()) {
       QMessageBox::critical(nullptr, "SideSwap", "Application already started");
       return 1;
    }

    setFont(app);
    initQMLData(engine, app);

    return app.exec();
}
