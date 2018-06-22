#!/bin/bash

cd /home/travis/build/dasbaumwolltier/android_packages_apps_GmsCore/

mkdir -p microg
cd microg
mkdir -p outputs
mkdir -p keystores

ANDROID_SDK_PATH="/opt/android-sdk-update-manager"
KEYSTORES_PATH="keystores"

# Generate keystore
sudo apt install tree -y && tree || ls -la *
echo "We need to create a keystore for GmsCore:"
yes|keytool -genkey -v -keystore $KEYSTORES_PATH/playservices.jks -alias playservices -keyalg RSA -keysize 4096 -validity 10000 -keypass "itecceti123#GmsCore" -storepass "itecceti123#GmsCore"


# GMSCore
#git clone https://github.com/microg/android_packages_apps_GmsCore.git
#cd android_packages_apps_GmsCore
#git submodule update --init --recursive
#echo "sdk.dir=$ANDROID_SDK_PATH" > local.properties
#echo "sdk-location=$ANDROID_SDK_PATH" >> local.properties
#./gradlew build
cp play-services-core-release/build/outputs/apk/*-unsigned.apk ../outputs/play-services-core-release.apk


# Sign APK
cd ../outputs
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEYSTORES_PATH/playservices.jks play-services-core-release.apk playservices -keypass "itecceti123#GmsCore" -storepass "itecceti123#GmsCore"
$ANDROID_SDK_PATH/build-tools/27.0.3/zipalign -p -v 4 play-services-core-release.apk com.google.android.gms.apk
