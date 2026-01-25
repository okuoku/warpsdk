cmake_path(SET llvm NORMALIZE ${CMAKE_CURRENT_LIST_DIR}/llvm-project/llvm)
cmake_path(SET llvm_build NORMALIZE ${CMAKE_CURRENT_LIST_DIR}/_build/build/llvm)
cmake_path(SET llvm_prefix NORMALIZE ${CMAKE_CURRENT_LIST_DIR}/_build/prefix/llvm)
cmake_path(SET llvm_pkgdest NORMALIZE ${CMAKE_CURRENT_LIST_DIR}/_build/pkg/llvm)

if(EXISTS "${llvm_pkgdest}")
    file(REMOVE_RECURSE "${llvm_pkgdest}")
endif()

file(MAKE_DIRECTORY "${llvm_pkgdest}")

set(win_options
    -DLLVM_ENABLE_RPMALLOC=OFF 
    -DLLVM_STATIC_LINK_CXX_STDLIB=ON
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
    -DPython3_EXECUTABLE=c:/python3/python.exe
)

function(runbuild)
    # Configure
    execute_process(COMMAND
        ${CMAKE_COMMAND} 
        -S ${llvm}
        -B ${llvm_build}
        -G Ninja
        "-DLLVM_ENABLE_PROJECTS=lld;lldb;clang;clang-tools-extra"
        -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_INCLUDE_TESTS=OFF -DLLVM_PARALLEL_LINK_JOBS=1
        "-DLLVM_TARGETS_TO_BUILD=AArch64;ARM;AVR;RISCV;WebAssembly;X86"
        -DCMAKE_INSTALL_PREFIX=${llvm_prefix}
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
        -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
        RESULT_VARIABLE rr
    )

    if(rr)
        message(FATAL_ERROR "Config err ${rr}")
    endif()

    # Build
    execute_process(COMMAND
        ${CMAKE_COMMAND} --build ${llvm_build}
        RESULT_VARIABLE rr)

    if(rr)
        message(FATAL_ERROR "Build error ${rr}")
    endif()

    # Install
    execute_process(COMMAND
        ${CMAKE_COMMAND} --install ${llvm_build}
        RESULT_VARIABLE rr)

    if(rr)
        message(FATAL_ERROR "Install error ${rr}")
    endif()
endfunction()

set(llvm_pickup_bin
    # Clang
    clang clang++ clangd 

    # LLDB
    lldb lldb-dap 

    # LLD
    wasm-ld

    # misc LLVM tools
    llvm-cxxfilt llvm-dis llvm-nm llvm-readelf llvm-readobj 
    llvm-objcopy llvm-objdump llvm-ranlib llvm-ar llvm-strip 
    llvm-symbolizer 
)
set(llvm_pickup_dirs
    lib/clang
)

set(llvm_pickup_src "${llvm_prefix}")
set(llvm_pickup_dest "${llvm_pkgdest}")

include(${CMAKE_CURRENT_LIST_DIR}/lib_pkgpickup.cmake)

runbuild()
runpickup(llvm)
