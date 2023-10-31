#!/bin/bash

# FILE:         build-math.sh
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
# This script builds the [hello-world] GOLANG executables and writes
# them to the specified build directory.

# USAGE: ./build-math.sh GOROOT BUILD_PATH LOG_PATH [CONFIGURATION]

# Check for mandatory arguments
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 GOROOT BUILD_PATH LOG_PATH [CONFIGURATION]"
    exit 1
fi

goRoot="$1"
buildPath="$2"
logPath="$3"
buildConfig="Debug"
if [ "$#" -ge 4 ]; then
    buildConfig="$4"
fi

goOS="$5"
goARCH="$6"

projectPath="$goRoot/src/shared-c/cmd/math"
orgDirectory=$(pwd)

cd "$projectPath"

# Create directories if they don't exist
mkdir -p "$buildPath"
mkdir -p "$logPath"

# set log path to file
logPath="$logPath/build-math.log"

# Build the WINDOWS binary
export GOPATH="$goRoot"
export CGO_ENABLED=1
export GOOS="$goOS"
export GOARCH="$goARCH"


/usr/local/go/bin/go build -v -buildmode=c-shared -o "$buildPath/math.dll" "$projectPath/main.go" > "$logPath" 2>&1
exitCode=$?

if [ $exitCode -ne 0 ]; then
    echo "*** ERROR: [math] build failed.  Check build logs: $logPath"
    cd "$orgDirectory"
    exit $exitCode
fi

# Return to the original directory
cd "$orgDirectory"
