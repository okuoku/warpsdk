# Prerequisite: build-llvm.cmake to build toolchain

set(sysroot ${CMAKE_CURRENT_LIST_DIR}/sysroot)

if(WIN32)
    message(FATAL_ERROR notyet)
else()
    set(ENV{PATH} 
        "${CMAKE_CURRENT_LIST_DIR}/_build/pkg/llvm/bin:$ENV{PATH}")
endif()

function(runphase phase)
    execute_process(COMMAND
        ${CMAKE_COMMAND} -P ${phase}.cmake
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        RESULT_VARIABLE rr
    )
    if(rr)
        message(FATAL_ERROR "Error (phase: ${phase}) ${rr}")
    endif()
endfunction()

runphase(phase0crt)
runphase(phase0libc)
if(EXISTS "${sysroot}")
    file(REMOVE_RECURSE "${sysroot}")
endif()
file(COPY 
    ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/picolibc/lib
    ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/picolibc/include
    DESTINATION ${sysroot})
runphase(phase1)

include(${CMAKE_CURRENT_LIST_DIR}/lib_genpkg.cmake)
genpkg(warp-crt "0.0" 
    ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/crt)
genpkg(warp-picolibc "0.0" 
    ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/picolibc)
genpkg(warp-llvm-rt "0.0" 
    ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/llvm-runtimes)
