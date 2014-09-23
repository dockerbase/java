NAME = dockerbase/java
VERSION = 1.1

.PHONY: all build test tag_latest release ssh

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm .

test:
	docker run -it --rm $(NAME):$(VERSION) echo hello world

run:
	docker run -it --rm $(NAME):$(VERSION) 

version:
	docker run -it --rm $(NAME):$(VERSION) sh -c " lsb_release -d ; git --version ; " | tee COMPONENTS
	docker run -it --rm $(NAME):$(VERSION) sh -c 'java -version ; git --version' | tee -a COMPONENTS
	dos2unix COMPONENTS
	sed -i -e 's/^/    /' COMPONENTS
	sed -i -e '/^### Components & Versions/q' README.md
	echo >> README.md
	cat COMPONENTS >> README.md
	rm COMPONENTS

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	#@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

