FROM cruizba/crecorder-base

# Create user for development
RUN useradd -ms /bin/bash userdocker

# Versions
ENV NODE_VERSION=11.0.0 \
    NPM_VERSION=6.4.1 \
    IONIC_VERSION=4.5.0 \
    CORDOVA_VERSION=8.1.2
# Android

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
    ANDROID_HOME="/opt/android" \
    ANDROID_BUILD_TOOLS_VERSION=27.0.0 \
    ANDROID_APIS="android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25,android-26"

#Path
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION

####### Maven
RUN apt-get update \ 
    && apt-get install -y maven \
    && rm -rf /var/lib/apt/lists/*

####### Node, npm, cordova and ionic
RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_11.x | bash \
    && apt-get install -y nodejs \
    && npm install -g npm@"$NPM_VERSION" \
    && npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /opt

####### Android sdk
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 && \
    # Installs Android SDK
    mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME && \
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

# Grants for user in Android
RUN chown -R userdocker $ANDROID_HOME

# Add the vscode debian repo
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

# install vscode and dependencies
RUN apt-get update && apt-get -y install \
	code libasound2 libatk1.0-0 libcairo2 libcups2 \
	libexpat1 libfontconfig1 libfreetype6 libgtk2.0-0 \
	libpango-1.0-0 libx11-xcb1 libxcomposite1 \
	libxcursor1 libxdamage1 libxext6 \
	libxfixes3 libxi6 libxrandr2 \
	libxrender1 libxss1 libxtst6 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# package vscode with extensions for development
ENV VSCODEEXT /var/vscode-ext
RUN mkdir $VSCODEEXT \
    && chown -R userdocker $VSCODEEXT


ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH
ENV DEV_DIR /home/userdocker/class-recorder

# Copying entry point
ADD entrypoint.sh /tmp/entrypoint.sh
RUN chmod u+x /tmp/entrypoint.sh && chown userdocker /tmp/entrypoint.sh

RUN chown -R userdocker /home/userdocker

# Change to user docker
USER userdocker

# Install vscode extensions
RUN code --extensions-dir $VSCODEEXT \ 
    --install-extension vscjava.vscode-java-pack \
    --install-extension vscjava.vscode-maven \
    --install-extension eg2.tslint \
    --install-extension vscjava.vscode-java-pack \
    --install-extension formulahendry.terminal

WORKDIR /home/userdocker/class-recorder

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
CMD [ "/bin/bash" ]