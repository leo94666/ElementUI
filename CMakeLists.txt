cmake_minimum_required(VERSION 3.28)
project(Element VERSION 1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

#set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})

if (MSVC)
    set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/msvc2019_64")
elseif (MINGW)
    set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/mingw_64")
endif ()

# 包含自定义CMake模块的路径
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Function)
include(FindQt)

add_subdirectory(src)

add_subdirectory(sample)