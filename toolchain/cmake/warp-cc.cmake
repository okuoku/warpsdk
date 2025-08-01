# 
# INPUTs:
#   KERNEL: (BOOL) Use freestanding setting
#   CXX: (BOOL) True if we call C++ frontend
#
#   ENV{WARP_TOOLCHAIN_PREFIX}: Native prefix for LLVM binaries
#   ENV{WARP_SYSROOT_PREFIX}: Sysroot prefix

include(${CMAKE_CURRENT_LIST_DIR}/_sdkpaths.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/_arginput.cmake) # => args

set(IN_LINK true)
if(CXX)
    set(cxx ON)
else()
    set(cxx OFF)
endif()

set(userargs)
set(fetchnext)
foreach(e ${args})
    if("${e}" STREQUAL -c OR "${e}" STREQUAL -E OR
            "${e}" STREQUAL -r)
        set(IN_LINK)
    endif()
    if(NOT fetchnext)
        if("${e}" STREQUAL -x)
            set(fetchnext ${e})
        endif()
    else()
        if("${fetchnext}" STREQUAL -x)
            if("${e}" STREQUAL c)
                set(cxx)
            elseif("${e}" STREQUAL c++)
                set(cxx ON)
            endif()
            set(fetchnext)
        endif()
    endif()
    if("${e}" STREQUAL "-Wl,--start-group"
            OR "${e}" STREQUAL "-Wl,--end-group")
        # Remove --start-group, --end-group since wasm-ld lacks it
    else()
        list(APPEND userargs "${e}")
    endif()
endforeach()

set(features
    -Xclang -target-feature
    -Xclang +atomics)

if(KERNEL)
    set(argprefix --target=wasm32 -ffreestanding ${features})
else()
    set(argprefix --target=wasm32 -fPIC 
        -nostdinc 
        -isystem ${toolchain_prefix}/lib/clang/20/include
        -isystem ${sysroot_prefix}/include
        ${features}
    )
endif()

if(IN_LINK)
    if(KERNEL)

    else()
        list(APPEND argprefix -nostdlib -shared
            -L${sysroot_prefix}/lib -lm -Wl,--no-entry -Wl,--export=_start_c
            ${sysroot_prefix}/lib/crt1.o -lc)
        if(cxx)
            list(APPEND argprefix -lc++)
        endif()
    endif()
endif()

execute_process(
    COMMAND ${toolchain_prefix}/bin/clang
    ${argprefix}
    ${userargs}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR "Err: ${rr}")
endif()
