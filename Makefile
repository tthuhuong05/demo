# ===== Makefile for gosvc =====
PACKAGE ?= gosvc-demo
VERSION ?= $(shell echo $(GITHUB_REF_NAME) | sed 's/^v//;t;d')
ARCH    ?= amd64

# Nếu chạy local không có biến GITHUB_REF_NAME thì mặc định 0.0.0
ifeq ($(VERSION),)
  VERSION := 0.0.0
endif

build:
	go build -o bin/$(PACKAGE) main.go

deb: build
	# layout gói deb chuẩn
	rm -rf pkg
	mkdir -p pkg/DEBIAN pkg/usr/local/bin
	printf "Package: $(PACKAGE)\nVersion: $(VERSION)\nSection: utils\nPriority: optional\nArchitecture: $(ARCH)\nMaintainer: You <you@example.com>\nDescription: Demo service packaged as .deb\n" > pkg/DEBIAN/control
	printf "#!/bin/sh\necho \"$(PACKAGE) installed\"\nexit 0\n" > pkg/DEBIAN/postinst
	chmod 0755 pkg/DEBIAN/postinst
	cp bin/$(PACKAGE) pkg/usr/local/bin/$(PACKAGE)
	dpkg-deb --build pkg $(PACKAGE)_$(VERSION)_$(ARCH).deb
	rm -rf pkg
