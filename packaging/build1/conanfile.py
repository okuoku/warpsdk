import os
from conan import ConanFile
from conan.tools.cmake import CMake
from conan.tools.files import copy

class BuildPhase1(ConanFile):
    name = "llvmruntime-warp"
    version = "0.0.1.warp0"
    license = "Apache-2.0 WITH LLVM-exception"
    description = "Toolchain and C++ language runtime package for Warp"

    def build_requirements(self):
        self.tool_requires("cmake/[>=3 <3.99]")
        self.tool_requires("ninja/[>1]")
        self.tool_requires("llvmtoolchain-warp/[>=1]")
        self.requires("picolibc-warp/[>=0]")

    def build(self):
        # FIXME: Setup build folder
        self.run(f"cmake -DBUILD={self.build_folder}/build_rt -DPREFIX={self.build_folder}/install -P ../../phase1.cmake")

    def package(self):
        builddir = os.path.join(self.build_folder, "install")
        copy(self, pattern="*", src=builddir, dst=self.package_folder, keep_path=True)

    def layout(self):
        self.layouts.package.buildenv_info.define_path("WARP_LLVMRUNTIME_PREFIX", "")

