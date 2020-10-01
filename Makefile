#https://jmkhael.io/makefiles-for-your-dockerfiles/

include make_env

.PHONY: config build push shell run start stop rm release 

initdb: config
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)  rake db:create

clean: cleandb 

cleandb: 
	rm $(DB_FILE)
cleanconf:
	rm -rf $(CONFIG_FILE)
	
config:
	#sample config setup
	if ! [ -f $(CONFIG_FILE) ] ; then \
	cp ./$(CONFIG_FILE).example $(CONFIG_FILE) ; \
	fi

	if ! [ -f $(DBCONF_FILE) ] ; then \
	cp ./$(DBCONF_FILE).example $(DBCONF_FILE) ; \
	fi

	if ! [ -f $(DB_FILE) ]; then \
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) rake db:prepare VERBOSE=true ;\
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) rake db:seed VERBOSE=true ;\
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

shell: build
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) -i -t $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

run: config
	docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) 

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
	docker run --rm -it --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(UIDS) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) bash

default: build

	