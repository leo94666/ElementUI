
project(ElementUI VERSION 1.0.0 LANGUAGES CXX)

set(ElementUIPlugin "elementuiplugin")

include_directories(include)

collect(FILES_SOURCE "*.cpp" core quick)
collect(FILES_HEADER "*.h" include)

file(GLOB_RECURSE ALL_SOURCE "core/*.*" "include/*.h")

if(${QT_VERSION_MAJOR} LESS 6)
    message(STATUS "QT_VERSION 5")
    collect(FILES_RESOURCE "*.qml" Qt5)
elseif ()
    message(STATUS "QT_VERSION 6")
    collect(FILES_RESOURCE "*.qml" Qt6)
endif ()


qt_add_library(${ElementUIPlugin} SHARED)

qt_add_qml_module(${ElementUIPlugin}
        PLUGIN_TARGET ${ElementUIPlugin}
        OUTPUT_DIRECTORY ${QT_QML_PLUGIN_DIRECTORY}${PROJECT_NAME}
        VERSION 1.0
        URI ${PROJECT_NAME}
        TYPEINFO "plugins.qmltypes"
        SOURCES ${ALL_SOURCE}
        QML_FILES ${FILES_QML}
        RESOURCES ${FILES_RESOURCES}
        RESOURCE_PREFIX "/qt/qml"
)


