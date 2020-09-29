#https://jmkhael.io/makefiles-for-your-dockerfiles/

include make_env

.PHONY: config build push shell run start stop rm release 

cleardb: 
	rm $(DB_FILE)
	
config:
	#sample config setup
	if ! [ -d $(CONFIG_PATH) ] ; then mkdir -p $(CONFIG_PATH) ; fi
	if ! [ -f $(CONFIG_FILE) ] ; then \
	echo "copying example config to $(CONFIG_PATH)" ; \
	cp ./lib/config.yml.example $(CONFIG_PATH)/config.yml ; \
	fi
	if ! [ -f $(DB_FILE) ]; then \
	echo "creating test db.sqlite3 file" ;\
	touch $(DB_FILE) ;\
	fi

build: Dockerfile
	docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

br: kill build run

cli:
	docker run --rm --name $(UIDS) $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) ./cli.rb

execcli: kill build cli

push:
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)
exec: 
	docker exec -it $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) bash

shell:
	docker run --rm --name $(UIDS) $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

run: config
	docker run --rm --name $(UIDS) $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

start: config
	docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

stop:
	docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

kill:
	- docker kill $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
	docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

runcwd: kill build
	docker run --rm -it --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(CWDVOLUME) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) bash

	
default: build

	