//
// Created by licod on 2024/8/16.
//

#include <QApplication>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QProcess>
#include <QQmlApplicationEngine>
#include <QQmlEngineExtensionPlugin>
#include "qwkquickglobal.h"

int main(int argc, char *argv[]) {
    QApplication::setOrganizationName("Leo");
    QApplication::setOrganizationDomain("https://github.com/leo94666");
    QApplication::setApplicationName("ElementUI");
    QApplication::setApplicationDisplayName("sample");
    QApplication::setApplicationVersion("");
    QApplication app(argc, argv);

    QQuickWindow::setDefaultAlphaBuffer(true);

    QQmlApplicationEngine engine;

    QWK::registerTypes(&engine);

    const QUrl url(QStringLiteral("qrc:/sample/qml/App.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);



    return app.exec();
}
