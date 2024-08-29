cmake_minimum_required(VERSION 3.20)

project(Sample VERSION 1.0)

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        main.cpp
        sample.qrc
)


target_link_libraries(${PROJECT_NAME} PRIVATE
        ${QT_PLUGINS}
        Element::UI
)


install(TARGETS ${PROJECT_NAME} ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)

