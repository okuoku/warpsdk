# Skip finding WARPSDK. It will define:
#  WARPSDK_AR
#  WARPSDK_WASM2C
#  WARPSDK_CLANG
#  WARPSDK_LINKER
#include(${CMAKE_CURRENT_LIST_DIR}/../../protopaths.cmake)

#get_filename_component(WARPSDK_ROOT ${CMAKE_CURRENT_LIST_DIR}/../../.. ABSOLUTE)
#set(WARPSDK_SYSROOT "${WARPSDK_ROOT}/sysroot")

#list(APPEND CMAKE_MODULE_PATH "${WARPSDK_ROOT}/cmake/Modules")

# Hacks
#if(CMAKE_HOST_WIN32)
#    # CMAKE_DIAGNOSE_UNSUPPORTED_CLANG Workaround
#    message(STATUS "Disable Host_Win32 (WAR)")
#    set(CMAKE_HOST_WIN32)
#endif()

# Warp32 specific variables
set(WARP32_TARGET_TRIPLE "wasm32")
set(WARP32_THREAD_MODEL "") # Enable Pthread defines
set(WARP32_CFLAGS_WAR "")

set(WARP32_DEFS "-D__WARP32LE__ -D__WARP32__ -D__WARP__")
set(WARP32_CFLAGS "${WARP32_CFLAGS_WAR} --target=${WARP32_TARGET_TRIPLE} -fwasm-exceptions --sysroot=${WARPSDK_SYSROOT} -I ${WARPSDK_POSIXROOT}/include")
set(WARP32_LDFLAGS "-nostdlib -Wl,--no-entry -lc")

set(UNIX 1)

# Configure compiler templates

set(CMAKE_EXECUTABLE_SUFFIX ".wasm")

set(CMAKE_AR "${WARPSDK_AR}")
foreach(lang C CXX)
    string(APPEND CMAKE_${lang}_FLAGS_INIT " ")
    string(APPEND CMAKE_${lang}_FLAGS_DEBUG_INIT " -g") # ??
    string(APPEND CMAKE_${lang}_FLAGS_MINSIZEREL_INIT " -Os -DNDEBUG")
    string(APPEND CMAKE_${lang}_FLAGS_RELEASE_INIT " -O3 -DNDEBUG")
    string(APPEND CMAKE_${lang}_FLAGS_RELWITHDEBINFO_INIT " -O2 -g -DNDEBUG")

    # Object
    set(CMAKE_${lang}_COMPILE_OBJECT "<CMAKE_${lang}_COMPILER> ${WARP32_CFLAGS} ${WARP32_DEFS} <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> -c <SOURCE>")
    set(CMAKE_DEPFILE_FLAGS_${lang} "-MD -MT <OBJECT> -MF <DEPFILE>")

    # File
    set(CMAKE_${lang}_CREATE_STATIC_LIBRARY "<CMAKE_AR> rc <TARGET> <LINK_FLAGS> <OBJECTS>")

    # Executables
    set(CMAKE_${lang}_CREATE_SHARED_MODULE
        "<CMAKE_${lang}_COMPILER> ${WARP32_LDFLAGS} ${WARP32_CFLAGS} <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
    set(CMAKE_${lang}_CREATE_SHARED_LIBRARY
        "<CMAKE_${lang}_COMPILER> ${WARP32_LDFLAGS} ${WARP32_CFLAGS} <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
    # Executables are same for shared libraries
    set(CMAKE_${lang}_LINK_EXECUTABLE
        "<CMAKE_${lang}_COMPILER> ${WARP32_LDFLAGS} ${WARP32_CFLAGS} <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
endforeach()
