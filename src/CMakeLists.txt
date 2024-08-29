
project(ElementUI VERSION 1.0.0 LANGUAGES CXX)


option(BUILD_SHARED_LIBS "Build shared libraries" ON)


set(ElementUIPlugin "elementuiplugin")

include_directories(include)
include_directories(core)
include_directories(core/contexts)
include_directories(core/kernel)
include_directories(core/shared)
include_directories(core/style)
include_directories(quick)

add_compile_definitions(QWK_CORE_LIBRARY)
add_compile_definitions(QWK_QUICK_LIBRARY)


if (MSVC)
    #告诉链接器在生成可执行文件时不生成清单文件
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /manifest:no")
    #告诉链接器在生成模块时不生成清单文件
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /manifest:no")
    #告诉链接器在生成共享库时不生成清单文件
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /manifest:no")
    #添加 /utf-8 编译器选项
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8")
    #自动导出所有具有默认可见性（即没有明确声明为 __declspec(dllexport) 或 __declspec(dllimport)）的全局符号
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

    if(NOT DEFINED CMAKE_DEBUG_POSTFIX)
        #指定在生成的可执行文件或库文件的名称后添加的后缀
        set(CMAKE_DEBUG_POSTFIX "d")
    endif()
elseif (MINGW)
    set(CMAKE_STATIC_LIBRARY_PREFIX "")
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif ()
#collect(FILES_SOURCE "core/*.cpp" "quick/*.cpp")
#collect(FILES_HEADER "include/*.h" "core/context/*.h" "core/kernel/*.h")
#collect(ALL_SOURCE "include/*.h" "core/*" "quick/*" "Application.cpp")

set(_src
        core/qwkconfig.h
        core/qwkglobal.h
        core/qwkglobal_p.h
        core/qwkglobal.cpp
        core/windowagentbase.h
        core/windowagentbase_p.h
        core/windowagentbase.cpp
        core/windowitemdelegate_p.h
        core/windowitemdelegate.cpp
        core/kernel/nativeeventfilter_p.h
        core/kernel/nativeeventfilter.cpp
        core/kernel/sharedeventfilter_p.h
        core/kernel/sharedeventfilter.cpp
        core/kernel/winidchangeeventfilter_p.h
        core/kernel/winidchangeeventfilter.cpp
        core/shared/systemwindow_p.h
        core/contexts/abstractwindowcontext_p.h
        core/contexts/abstractwindowcontext.cpp
        core/style/styleagent.h
        core/style/styleagent_p.h
        core/style/styleagent.cpp

        quick/qwkquickglobal.h
        quick/qwkquickglobal.cpp
        quick/quickitemdelegate_p.h
        quick/quickitemdelegate.cpp
        quick/quickwindowagent.h
        quick/quickwindowagent_p.h
        quick/quickwindowagent.cpp
)

if (WIN32)
    list(APPEND _src
            core/qwindowkit_windows.h
            core/qwindowkit_windows.cpp
            core/shared/qwkwindowsextra_p.h
            core/shared/windows10borderhandler_p.h
            core/contexts/win32windowcontext_p.h
            core/contexts/win32windowcontext.cpp
            core/style/styleagent_win.cpp
            quick/quickwindowagent_win.cpp
    )

    list(APPEND _links_private uxtheme)

elseif (APPLE)
    list(APPEND _src
            core/contexts/cocoawindowcontext_p.h
            core/contexts/cocoawindowcontext.mm
            core/style/styleagent_mac.mm
            quick/quickwindowagent_mac.cpp
    )
    list(APPEND _links_private
            "-framework Foundation"
            "-framework Cocoa"
            "-framework AppKit"
    )
else ()
    list(APPEND _src
            core/qwindowkit_linux.h
            core/contexts/qtwindowcontext_p.h
            core/contexts/qtwindowcontext.cpp
            core/style/styleagent_linux.cpp
    )
endif ()

if (${QT_VERSION_MAJOR} EQUAL 6)
    collect_relative(FILES_QML "Qt6/Controls/*.qml")
    collect_relative(FILES_RESOURCE "Qt6/Font/*.ttf" "Qt6/Image/*.png" "Qt6/Image/*.svg")
elseif ()
    collect_relative(FILES_QML "Qt5/Controls/*.qml")
    collect_relative(FILES_RESOURCE "Qt6/Font/*.ttf" "Qt6/Image/*.png" "Qt6/Image/*.svg")
endif ()

#修改资源文件导出路径
foreach (filepath IN LISTS FILES_RESOURCE FILES_QML)
    string(REPLACE "Qt${QT_VERSION_MAJOR}/" "" filename ${filepath})
    set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})
endforeach ()

qt_compat_add_library(${ElementUIPlugin} BUILD_SHARED_LIBS)

qt_add_qml_module(${ElementUIPlugin}
        PLUGIN_TARGET ${ElementUIPlugin}
        OUTPUT_DIRECTORY ${QT_QML_PLUGIN_DIRECTORY}${PROJECT_NAME}
        VERSION 1.0
        URI ${PROJECT_NAME}
        TYPEINFO "plugins.qmltypes"
        SOURCES ${_src}
        QML_FILES ${FILES_QML}
        RESOURCES ${FILES_RESOURCE}
        RESOURCE_PREFIX "/qt/qml"
)

target_link_libraries(${ElementUIPlugin} PUBLIC
        ${QT_PLUGINS}
)

#解决引入Qt私有头文件的问题
target_include_directories(${ElementUIPlugin} PUBLIC quick ${Qt${QT_VERSION_MAJOR}Gui_PRIVATE_INCLUDE_DIRS} ${Qt${QT_VERSION_MAJOR}Quick_PRIVATE_INCLUDE_DIRS})

add_library(Element::UI ALIAS ${ElementUIPlugin})

add_custom_command(
        TARGET ${ElementUIPlugin}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${QT_QML_PLUGIN_DIRECTORY}${PROJECT_NAME}/${ElementUIPlugin}${CMAKE_DEBUG_POSTFIX}.dll
        ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${ElementUIPlugin}${CMAKE_DEBUG_POSTFIX}.dll
)

install(TARGETS ${ElementUIPlugin} ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)