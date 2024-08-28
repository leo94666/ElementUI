#pragma once

#include <QObject>
#include "Singleton.h"

class Application : public QObject {
    Q_OBJECT

public:
    SINGLETON(Application)
    [[nodiscard]] int init() const;

private:
    const int _major = 1;
    const int _minor = 0;
    const char *_uri = "ElementUI";
};