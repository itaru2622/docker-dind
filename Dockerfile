ARG base=debian:trixie
FROM ${base}
ARG base=debian:trixie

RUN  apt update; apt install -y curl gnupg2 vim bash-completion git make net-tools
RUN  curl -L https://download.docker.com/linux/debian/gpg > /etc/apt/trusted.gpg.d/docker.asc; \
     echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

# docker in docker requires kmod, and may need iproute2, iptables
RUN  apt update; apt install -y docker-ce docker-ce-cli docker-compose-plugin kmod    iproute2 iptables

RUN echo "set mouse-=a" > /root/.vimrc;
ENV DOCKER_DRIVER=vfs
