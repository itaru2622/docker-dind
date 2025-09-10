wDir  ?=${PWD}

distr ?=trixie
img   ?=itaru2622/dind:${distr}
base  ?=debian:${distr}
cName ?=dind

# tune options by modes (dind or ordinal)
dind  ?=true
ifeq ($(dind),true)
# case1) docker in docker mode (dind == true), starts dockerd via systemd
# to run dockerd/systemd, --privileged required.
# need to overwrite dns servers to real network, since dockerd changes dns server to 127.0.0.11 => container in container cannot resolve DNS.
cmd     ?=/lib/systemd/systemd
dOpts   ?=-id --privileged
dnsOpts ?=$(shell cat /etc/resolv.conf | grep -v ^# | grep nameserver | awk '{print "--dns", $$2}' | paste -sd " " - )
# case1 end
else
# case2) ordinal mode (dind != true)
cmd     ?=/bin/bash
dOpts   ?=-it --rm -v ${wDir}:${wDir} -w ${wDir}
dnsOpts ?=
# case2 end
endif
# end options by modes


build:
	docker build --build-arg base=${base} -t ${img} .

# start container with dockerd
start:
	docker run --name ${cName} ${dOpts} ${dnsOpts} ${img} ${cmd}

stop:
	docker rm -f ${cName} 

bash:
	docker exec -it ${cName} /bin/bash

cstart:
	img=${img} docker-compose up -d
cstop:
	img=${img} docker-compose down -v
cbash:
	img=${img} docker-compose exec dind /bin/bash
