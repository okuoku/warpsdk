@setlocal

@rem Workaround for path quoting. Logic took from
@rem Emscripten

@if exist "%~f0" (
    set "MYDIR=%~dp0"
    goto FOUND_MYDIR
)

rem Lookup MYDIR manually from PATH
@for %%I in (%~n0.bat) do (
    @if exist %%~$PATH:I (
        set MYDIR=%%~dp$PATH:I
    ) else (
        echo !!!ERROR!!! Could not detect mydir.
        exit /b 1
    )
)
:FOUND_MYDIR

@cmake -DCXX=ON -P %MYDIR%\..\cmake\warp-cc.cmake -- __WARPTOOL__ %*
@exit /b %ERRORLEVEL%
