# Phase0libc: picolibc

if(BUILD)
    set(builddir ${BUILD})
else()
    set(builddir ${CMAKE_CURRENT_LIST_DIR}/_localbuild/build/libc)
endif()

if(PREFIX)
    set(prefixdir ${PREFIX})
else()
    set(prefixdir ${CMAKE_CURRENT_LIST_DIR}/_localbuild/prefix/picolibc)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/lib_cmakequery.cmake)
cmakequery(${builddir})

execute_process(COMMAND
    ${CMAKE_COMMAND} 
    -S ${CMAKE_CURRENT_LIST_DIR}/picolibc
    -B ${builddir}
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/Modules
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_LIST_DIR}/sysroot
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/cmake/warp-toolchain-phase0.cmake
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DPOSIX_CONSOLE=ON
    -G Ninja
    RESULT_VARIABLE rr
)

if(rr)
    message(FATAL_ERROR "Failed to configure picolibc")
endif()

execute_process(COMMAND
    ${CMAKE_COMMAND}
    --build ${builddir}
    RESULT_VARIABLE rr
)

if(rr)
    message(FATAL_ERROR "Failed to build picolibc")
endif()

execute_process(COMMAND
    ${CMAKE_COMMAND}
    --install ${builddir}
    --prefix ${prefixdir}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR "Failed to install picolibc")
endif()
