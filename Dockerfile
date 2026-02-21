FROM ubuntu:22.04

ENV container docker
ENV DEBIAN_FRONTEND=noninteractive

# Install full system + KVM + SSH
RUN apt update && apt install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    sudo \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    iproute2 \
    net-tools \
    curl \
    && apt clean

# Enable SSH
RUN mkdir -p /var/run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Set fixed root password
RUN echo "root:root" | chpasswd

# Enable services
RUN systemctl enable ssh || true
RUN systemctl enable libvirtd || true

VOLUME ["/sys/fs/cgroup"]

STOPSIGNAL SIGRTMIN+3

EXPOSE 22

CMD ["/sbin/init"]
