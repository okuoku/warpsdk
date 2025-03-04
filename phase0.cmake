set(builddir ${CMAKE_CURRENT_LIST_DIR}/build-libc)
set(querydir ${builddir}/.cmake/api/v1/query/client-yuniwarp)
file(MAKE_DIRECTORY ${querydir})

file(COPY_FILE ${CMAKE_CURRENT_LIST_DIR}/query.json ${querydir}/query.json)

execute_process(COMMAND
    ${CMAKE_COMMAND} 
    -S ${CMAKE_CURRENT_LIST_DIR}/picolibc
    -B ${builddir}
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/Modules
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_LIST_DIR}/sysroot
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/cmake/warp-toolchain-phase0.cmake
    -G Ninja)

