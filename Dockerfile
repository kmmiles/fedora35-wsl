FROM fedora:35
ENV WSL_DISTRO_NAME fedora35
WORKDIR /provision

# update dnf.conf to not skip documentation
COPY ./etc/dnf.conf /etc/dnf/dnf.conf

# upgrade existing packages
RUN set -ex; dnf upgrade -y

# re-install a few packages. some tools are missing setuid.
RUN set -ex; dnf reinstall -y \
  sudo \
  shadow-utils

# install base packages
RUN set -ex; \
  dnf install -y \
    attr \
    man-pages \
    man-db \
    man \
    ansible \
    redhat-lsb-core \ 
    cracklib-dicts \
    passwd \
    git \
    python3 \
    podman \
    crun \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    wl-clipboard

# rebuild manpages
RUN set -ex; mandb

# add rpm fusion repo
RUN set -ex; \
  dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# create wsl user and set passwords
RUN set -ex; \
  useradd -m -s /bin/zsh -G wheel "wsl" && \
  printf "wsl" | passwd --stdin "wsl"  && \
  printf "wsl" | passwd --stdin "root" 

# create dumb `docker` wrapper for `podman`
RUN set -ex; \
  printf "#!/bin/sh\n" > /usr/bin/docker && \
  printf "exec /usr/bin/podman \"\$@\"\n" >> /usr/bin/docker && \
  chmod +x /usr/bin/docker

# copy stuff
COPY ./etc/wsl.conf /etc/wsl.conf
COPY ./etc/passwordless /etc/sudoers.d/passwordless
COPY ./bin/wsl-on-boot /usr/local/bin

# handle shrinking image
ARG SHRINK
RUN set -ex; \
  if [[ "$SHRINK" == true ]]; then \
    dnf autoremove -y \
    dnf clean all -y \
    find /root -mindepth 1 -exec rm -rf {} \; \
    find /tmp -mindepth 1 -exec rm -rf {} \; \
    find /var/tmp -mindepth 1 -exec rm -rf {} \; \
    find /var/cache -type f -exec rm -rf {} \; \
    find /var/log -type f | while read -r f; do /bin/echo -ne "" > "$f"; done \
  fi
