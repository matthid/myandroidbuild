#!/bin/bash

volumeName="kitkat_build"
imageName="androidkitkat_build"
outDir="/e/projects/android/myandroidbuild/kitkat_out"

# push changes
cd platform/dalvik/
git push github
cd ../..

# pull changes
docker run --mount source=$volumeName,destination=//aosp -ti --rm $imageName bash -c 'cp -R /aosp/.ssh/* ~/.ssh/ && cd /aosp/dalvik && git pull github'

# Build changes
docker run --mount source=$volumeName,destination=//aosp -ti --rm $imageName bash -c '. /aosp/build/envsetup.sh && cd /aosp/dalvik && mm'

# Download changes
rm -rf $outDir
docker run -d --rm --name dummy --mount source=$volumeName,destination=//aosp $imageName tail -f //dev/null
docker cp dummy://aosp/out/target/product/generic/system $outDir
docker stop dummy

adb push "$outDir/lib/libdvm.so" //data/local/tmp/libdvm.so.newbuild