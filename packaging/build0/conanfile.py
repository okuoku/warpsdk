import os
from conan import ConanFile
from conan.tools.cmake import CMake

class BuildPhase0(ConanFile):
    def build_requirements(self):
        self.tool_requires("cmake/[>=3 <3.99]")
        self.tool_requires("ninja/[>1]")
        self.tool_requires("llvmtoolchain-warp/[>=1]")

    def build(self):
        self.run("cmake -P ../../phase0.cmake")


