FROM ubuntu:16.04

MAINTAINER Carsten Stender <carsten.stender@gmail.com> 

##=======================
## Environment variables
##=======================
ENV DISPLAY					:99

ENV GRADLE_VERSION			3.2.1
ENV GRADLE_HOME 			/usr/local/gradle
ENV GRADLE_USER_HOME		/gradle

ENV AIR_SDK_VERSION       	22.0.0
ENV FLEX_SDK_NAME  			AirSdkCompilerUnix-${AIR_SDK_VERSION}
ENV FLASH_DIR              	/opt/flash
ENV FLEX_HOME              	/opt/flash/sdk/AirSdkCompilerUnix-${AIR_SDK_VERSION}
ENV FLASH_PLAYER_LOCATION  	/usr/lib/flashplayer/flashplayerdebugger

##=======================
## Install dependencies
##=======================

RUN apt-get update && \
	apt-get install -y \
			curl \
			openssl \
			tar \
			unzip \
			git \
			xvfb \
			default-jdk &&\
	apt-get clean

##=======================
## Install java and gradle using SDKMAN
##=======================

# RUN curl -s "https://get.sdkman.io" | bash 
# RUN set -x echo "sdkman_auto_answer=true" > /root/.sdkman/etc/config
# RUN ["bin/bash", "-c", "source /root/.sdkman/bin/sdkman-init.sh && sdk install java $JAVA_VERSION && sdk install gradle $GRADLE_VERSION"]

##=======================
## Install gradle
##=======================

WORKDIR /usr/local
RUN curl http://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
	--progress-bar \
	-o gradle.zip &&\
    unzip -q gradle.zip &&\
    rm -f gradle.zip &&\
    ln -s gradle-$GRADLE_VERSION gradle

##=======================
## Install Debug Flash player
##=======================

RUN mkdir -p $FLASH_DIR &&\
	cd $FLASH_DIR &&\
	curl https://fpdownload.macromedia.com/pub/labs/flashruntimes/flashplayer/linux64/flash_player_sa_linux_debug.x86_64.tar.gz \
		--progress-bar \
		-o flash_player.tar.gz &&\
   	tar xvzf flash_player.tar.gz &&\
	rm flash_player.tar.gz &&\
    mkdir -p /usr/lib/flashplayer &&\
	mv flashplayerdebugger /usr/lib/flashplayer/flashplayerdebugger &&\
    rm -rf /usr/bin/flashplayerdebugger &&\
    ln -s /usr/lib/flashplayer/flashplayerdebugger /usr/bin/gflashplayer

##==========================
## Install FlexAirSDK from Innogames - Onyx archiva
##==========================

RUN curl http://onyx-ci-tools.innogames.de:8001/repository/internal/de/innogames/sdk/AirSdkCompilerUnix/${AIR_SDK_VERSION}/AirSdkCompilerUnix-${AIR_SDK_VERSION}.zip \
		--progress-bar \
		-o sdk.zip &&\
	mkdir -p /opt/flash/sdk/AirSdkCompilerUnix-${AIR_SDK_VERSION} &&\
	unzip -q sdk.zip -d /opt/flash/sdk/AirSdkCompilerUnix-${AIR_SDK_VERSION} &&\
	rm sdk.zip &&\
    cd $FLEX_HOME

##==========================
## Install all playerglobal.swc
##==========================

RUN cd ${FLEX_HOME}/frameworks/libs &&\
	rm -rf player &&\
	git clone https://github.com/nexussays/playerglobal.git player

##==========================
## Mount volumes
##==========================

RUN mkdir -p /project && mkdir -p /gradle
VOLUME /project
VOLUME /gradle

WORKDIR /project

##==========================
## Configure entrypoint
##==========================

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]