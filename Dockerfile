FROM debian:12-slim

# Install toolchain
RUN apt update && \
    apt install -y git \
            python3 \
            python3-pip \
            cmake \
            build-essential \
            libusb-1.0-0-dev \
            pkg-config \
            libnewlib-arm-none-eabi \
            gcc-arm-none-eabi \
            binutils-arm-none-eabi \
            clang-format \
            clangd \
            wget \
            xxd

# Raspberry Pi Pico SDK
ARG SDK_PATH=/usr/share/pico_sdk
RUN git clone --depth 1 --branch 1.5.1 https://github.com/raspberrypi/pico-sdk $SDK_PATH && \
    cd $SDK_PATH && \
    git submodule update --init

ENV PICO_SDK_PATH=$SDK_PATH

# Picotool installation
RUN git clone --depth 1 --branch 1.1.2 https://github.com/raspberrypi/picotool.git /home/picotool && \
    cd /home/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    cp /home/picotool/build/picotool /bin/picotool && \
    rm -rf /home/picotool

# GBDK installation
ARG GBDK_PATH=/usr/share/gbdk
RUN wget https://github.com/gbdk-2020/gbdk-2020/releases/download/4.1.1/gbdk-linux64.tar.gz -P /home && \
    cd /home && \
    tar -xvzf gbdk-linux64.tar.gz && \
    cp -R gbdk $GBDK_PATH && \
    cd /home && \
    rm -rf /home/gbdk

ENV GBDK_PATH=$GBDK_PATH
