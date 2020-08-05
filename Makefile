PROJECT_NAME = docker-dropbox
VERSION = 1.0
CONTAINER_NAME = dropbox-2
BASE_DIR = /home/lab/$(CONTAINER_NAME)
CONFIG_DIR = $(BASE_DIR)/.config
DROPBOX_DIR = $(BASE_DIR)/Dropbox
PORT_PUBLISH = 5905
ARGS_BUILD = build --tag  $(PROJECT_NAME):$(VERSION) .
USER = lab

ARGS_RUN = run --publish $(PORT_PUBLISH):5901 --name $(CONTAINER_NAME) -v $(CONFIG_DIR):/dbox/.config -v $(DROPBOX_DIR):/dbox/Dropbox $(PROJECT_NAME):$(VERSION)

build:
	docker $(ARGS_BUILD)	
run:
	mkdir -p $(CONFIG_DIR) $(DROPOX_DIR)
	chown -R $(USER) $(DROPBOX_DIR)
	chown -R $(USER) $(CONFIG_DIR)
	docker $(ARGS_RUN)
rm:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
clean:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
	docker rmi $(PROJECT_NAME):$(VERSION)
