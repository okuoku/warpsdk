if(NOT YUNIWARP_PLATFORM_PHASE)
    message(FATAL_ERROR "No Yuniwarp platform phase defined.")
endif()

# Warp32 specific variables
set(WARP32_TARGET_TRIPLE "wasm32")
set(WARP32_THREAD_MODEL "") # Enable Pthread defines
set(WARP32_CFLAGS_WAR "")

set(WARP32_DEFS "-D__WARP32LE__ -D__WARP32__ -D__WARP__")
set(WARP32_ABIFLAGS "-matomics -mbulk-memory")

set(WARP32_BUILTIN_LIB "${WARPSDK_SYSROOT}/lib/yuniwarpphase1/libclang_rt.builtins-wasm32.a")
set(WARM32_WORKAROUND_SYMBOLS " -Wl,--allow-undefined-file=${WARPSDK_POSIXROOT}/workaround.syms")

if(${YUNIWARP_PLATFORM_PHASE} STREQUAL "final")
    set(WARP32_CFLAGS "${WARP32_ABIFLAGS} ${WARP32_CFLAGS_WAR} --target=${WARP32_TARGET_TRIPLE} -fwasm-exceptions --sysroot=${WARPSDK_SYSROOT} -I ${WARPSDK_POSIXROOT}/include")
    set(WARP32_LDFLAGS "-nostdlib -Xlinker --import-memory=env,memory -Wl,--shared-memory -Wl,--no-entry -lc -lc++ -lc++abi -lunwind ${WARP32_BUILTIN_LIB} ${WARM32_WORKAROUND_SYMBOLS} -Wl,--error-limit=0")
elseif(${YUNIWARP_PLATFORM_PHASE} STREQUAL "phase0")
    # In libc build
    set(WARP32_CFLAGS "${WARP32_ABIFLAGS} ${WARP32_CFLAGS_WAR} --target=${WARP32_TARGET_TRIPLE} -fwasm-exceptions --sysroot=")
    set(WARP32_LDFLAGS "-nostdlib -Wl,--no-entry")
elseif(${YUNIWARP_PLATFORM_PHASE} STREQUAL "phase1")
    # In LLVM runtime libraries build (libc++, libcxxabi, ...)
    if(DEFINED ENV{WARP_PICOLIBC_PREFIX})
        cmake_path(SET WARPSDK_SYSROOT NORMALIZE "$ENV{WARP_PICOLIBC_PREFIX}")
        message(STATUS "Override sysroot with ${WARPSDK_SYSROOT}")
    endif()
    set(WARP32_CFLAGS "${WARP32_ABIFLAGS} ${WARP32_CFLAGS_WAR} --target=${WARP32_TARGET_TRIPLE} -fwasm-exceptions --sysroot=${WARPSDK_SYSROOT} -I ${WARPSDK_POSIXROOT}/include")
    set(WARP32_LDFLAGS "-nostdlib -Wl,--no-entry -lc")
else()
    message(FATAL_ERROR "Unrecognized platform phase: [${YUNIWARP_PLATFORM_PHASE]")
endif()

set(UNIX 1)

# Configure compiler templates

set(CMAKE_EXECUTABLE_SUFFIX ".wasm")

set(CMAKE_AR "${WARPSDK_AR}")
foreach(lang C CXX ASM)
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
