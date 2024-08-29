cmake_minimum_required(VERSION 3.28)
project(Element VERSION 1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

if (MSVC)
    set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/msvc2019_64")
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
    set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/mingw_64")
    set(CMAKE_STATIC_LIBRARY_PREFIX "")
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif ()

# 包含自定义CMake模块的路径
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Function)
include(FindQt)

add_subdirectory(src)

add_subdirectory(sample)