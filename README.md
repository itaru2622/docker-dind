## docker-dind

sample image for docker in docker based on debian

dind requires:
- privileged mode
- overwrite DNS servers address, since dockerd changes dns server to 127.x.x.x in default behavior then container in container cannot resolve dns.
- packages: kmod(lsmod/insmod) and may need iproute2 and iptables.
