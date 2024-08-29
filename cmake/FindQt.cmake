
# 查找Qt
set(CMAKE_AUTOMOC ON) # 启用自动moc
set(CMAKE_AUTORCC ON) # 启用自动rcc
set(CMAKE_AUTOUIC ON) # 启用自动uic

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Gui QuickControls2 Qml Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Gui QuickControls2 Qml Widgets)

list(APPEND QT_PLUGINS Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Gui Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Qml Qt${QT_VERSION_MAJOR}::QuickControls2)

set(QT_SDK_DIR "${Qt6_DIR}/../../..")
cmake_path(SET QT_SDK_DIR NORMALIZE ${QT_SDK_DIR})
#设置QML插件输出目录，可以通过外部设置，如果外部没有设置就默认到<QT_SDK_DIR_PATH>\Controls\ElementUI目录下
set(QT_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to QML Plugin")
if (NOT QT_QML_PLUGIN_DIRECTORY)
    set(QT_QML_PLUGIN_DIRECTORY ${QT_SDK_DIR}qml/)
endif ()

message(STATUS "============================================================================")
message(STATUS "QT_VERSION=${QT_VERSION}")
message(STATUS "QT_VERSION_MAJOR=${QT_VERSION_MAJOR}")
message(STATUS "QT_QML_PLUGIN_DIRECTORY=${QT_QML_PLUGIN_DIRECTORY}")
message(STATUS "QT_PLUGINS=${QT_PLUGINS}")
message(STATUS "Qt${QT_VERSION_MAJOR}Quick_PRIVATE_INCLUDE_DIRS=${Qt${QT_VERSION_MAJOR}Quick_PRIVATE_INCLUDE_DIRS}")
message(STATUS "Qt${QT_VERSION_MAJOR}Gui_PRIVATE_INCLUDE_DIRS=${Qt${QT_VERSION_MAJOR}Gui_PRIVATE_INCLUDE_DIRS}")
message(STATUS "============================================================================")


macro(qt_compat_add_library var)
    if (${ARGV1} STREQUAL "ON")
        #message("ON")
        qt_add_library(${var} SHARED)
    else ()
        #message("OFF")
        qt_add_library(${var} STATIC)
    endif ()
endmacro()


macro(qt_compat_add_executable var)
    if (${QT_VERSION_MAJOR} STREQUAL "6")
        qt_add_executable(${var})
    else ()
        add_executable(${var})
    endif ()
endmacro()

macro(qt_compat_add_qml_module _target PLUGIN_TARGET)
    message(STATUS "qt_compat_add_qml_module: ${_target} ${PLUGIN_TARGET}")
endmacro()

