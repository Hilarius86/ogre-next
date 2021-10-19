
@echo off
SETLOCAL

set OGRE_BRANCH_NAME=v2-2
set GENERATOR="Visual Studio 15 2017"
set PLATFORM=x64

set BUILD_FOLDER = c:\entwicklung\ogre-next_2_2\
set OGRE_DIRECTORY_SRC = c:\entwicklung\card_1\ogre-next\

set CMAKE_BIN_x86="C:\Program Files (x86)\CMake\bin\cmake.exe"
set CMAKE_BIN_x64="C:\Program Files\CMake\bin\cmake.exe"
IF EXIST %CMAKE_BIN_x64% (
	echo CMake 64-bit detected
	set CMAKE_BIN=%CMAKE_BIN_x64%
) ELSE (
	IF EXIST %CMAKE_BIN_x86% (
		echo CMake 32-bit detected
		set CMAKE_BIN=%CMAKE_BIN_x86%
	) ELSE (
		echo Cannot detect either %CMAKE_BIN_x86% or
		echo %CMAKE_BIN_x64% make sure CMake is installed
		EXIT /B 1
	)
)
echo Using CMake at %CMAKE_BIN%

cd ../../../../..

mkdir ogre-next_2_2
cd ogre-next_2_2
IF NOT EXIST ogre-next-deps (
	mkdir ogre-next-deps
	echo --- Cloning ogre-next-deps ---
	git clone --recurse-submodules --shallow-submodules https://github.com/OGRECave/ogre-next-deps
) ELSE (
	echo --- ogre-next-deps repo detected. Cloning skipped ---
)
cd ogre-next-deps
mkdir build
cd build
REM echo --- Building ogre-next-deps ---
REM %CMAKE_BIN% -G %GENERATOR% -A %PLATFORM% ..
REM %CMAKE_BIN% --build . --config Debug
REM %CMAKE_BIN% --build . --target install --config Debug
REM %CMAKE_BIN% --build . --config Release
REM %CMAKE_BIN% --build . --target install --config Release

cd ../..

mkdir build
cd build
echo --- Running CMake configure ---
%CMAKE_BIN% -D OGRE_USE_BOOST=0 -D OGRE_CONFIG_THREAD_PROVIDER=0 -D OGRE_CONFIG_THREADS=0 -D OGRE_BUILD_COMPONENT_SCENE_FORMAT=1 -D OGRE_BUILD_SAMPLES2=1 -D OGRE_BUILD_TESTS=1 -D OGRE_DEPENDENCIES_DIR=..\ogre-next-deps\build\ogredeps -G %GENERATOR% -A %PLATFORM% ..\..\card_1\ogre-next
echo --- Building Ogre (Debug) ---
%CMAKE_BIN% --build . --config Debug
%CMAKE_BIN% --build . --target install --config Debug
echo --- Building Ogre (Release) ---
%CMAKE_BIN% --build . --config Release
%CMAKE_BIN% --build . --target install --config Release

echo Done!

ENDLOCAL
