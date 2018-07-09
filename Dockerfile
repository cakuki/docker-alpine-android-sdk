FROM gradle:4.8.1-jdk8-alpine

MAINTAINER Can Kutlu Kinay <me@ckk.im>

USER root
ENV ANDROID_HOME    /opt/android-sdk
ENV SDK_VERSION     4333796
ENV SDK_CHECKSUM    92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
ENV SDK_UPDATE      "tools platform-tools build-tools;28.0.1 \
                    platforms;android-27 platforms;android-26 platforms;android-25 \
                    platforms;android-24 platforms;android-23 platforms;android-22 \
                    platforms;android-21 platforms;android-20"
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl bash \
    && curl -SLO "https://dl.google.com/android/repository/sdk-tools-linux-${SDK_VERSION}.zip" \
    && echo "${SDK_CHECKSUM}  sdk-tools-linux-${SDK_VERSION}.zip" | sha256sum -cs \
    && mkdir -p "${ANDROID_HOME}" \
    && unzip "sdk-tools-linux-${SDK_VERSION}.zip" -d "${ANDROID_HOME}" \
    && rm -Rf "sdk-tools-linux-${SDK_VERSION}.zip" \
    && echo "y" | ${ANDROID_HOME}/tools/bin/sdkmanager ${SDK_UPDATE} \
    && mkdir -p ${ANDROID_HOME}/tools/keymaps \
    && touch ${ANDROID_HOME}/tools/keymaps/en-us \
    && apk del curl