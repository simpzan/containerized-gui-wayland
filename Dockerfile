FROM registry.fedoraproject.org/fedora-minimal:37
RUN microdnf install -y --setopt install_weak_deps=0 busybox spice-html5 python3-websockify novnc \
    weston labwc sway wayvnc dbus-daemon procps-ng foot wofi bemenu \
    google-noto-naskh-arabic-fonts dejavu-fonts-all
RUN microdnf install -y --setopt install_weak_deps=0 vulkan-tools vulkan-loader-devel mesa-vulkan-drivers
RUN microdnf install -y --setopt install_weak_deps=0 meson dnf
RUN dnf install -y 'dnf-command(builddep)' llvm13-devel.x86_64 && dnf builddep mesa -y
RUN dnf install -y cmake glfw-devel.x86_64 assimp-devel.x86_64 freetype-devel.x86_64 \
    glm-devel.noarch tinyobjloader-devel.x86_64 stb_image-devel.x86_64 \
    wayland-devel libxkbcommon-devel wayland-protocols-devel extra-cmake-modules
# RUN microdnf clean all

RUN mkdir /opt/busybox; \
    /sbin/busybox --install -s /opt/busybox
ENV PATH=/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/busybox
RUN cp /usr/share/weston/background.png /usr/share/backgrounds/default.png ; \
    busybox adduser -D app ; \
    busybox passwd -l app ; \
    mkdir -p /home/app/tmp ; busybox chown app:app /home/app/tmp
RUN dnf install -y sudo && echo "app ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ADD weston-terminal.desktop /usr/share/applications/weston-terminal.desktop
ADD sway /etc/sway/config.d/sway
ADD labwc /etc/xdg/labwc

RUN dnf install -y git vim trace-cmd nodejs zip file
RUN dnf install -y fzf && \
    echo '[[ -x "$(command -v fzf)" ]] && source /usr/share/fzf/shell/key-bindings.bash' > /etc/profile.d/fzf.sh

USER app
ENV SHELL=/bin/bash
ENV PATH=/home/app/.local/bin:/home/app/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/busybox
ENV XDG_RUNTIME_DIR=/home/app/tmp
ENV WLR_BACKENDS=headless
ENV WLR_LIBINPUT_NO_DEVICES=1
ENV WAYLAND_DISPLAY=wayland-1

ADD start.sh /start.sh

EXPOSE 5900
EXPOSE 8080


ENTRYPOINT ["/start.sh"]



