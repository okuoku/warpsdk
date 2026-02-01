from conan import ConanFile
from conan.tools.files import copy
from pathlib import Path
import os

class WarpCMakeTC(ConanFile):
    name = "warpsdk-cmake-tc"
    version = "0.0warp0"
    package_type = "build-scripts"

    def package(self):
        me = Path(self.source_folder)
        rootdir = me.resolve().parent.parent
        mycmakedir = rootdir / "cmake"
        print(mycmakedir)
        copy(self, "*.cmake", src=str(mycmakedir), 
             dst=os.path.join(self.package_folder, "cmake"),
             keep_path=True)

    def package_info(self):
        dst = os.path.join(self.package_folder, "cmake")
        self.buildenv_info.define_path("WARPSDK_CMAKE_MODULES", dst)
        self.runenv_info.define_path("WARPSDK_CMAKE_MODULES", dst)
        self.cpp_info.set_property("cmake_extra_variables", {
              "WARPSDK_CMAKE_MODULES": dst
            })

