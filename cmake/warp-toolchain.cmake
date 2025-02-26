include(${CMAKE_CURRENT_LIST_DIR}/../protopaths.cmake)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_SYSTEM_NAME Yuniwarp)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_CROSSCOMPILING TRUE)

foreach(lang C CXX)
    set(CMAKE_${lang}_COMPILER "${WARPSDK_CLANG}")
    set(CMAKE_${lang}_COMPILER_ID Clang)
    set(CMAKE_${lang}_COMPILER_WORKS TRUE)
endforeach()
