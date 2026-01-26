# Prerequisite: build-llvm.cmake to build toolchain

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
runphase(phase1)
