#!/bin/bash

# FILE:         build-all.sh
# CONTRIBUTOR:  John C Burns

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script builds all GOLANG projects.

# USAGE: ./build-all.sh SOLUTION_DIR [CONFIGURATION]
set -e

# Check for mandatory arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 SOLUTION_DIR [CONFIGURATION]"
    exit 1
fi

echo "$1"

echo "$2"

echo "$3"



solutionDir="$1"
outDir="bin/Debug/net6.0/"
buildConfig="Debug"
if [ "$#" -ge 2 ]; then
    outDir="$2"
fi
if [ "$#" -ge 3 ]; then
    buildConfig="$3"
fi


orgDirectory=$(pwd)

export GOOS="darwin"
export GOARCH="arm64"

export BUILD_GOROOT="${solutionDir}Go"
export BUILD_PATH="${solutionDir}SharedC/bin/$buildConfig/net6.0"
export LOG_PATH="${solutionDir}Go/GoBuilder/$outDir"

echo "$LOG_PATH"

cd $BUILD_GOROOT
chmod +x ./build-helloworld.sh 
chmod +x ./build-math.sh 
# ./build-helloworld.sh $BUILD_GOROOT $BUILD_PATH/macos $LOG_PATH $buildConfig "darwin" "arm64"
# ./build-math.sh $BUILD_GOROOT $BUILD_PATH/macos $LOG_PATH $buildConfig "darwin" "arm64"

# change env
export CC="x86_64-w64-mingw32-gcc" 
./build-helloworld.sh $BUILD_GOROOT $BUILD_PATH/win $LOG_PATH $buildConfig "windows" "amd64"
./build-math.sh $BUILD_GOROOT $BUILD_PATH/win $LOG_PATH $buildConfig "windows" "amd64"

# change env
export CC=x86_64-linux-musl-gcc 
export CXX=x86_64-linux-musl-g++
./build-helloworld.sh $BUILD_GOROOT $BUILD_PATH/linux $LOG_PATH $buildConfig "linux" "amd64"
./build-math.sh $BUILD_GOROOT $BUILD_PATH/linux $LOG_PATH $buildConfig "linux" "amd64"

# bash "${BUILD_GOROOT}/build-helloworld.sh $BUILD_GOROOT $BUILD_PATH/macos $LOG_PATH $buildConfig darwin arm64"

# ./build-math.sh $BUILD_GOROOT $BUILD_PATH/macos $LOG_PATH $buildConfig "darwin" "arm64"
# ./build-math.sh "$BUILD_GOROOT" "$BUILD_PATH" "$LOG_PATH" "$buildConfig"

