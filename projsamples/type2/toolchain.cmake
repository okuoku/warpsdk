cmake_path(SET warpsdk_state NORMALIZE ${CMAKE_BINARY_DIR}/warpsdk_state)

if(NOT EXISTS "${warpsdk_state}")
    file(MAKE_DIRECTORY "${warpsdk_state}")
endif()

cmake_path(SET warpsdk_vars NORMALIZE "${warpsdk_state}/warpsdk-vars.cmake")
if(NOT EXISTS "${warpsdk_vars}")
    execute_process(COMMAND
        ${CMAKE_COMMAND} "-DSTATEDIR=${warpsdk_state}"
        -P "${CMAKE_CURRENT_LIST_DIR}/warpsdk-setup.cmake"
        RESULT_VARIABLE rr
    )
    if(rr)
        message(FATAL_ERROR "Failed to setup Warp SDK")
    endif()
endif()

include("${warpsdk_vars}")

# FIXME: Continue to Warp SDK toolchain file
