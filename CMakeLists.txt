cmake_minimum_required(VERSION 3.28)
project(Element VERSION 1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)

#set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/_out/${CMAKE_BUILD_TYPE})

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    message(STATUS "This is Linux system.")
elseif(CMAKE_SYSTEM_NAME MATCHES "Windows")
    message(STATUS "This is Windows system.")
    if (MSVC)
        set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/msvc2019_64")
    elseif (MINGW)
        set(CMAKE_PREFIX_PATH "C:/Qt/6.7.2/mingw_64")
    endif ()
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    message(STATUS "This is MacOS system.")
    set(CMAKE_PREFIX_PATH "/Users/li/Qt/6.7.2/macos")
else()
    message(STATUS "Other system: ${CMAKE_SYSTEM_NAME}")
endif()

# 包含自定义CMake模块的路径
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Function)
include(FindQt)

add_subdirectory(src)

add_subdirectory(sample)