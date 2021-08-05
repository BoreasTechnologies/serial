cmake_minimum_required(VERSION 3.14)

include(buildInfo.cmake)
parseVersion(SERIAL)

project(serial VERSION ${SERIAL_VERSION_SHORT})

if (WIN32)
    set(serial_SRCS
            src/serial.cc
            include/serial/serial.h
            include/serial/v8stdint.h
            src/impl/win.cc
            src/impl/list_ports/list_ports_win.cc
            )
else()
    set(serial_SRCS
            src/serial.cc
            include/serial/serial.h
            include/serial/v8stdint.h
            src/impl/unix.cc
            src/impl/list_ports/list_ports_linux.cc
            )
endif()

add_library(${PROJECT_NAME} ${serial_SRCS})

if (WIN32)
    target_link_libraries(${PROJECT_NAME} setupapi)
else()
    target_link_libraries(${PROJECT_NAME})
endif()

target_include_directories(${PROJECT_NAME} PUBLIC include)
