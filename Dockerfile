FROM anapsix/alpine-java:8_jdk

MAINTAINER Can Kutlu Kinay <me@ckk.im>

ENV SDK_VERSION     25.2.3
ENV SDK_CHECKSUM    1b35bcb94e9a686dff6460c8bca903aa0281c6696001067f34ec00093145b560
ENV ANDROID_HOME    /opt/android-sdk
ENV SDK_UPDATE      tools,platform-tools,build-tools-25.0.2,android-25,android-24,android-23,android-22,android-21,sys-img-armeabi-v7a-android-23,sys-img-x86-android-23
ENV LD_LIBRARY_PATH ${ANDROID_HOME}/tools/lib64/qt:${ANDROID_HOME}/tools/lib/libQt5:$LD_LIBRARY_PATH/
ENV GRADLE_VERSION  2.13
ENV GRADLE_HOME     /opt/gradle-${GRADLE_VERSION}
ENV PATH            ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin

RUN apk add --no-cache curl \
    && curl -SLO "https://dl.google.com/android/repository/tools_r${SDK_VERSION}-linux.zip" \
    && echo "${SDK_CHECKSUM}  tools_r${SDK_VERSION}-linux.zip" | sha256sum -cs \
    && mkdir -p "${ANDROID_HOME}" \
    && unzip "tools_r${SDK_VERSION}-linux.zip" -d "${ANDROID_HOME}" \
    && rm -Rf "tools_r${SDK_VERSION}-linux.zip" \
    && echo y | ${ANDROID_HOME}/tools/android update sdk --filter ${SDK_UPDATE} --all --no-ui --force \
    && mkdir -p ${ANDROID_HOME}/tools/keymaps \
    && touch ${ANDROID_HOME}/tools/keymaps/en-us \
    # Licenses taken from https://github.com/mindrunner/docker-android-sdk
    && mkdir -p ${ANDROID_HOME}/licenses \
    && echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55\n" > ${ANDROID_HOME}/licenses/android-sdk-license \
    && echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd\n" > ${ANDROID_HOME}/licenses/android-sdk-preview-license \
    # Install gradle
    && curl -SLO https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && mkdir -p "${GRADLE_HOME}" \
    && unzip "gradle-${GRADLE_VERSION}-bin.zip" -d "/opt" \
    && rm -f "gradle-${GRADLE_VERSION}-bin.zip" \
    && apk del curl
