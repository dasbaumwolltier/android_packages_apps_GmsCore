#!/bin/bash

mkdir -p microg
cd microg
mkdir -p outputs
mkdir -p keystores

ANDROID_SDK_PATH="/opt/android-sdk-update-manager"
KEYSTORES_PATH="keystores"

# Generate keystore
echo "We need to create a keystore for GmsCore:"
# keytool -genkey -v -keystore $KEYSTORES_PATH/playservices.jks -alias playservices -keyalg RSA -keysize 4096 -validity 10000
yes|keytool -genkey -v -keystore $KEYSTORES_PATH/playservices.jks -alias playservices -keyalg RSA -keysize 4096 -validity 10000 -storepass "liteclitec123#GmsCore" -keypass "liteclitec123#GmsCore"


# GMSCore
#git clone https://github.com/microg/android_packages_apps_GmsCore.git
#cd android_packages_apps_GmsCore
#git submodule update --init --recursive
#echo "sdk.dir=$ANDROID_SDK_PATH" > local.properties
#echo "sdk-location=$ANDROID_SDK_PATH" >> local.properties
#./gradlew build
cp play-services-core/build/outputs/apk/play-services-core-release-unsigned.apk ../outputs/play-services-core-release.apk


# Sign APK
cd ../outputs
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEYSTORES_PATH/playservices.jks play-services-core-release.apk playservices
$ANDROID_SDK_PATH/build-tools/22.0.1/zipalign -p -v 4 play-services-core-release.apk com.google.android.gms.apk
