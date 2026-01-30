import os
from conan import ConanFile
from conan.tools.files import copy
from pathlib import Path

class WarpToolchainWrapper(ConanFile):
    name = "warpsdk-toolchain"
    version = "0.0.1.warp0"
    license = "DO_NOT_EXPORT"
    description = "LLVM toolchain wrapper for Warp SDK"
    package_type = "application"
    settings = "os", "arch"
    no_copy_source = True


    def requirements(self):
        self.tool_requires("warpsdk-cmake-tc/[>=0]", visible=True, run=True)
        self.tool_requires("warpsdk-llvm/[>=0]", visible=True, run=True)

    def package(self):
        warp_tools = ["warp-cc", "warp-c++", "warp-ar", "warp-nm",
                      "warp-ld"]
        if self.settings.os == "Windows":
            for i,x in enumerate(warp_tools):
                warp_tools[i] = x + ".bat"
        toolchain = Path(self.source_folder).parent.parent / "toolchain"
        toolchain_bin = toolchain / "bin"
        toolchain_cmake = toolchain / "cmake"
        bindir = os.path.join(self.package_folder, "bin")
        cmakedir = os.path.join(self.package_folder, "cmake")
        copy(self, pattern="*.cmake", src=str(toolchain_cmake),
             dst=cmakedir, keep_path=False)
        for tool in warp_tools:
            copy(self, pattern=f"{tool}*", src=toolchain_bin,
                 dst=bindir, keep_path=False)

    def package_info(self):
        self.buildenv_info.prepend_path("PATH", os.path.join(self.package_folder, "bin"))
        #self.cpp_info.bindirs.append(os.path.join(self.package_folder, "bin"))
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
