@echo off

IF NOT EXIST "setup.py" IF NOT EXIST "pytorch" (
    call internal\clone.bat
    IF ERRORLEVEL 1 goto eof
)

call internal\check_deps.bat
IF ERRORLEVEL 1 goto eof

REM Check for optional components

set NO_CUDA=
set CMAKE_GENERATOR=Visual Studio 15 2017 Win64

IF "%CUDA_PATH_V8_0%"==""  IF "%CUDA_PATH_V9_0%"=="" (
    echo CUDA 8/9 not found, disabling it
    set NO_CUDA=1
    goto optcheck
)

IF "%NVTOOLSEXT_PATH%"=="" (
    echo NVTX ^(Visual Studio Extension ^for CUDA^) ^not installed, disabling CUDA
    set NO_CUDA=1
    goto optcheck
)

IF NOT "%CUDA_PATH_V8_0%"=="" IF "%CUDA_PATH_V8_0%"=="%CUDA_PATH%" (
    IF "%VS140COMNTOOLS%"=="" (
        echo CUDA 8 found, but VS2015 not found, disabling it
        set NO_CUDA=1
    ) ELSE (
        set CMAKE_GENERATOR=Visual Studio 14 2015 Win64
        set "PREBUILD_COMMAND=%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat"
        set PREBUILD_COMMAND_ARGS=x86_amd64
    )
)

:optcheck

call internal\check_opts.bat
IF ERRORLEVEL 1 goto eof

call internal\setup.bat
IF ERRORLEVEL 1 goto eof

:eof
