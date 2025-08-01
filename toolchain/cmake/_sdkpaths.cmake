#
# INPUTs:
#
#   ENV{WARP_TOOLCHAIN_PREFIX}: Native prefix for LLVM binaries
#   ENV{WARP_SYSROOT_PREFIX}: Sysroot prefix
#

if(NOT DEFINED ENV{WARP_TOOLCHAIN_PREFIX})
    message(FATAL_ERROR "WARP_TOOLCHAIN_PREFIX unknown.")
endif()

if(NOT DEFINED ENV{WARP_SYSROOT_PREFIX})
    message(FATAL_ERROR "WARP_SYSROOT_PREFIX unknown.")
endif()

cmake_path(SET toolchain_prefix NORMALIZE "$ENV{WARP_TOOLCHAIN_PREFIX}")
cmake_path(SET sysroot_prefix NORMALIZE "$ENV{WARP_SYSROOT_PREFIX}")
