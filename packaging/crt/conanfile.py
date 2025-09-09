import os
from conan import ConanFile
from conan.tools.cmake import CMake
from conan.tools.files import copy

class BuildPhase0(ConanFile):
    name = "warp-crt"
    version = "0.0.1.warp0"
    license = "DO_NOT_EXPORT"
    description = "Startup code for Warp"

    def build_requirements(self):
        self.tool_requires("cmake/[>=3 <3.99]")
        self.tool_requires("ninja/[>1]")
        self.tool_requires("llvmtoolchain-warp/[>=1]")

    def build(self):
        self.run(f"cmake -DBUILD={self.build_folder}/build -DPREFIX={self.build_folder}/install -P ../../phase0crt.cmake")

    def package(self):
        builddir = os.path.join(self.build_folder, "install")
        copy(self, pattern="*", src=builddir, dst=self.package_folder, keep_path=True)

