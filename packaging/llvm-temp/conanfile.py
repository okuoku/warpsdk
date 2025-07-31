import os
from conan import ConanFile
from conan.tools.files import get, copy, download
from conan.errors import ConanInvalidConfiguration
from conan.tools.scm import Version


class WarpLlvmClangPackage(ConanFile):
    name = "llvmtoolchain-warp"
    version = "20.1.8.warp0"
    license = "DO_NOT_EXPORT"
    description = "(internal use only LLVM/Clang package)"
    settings = "os", "arch"
    package_type = "application"

    # FIXME: Download and extract on build phases
    extracted_path = "e:/clang+llvm-20.1.8-x86_64-pc-windows-msvc"

    def validate(self):
        if self.settings.arch != "x86_64" or self.settings.os != "Windows":
            raise ConanInvalidConfiguration("Only applicable for Windows/x86_64")

    def package(self):
        dirs_to_copy = ["bin", "lib/clang"]
        for dir_name in dirs_to_copy:
            copy(self, pattern=f"{dir_name}/*", src=self.extracted_path, dst=self.package_folder, keep_path=True)
    def layout(self):
        self.layouts.package.buildenv_info.define_path("WARP_TOOLCHAIN_DIR", "")

