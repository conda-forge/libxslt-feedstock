:: Need to set manifest for VS2008 otherwise exes crash (not sure why).
set MANIFEST=no
if "%VS_MAJOR%" == "9" (
    set MANIFEST=yes
)

:: libxml2-devel has a fixed include location on conda-forge.  Use it directly
:: while bootstrapping Windows ARM64, where native pkg-config is not available.
if "%target_platform%" == "win-arm64" goto direct_libxml2_include

set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig"
for /F "usebackq delims=" %%f in (`pkg-config --cflags-only-I libxml-2.0`) do set "libxml2_include=%%f"
set "libxml2_include=%libxml2_include: -I=;%"
set "libxml2_include=%libxml2_include:-I=;%"
goto libxml2_include_ready

:direct_libxml2_include
set "libxml2_include=;%LIBRARY_INC%\libxml2"

:libxml2_include_ready

cd win32
cscript configure.js prefix=%LIBRARY_PREFIX% include=%LIBRARY_INC%%libxml2_include% ^
        lib=%LIBRARY_LIB% sodir=%LIBRARY_BIN% iconv=yes zlib=yes vcmanifest=%MANIFEST%
if errorlevel 1 exit 1

nmake /f Makefile.msvc
if errorlevel 1 exit 1

nmake /f Makefile.msvc install
if errorlevel 1 exit 1
