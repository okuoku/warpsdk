from conan import ConanFile
from conan.tools.files import copy
from conan.errors import ConanInvalidConfiguration
import os, json
from pathlib import Path

class Localbuild(ConanFile):
    # Cache
    _curparam = None

    def _get_params(self) -> dict:
        if self._curparam is not None:
            return self._curparam
        e = os.getenv("WARPPKG_PARAMS")
        p = Path(e)
        if not e:
            raise ConanInvalidConfiguration("WARPPKG_params required")

        try:
            param = json.loads(p.read_text(encoding="utf-8"))
        except Exception as x:
            raise ConanInvalidConfiguration(f"Failed to parse input JSON {x}")

        return param;

    def _copy_srcs(self, target):
        param = self._get_params()
        srcdir = str(os.getenv("WARPPKG_SRCDIR"))
        if not srcdir:
            raise ConanInvalidConfiguration("WARPPKG_SRCDIR required")
        for i in param["files"]:
            pat = str(i)
            copy(self, pattern=str(i), src=srcdir, dst=target, keep_path=True)

    def set_name(self):
        param = self._get_params()
        self.name = str(param["name"])

    def set_version(self):
        param = self._get_params()
        self.version = str(param["version"])

    def export_sources(self):
        pass

    def package(self):
        self._copy_srcs(self.package_folder)

    def generate(self):
        # Do nothing
        return

