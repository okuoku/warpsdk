execute_process(COMMAND
    ${CMAKE_COMMAND} 
    -S ${CMAKE_CURRENT_LIST_DIR}/picolibc
    -B ${CMAKE_CURRENT_LIST_DIR}/build-libc
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/Modules
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_LIST_DIR}/sysroot
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/cmake/warp-toolchain-phase0.cmake
    -G Ninja)

