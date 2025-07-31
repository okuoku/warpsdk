if(BUILD)
    set(builddir ${BUILD})
else()
    set(builddir ${CMAKE_CURRENT_LIST_DIR}/build-runtimes)
endif()

if(PREFIX)
    set(prefixdir ${PREFIX})
else()
    set(prefixdir ${CMAKE_CURRENT_LIST_DIR}/prefix/llvm-runtimes)
endif()

set(querydir ${builddir}/.cmake/api/v1/query/client-yuniwarp)
file(MAKE_DIRECTORY ${querydir})

file(COPY_FILE ${CMAKE_CURRENT_LIST_DIR}/query.json ${querydir}/query.json)

execute_process(COMMAND
    ${CMAKE_COMMAND} 
    -S ${CMAKE_CURRENT_LIST_DIR}/llvm-project/runtimes
    -B ${builddir}
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/Modules
    -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_LIST_DIR}/sysroot
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/cmake/warp-toolchain-phase1.cmake
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    "-DLLVM_ENABLE_RUNTIMES=libunwind;libcxxabi;libcxx;compiler-rt"
    -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
    -DCOMPILER_RT_BAREMETAL_BUILD=ON
    -DLIBCXX_HAS_EXTERNAL_THREAD_API=ON
    -DLIBCXX_HAS_PTHREAD_API=OFF # To use external thread API
    -DLIBCXX_ENABLE_THREADS=ON
    -DLIBCXX_ENABLE_FILESYSTEM=OFF
    -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
    -DLIBCXX_ENABLE_SHARED=OFF
    -DLIBCXXABI_ENABLE_SHARED=OFF
    -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
    -DLIBUNWIND_ENABLE_SHARED=OFF
    -DLIBUNWIND_HIDE_SYMBOLS=ON
    -DCMAKE_C_COMPILER_TARGET=wasm32 # Should we have this on the toolchain file ???
    -G Ninja
    RESULT_VARIABLE rr
)

if(rr)
    message(FATAL_ERROR "Failed to configure LLVM runtimes")
endif()

execute_process(COMMAND
    ${CMAKE_COMMAND}
    --build
    ${builddir}
    RESULT_VARIABLE rr
)

if(rr)
    message(FATAL_ERROR "Failed to build LLVM runtimes")
endif()

execute_process(COMMAND
    ${CMAKE_COMMAND}
    --install
    ${builddir}
    --prefix
    ${prefixdir}
    RESULT_VARIABLE rr)

if(rr)
    message(FATAL_ERROR "Failed to install LLVM runtimes")
endif()
