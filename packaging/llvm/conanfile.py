import os
from conan import ConanFile
from conan.tools.files import get, copy, download
from conan.errors import ConanInvalidConfiguration
from conan.tools.scm import Version
from pathlib import Path


class WarpLlvmPackage(ConanFile):
    name = "warpsdk-llvm"
    version = "0.0.warp0"
    license = "DO_NOT_EXPORT"
    description = "(internal use only LLVM/Clang package)"
    settings = "os", "arch"
    package_type = "application"

    def package(self):
        dirs_to_copy = ["bin", "lib/clang"]
        me = Path(self.source_folder)
        srcpath = me.resolve().parent.parent / "_build" / "pkg" / "llvm"
        for dir_name in dirs_to_copy:
            copy(self, pattern=f"{dir_name}/*", src=str(srcpath), 
                 dst=self.package_folder, keep_path=True)

    def package_info(self):
        self.buildenv_info.define("WARP_TOOLCHAIN_PREFIX", self.package_folder)

