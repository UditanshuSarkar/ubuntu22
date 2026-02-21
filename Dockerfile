FROM ubuntu:22.04

ENV container docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    sudo \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    && apt clean

# Set root password
RUN echo "root:root" | chpasswd

# Configure SSH
RUN mkdir -p /var/run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 22

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
