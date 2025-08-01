#
# INPUTs:
#   TOOL: ar | ld | nm
#

include(${CMAKE_CURRENT_LIST_DIR}/_sdkpaths.cmake) # => toolchain_prefix
include(${CMAKE_CURRENT_LIST_DIR}/_arginput.cmake) # => args

if(NOT TOOL)
    message(FATAL_ERROR "TOOL is required")
endif()

if("${TOOL}" STREQUAL ar)
    set(toolbin ${toolchain_prefix}/bin/llvm-ar)
elseif("${TOOL}" STREQUAL ld)
    set(toolbin ${toolchain_prefix}/bin/wasm-ld)
elseif("${TOOL}" STREQUAL nm)
    set(toolbin ${toolchain_prefix}/bin/llvm-nm)
else()
    message(FATAL_ERROR "Unknown tool [${TOOL}]")
endif()

execute_process(COMMAND
    ${toolbin} ${args}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR 
        "Failed to execute [${TOOL}] ${toolbin} [${rr}] [${args}]")
endif()
