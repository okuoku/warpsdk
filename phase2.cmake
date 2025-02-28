execute_process(COMMAND
    ${CMAKE_COMMAND} 
    -S ${CMAKE_CURRENT_LIST_DIR}/llvm-project/runtimes
    -B ${CMAKE_CURRENT_LIST_DIR}/build-runtimes
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/Modules
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_LIST_DIR}/sysroot
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/cmake/warp-toolchain.cmake
    #"-DLLVM_ENABLE_RUNTIMES=libunwind;libcxxabi;libcxx;compiler-rt"
    "-DLLVM_ENABLE_RUNTIMES=libcxx;compiler-rt"
    -DLIBCXX_ENABLE_THREADS=OFF
    -DLIBCXX_ENABLE_FILESYSTEM=OFF
    -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
    -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
    -G Ninja)

