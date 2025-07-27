find_program(WARPSDK_AR llvm-ar)
find_program(WARPSDK_CLANG clang)
find_program(WARPSDK_LINKER wasm-ld)

set(WARPSDK_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/sysroot)
set(WARPSDK_POSIXROOT ${CMAKE_CURRENT_LIST_DIR}/yuniposix)
