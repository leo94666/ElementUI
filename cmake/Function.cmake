


# ----------------------------------
# CMake API
# ----------------------------------
macro(qwk_add_library _target)
    set(options AUTOGEN NO_SYNC_INCLUDE NO_WIN_RC)
    set(oneValueArgs SYNC_INCLUDE_PREFIX PREFIX)
    set(multiValueArgs SYNC_INCLUDE_OPTIONS)
    cmake_parse_arguments(FUNC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(FUNC_AUTOGEN)
        set(CMAKE_AUTOMOC ON)
        set(CMAKE_AUTOUIC ON)
        set(CMAKE_AUTORCC ON)
    endif()

    if(QWINDOWKIT_BUILD_STATIC)
        set(_type STATIC)
    else()
        set(_type SHARED)
    endif()

    add_library(${_target} ${_type})

    if(WIN32 AND NOT FUNC_NO_WIN_RC AND(${_type} STREQUAL "SHARED"))
        qm_add_win_rc(${_target}
                NAME ${QWINDOWKIT_INSTALL_NAME}
                DESCRIPTION ${QWINDOWKIT_PROJECT_DESCRIPTION}
                COPYRIGHT ${QWINDOWKIT_PROJECT_COPYRIGHT}
        )
    endif()

    if(FUNC_PREFIX)
        set(_prefix_option PREFIX ${FUNC_PREFIX})
    else()
        set(_prefix_option)
    endif()

    # Set global definitions
    qm_export_defines(${_target} ${_prefix_option})

    # Configure target
    qm_configure_target(${_target} ${FUNC_UNPARSED_ARGUMENTS})

    # Add include directories
    target_include_directories(${_target} PRIVATE ${QWINDOWKIT_BUILD_INCLUDE_DIR})
    target_include_directories(${_target} PRIVATE .)

    # Library name
    if(${_target} MATCHES "^QWK(.+)")
        set(_name ${CMAKE_MATCH_1})
        set_target_properties(${_target} PROPERTIES EXPORT_NAME ${_name})
    else()
        set(_name ${_target})
    endif()

    add_library(${QWINDOWKIT_INSTALL_NAME}::${_name} ALIAS ${_target})

    if(FUNC_SYNC_INCLUDE_PREFIX)
        set(_inc_name ${FUNC_SYNC_INCLUDE_PREFIX})
    else()
        set(_inc_name ${_target})
    endif()

    set(_install_options)

    if(QWINDOWKIT_INSTALL)
        install(TARGETS ${_target}
                EXPORT ${QWINDOWKIT_INSTALL_NAME}Targets
                RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" OPTIONAL
                LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}" OPTIONAL
                ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" OPTIONAL
        )

        target_include_directories(${_target} PUBLIC
                "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${QWINDOWKIT_INSTALL_NAME}>"
        )

        set(_install_options
                INSTALL_DIR "${CMAKE_INSTALL_INCLUDEDIR}/${QWINDOWKIT_INSTALL_NAME}/${_inc_name}"
        )
    endif()

    if(NOT FUNC_NO_SYNC_INCLUDE)
        # Generate a standard include directory in build directory
        qm_sync_include(. "${QWINDOWKIT_GENERATED_INCLUDE_DIR}/${_inc_name}" ${_install_options}
                ${FUNC_SYNC_INCLUDE_OPTIONS} FORCE
        )
        target_include_directories(${_target} PUBLIC
                "$<BUILD_INTERFACE:${QWINDOWKIT_GENERATED_INCLUDE_DIR}>"
        )
    endif()
endmacro()


# 定义一个宏，用于递归查找文件，并允许自定义排除模式
macro(collect var pattern)

    #message("collect argument count: ${ARGC}, all arguments: ${ARGV}")
    #message("all arguments: ${ARGV}")
    #message("optional arguments: ${ARGN}")

    if(${ARGC} LESS 2)
        message(FATAL_ERROR "collect macro requires at least two argument")
    elseif (${ARGC} EQUAL 2)
        set(DIRS ${CMAKE_CURRENT_SOURCE_DIR})
    elseif (${ARGC} GREATER 2)
        set(DIRS ${ARGN})
    endif ()

    set(${var} "")
    foreach (_dir IN ITEMS ${DIRS})
        #file(GLOB_RECURSE _files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}${_dir} ${pattern})
        file(GLOB_RECURSE _files ${CMAKE_CURRENT_SOURCE_DIR}${_dir} ${pattern})
        foreach(_file IN LISTS _files)
            list(APPEND ${var} ${_file})
        endforeach()
    endforeach ()

    message(STATUS "collect ${_files} in ${var}")
endmacro()
