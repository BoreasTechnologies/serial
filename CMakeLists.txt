cmake_minimum_required(VERSION 3.14)

include(buildInfo.cmake)
parseVersion(SERIAL)

project(serial VERSION ${SERIAL_VERSION_SHORT})

set(serial_SRCS
        src/serial.cc
        include/serial/serial.h
        include/serial/v8stdint.h
        src/impl/win.cc
        src/impl/list_ports/list_ports_win.cc
        )

add_library(${PROJECT_NAME} ${serial_SRCS})
target_link_libraries(${PROJECT_NAME} setupapi)
target_include_directories(${PROJECT_NAME} PUBLIC include)