# sysroot package should be built on user-side
# (to prevent wasting package storage space...)

from conan import ConanFile
from conan.tools.files import copy
from pathlib import Path

class WarpSysroot(ConanFile):
    name = "warp-sysroot"
    version = "0.0.0.warp0"
    license = "DO_NOT_EXPORT"
    description = "Warp Sysroot"
    package_type = "unknown" # both shared-library and static-library
    #exports_sources = "python/*.py"

    def requirements(self):
        self.requires("warp-crt/[>=0]")
        self.requires("warp-llvm-rt/[>=0]")
        self.requires("warp-picolibc/[>=0]")

    def package(self):
        out = Path(self.package_folder)
        warpsdk = out 
        # Merge crt + llvm-rt + picolibc into warpsdk/sysroot
        sysroot = warpsdk / "sysroot"
        dirnames = ["lib", "include"]
        deps = ["warp-crt", "warp-llvm-rt", "warp-picolibc"]
        for pkgname in deps:
            dep = self.dependencies[pkgname]
            srcdir = dep.package_folder
            for d in dirnames:
                copy(self, pattern="*", src=srcdir, dst=str(sysroot),
                     keep_path=True)

    def package_info(self):
        self.buildenv_info.define_path("WARPSDK_SYSROOT", self.package_folder)
        self.cpp_info.set_property("cmake_extra_variables", {
              "WARPSDK_SYSROOT": self.package_folder
            })

