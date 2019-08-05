$(eval TAG := $(shell cat TAG))

all: build run

build: .NETWORK
	$(eval NETWORK := $(shell cat .NETWORK))
	docker build \
		-t ${TAG} \
		--network ${NETWORK} \
		-f ./Dockerfile \
		.

run: clean .cid

.cid: .port .NETWORK
	$(eval ID_U := $(shell id -u))
	$(eval ID_G := $(shell id -g))
	$(eval NETWORK := $(shell cat .NETWORK))
	docker run \
		-it \
		--cidfile=.cid \
		-d \
		--network=${NETWORK} \
		-u ${ID_U}:${ID_G} \
		-p `cat .port`:5000 \
		${TAG}


exec:
	-@docker exec -it `cat .cid` /bin/sh

logs:
	-@docker logs `cat .cid`

kill:
	-@docker kill `cat .cid`

rm:
	-@docker rm `cat .cid`
	-@rm .cid

clean: kill rm

.port:
	@while [ -z "$$PORTLISTENER" ]; do \
		read -r -p "Enter the port you wish to associate with this listener container [PORTLISTENER]: " PORTLISTENER; echo "$$PORTLISTENER">>.port; cat .port; \
	done ;

.NETWORK:
	@while [ -z "$$NETWORK" ]; do \
		read -r -p "Enter the docker network you wish to associate with this server container [NETWORK]: " NETWORK; echo "$$NETWORK">>.NETWORK; cat .NETWORK; \
	done ;

.user:
	@while [ -z "$$NGINX_USER" ]; do \
		read -r -p "Enter the user you wish to associate with this server container [NGINX_USER]: " NGINX_USER; echo "$$NGINX_USER">>.user; cat .user; \
	done ;

.host:
	@while [ -z "$$HOST" ]; do \
		read -r -p "Enter the host you wish to associate with this server container [HOST]: " HOST; echo "$$HOST">>.host; cat .host; \
	done ;

.pass:
	@while [ -z "$$NGINX_PASS" ]; do \
		read -r -p "Enter the pass you wish to associate with this server container [NGINX_PASS]: " NGINX_PASS; echo "$$NGINX_PASS">>.pass; cat .pass; \
	done ;
