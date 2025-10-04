PACKAGE=gosvc-demo
VERSION?=0.1.0
ARCH=amd64
build:
	go build -o bin/$(PACKAGE) main.go
deb: build
	mkdir -p pkg/DEBIAN pkg/usr/local/bin
	cp deb/control pkg/DEBIAN/control
	sed -i "s/Version: .*/Version: $(VERSION)/" pkg/DEBIAN/control
	chmod 0755 deb/postinst
	cp deb/postinst pkg/DEBIAN/postinst
	cp bin/$(PACKAGE) pkg/usr/local/bin/$(PACKAGE)
	dpkg-deb --build pkg $(PACKAGE)_$(VERSION)_$(ARCH).deb
	rm -rf pkg
