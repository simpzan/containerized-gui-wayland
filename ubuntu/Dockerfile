FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ca-certificates sudo
COPY ustc.sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y sway wayvnc xwayland vulkan-tools

ARG UNAME=app
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME && \
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME && \
    usermod -aG sudo $UNAME && \
    echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /home/app/tmp; chown app:app /home/app/tmp
RUN apt-get install -y python3-websockify python3-numpy curl
RUN curl -L https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz | tar -xz

COPY Runfile /

USER app
ENV XDG_RUNTIME_DIR=/home/app/tmp/
ENV WLR_BACKENDS=headless
ENV WLR_LIBINPUT_NO_DEVICES=1
ENV WAYLAND_DISPLAY=wayland-1
ENV DISPLAY=:0
ENTRYPOINT ["/Runfile", "docker.start"]
