
# FIXME: This recipe depends on self.source_folder
#        thus we need
#        $ conan install .
#        $ conan export-pkg .
#        combo.

import os
from conan import ConanFile
from conan.tools.files import copy

class WarpToolchainWrapper(ConanFile):
    name = "warp-toolchain"
    version = "0.0.1.warp0"
    license = "DO_NOT_EXPORT"
    description = "LLVM toolchain wrapper for Warp SDK"
    package_type = "application"
    settings = "os", "arch"
    no_copy_source = True


    def requirements(self):
        self.requires("warp-sysroot/[>=0]", visible=True, headers=True, libs=True)
        self.requires("llvmtoolchain-warp/[>=0]", visible=True, run=True)

    def package(self):
        warp_tools = ["warp-cc", "warp-c++", "warp-ar", "warp-nm",
                      "warp-ld"]
        if self.settings.os == "Windows":
            for i,x in enumerate(warp_tools):
                warp_tools[i] = x + ".bat"
        toolchain = os.path.join(self.source_folder, "..", "..", "toolchain")
        toolchain_bin = os.path.join(toolchain, "bin")
        toolchain_cmake = os.path.join(toolchain, "cmake")
        bindir = os.path.join(self.package_folder, "bin")
        cmakedir = os.path.join(self.package_folder, "cmake")
        copy(self, pattern="*.cmake", src=toolchain_cmake,
             dst=cmakedir, keep_path=False)
        for tool in warp_tools:
            copy(self, pattern=f"{tool}*", src=toolchain_bin,
                 dst=bindir, keep_path=False)

    def package_info(self):
        self.buildenv_info.prepend_path("PATH", os.path.join(self.package_folder, "bin"))
        self.cpp_info.bindirs.append(os.path.join(self.package_folder, "bin"))
        if self.settings.os == "Windows":
            self.conf_info.define("tools.build:compiler_executables", {
                "c": "warp-cc.bat",
                "cpp": "warp-c++.bat",
                })
        else:
            self.conf_info.define("tools.build:compiler_executables", {
                "c": "warp-cc",
                "cpp": "warp-c++",
                })
