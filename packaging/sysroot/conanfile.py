import os
from conan import ConanFile
from conan.tools.files import copy

class WarpSysroot(ConanFile):
    name = "warp-sysroot"
    version = "0.0.1.warp0"
    license = "DO_NOT_EXPORT"
    description = "Sysroot files for Warp runtime"
    package_type = "unknown"

    def requirements(self):
        self.requires("picolibc-warp/[>=0]")
        self.requires("llvmruntime-warp/[>=0]")

    def package(self):
        dirs_to_copy = ["lib", "include"]
        picolibc = self.dependencies["picolibc-warp"].package_folder;
        llvmruntime = self.dependencies["llvmruntime-warp"].package_folder;
        for pkg in [picolibc, llvmruntime]:
            for dir_name in dirs_to_copy:
                copy(self, pattern=f"{dir_name}/*",
                     src=pkg, dst=self.package_folder, keep_path=True)

    def package_info(self):
        self.buildenv_info.define_path("WARP_SYSROOT_PREFIX", self.package_folder)
