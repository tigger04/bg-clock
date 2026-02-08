# ABOUTME: Build system entry points for bg-clock.
# Wraps Swift Package Manager commands for consistent developer experience.

APP_NAME := bg-clock
BUNDLE_NAME := BGClock.app
INSTALL_DIR := $(HOME)/Applications
EXECUTABLE := .build/release/BGClock
VERSION_FILE := VERSION
VERSION := $(shell cat $(VERSION_FILE) 2>/dev/null)

.PHONY: build test run install uninstall release sync clean bundle

build:
	swift build -c release

test:
	swift test

run: build
	$(EXECUTABLE) &

clean:
	swift package clean
	rm -rf $(BUNDLE_NAME)

bundle: build
	@mkdir -p "$(BUNDLE_NAME)/Contents/MacOS"
	@cp "$(EXECUTABLE)" "$(BUNDLE_NAME)/Contents/MacOS/BGClock"
	@cp Resources/Info.plist "$(BUNDLE_NAME)/Contents/"
	@plutil -replace CFBundleShortVersionString -string "$(VERSION)" "$(BUNDLE_NAME)/Contents/Info.plist"
	@plutil -replace CFBundleVersion -string "$(VERSION)" "$(BUNDLE_NAME)/Contents/Info.plist"

install: bundle
	@mkdir -p "$(INSTALL_DIR)"
	@cp -R "$(BUNDLE_NAME)" "$(INSTALL_DIR)/"
	@echo "Installed $(BUNDLE_NAME) to $(INSTALL_DIR)"

uninstall:
	@rm -rf "$(INSTALL_DIR)/$(BUNDLE_NAME)"
	@echo "Removed $(BUNDLE_NAME) from $(INSTALL_DIR)"

release:
	@current=$$(cat $(VERSION_FILE)); \
	if [ -z "$(V)" ]; then \
		major=$$(echo "$$current" | cut -d. -f1); \
		minor=$$(echo "$$current" | cut -d. -f2); \
		patch=$$(echo "$$current" | cut -d. -f3); \
		new_minor=$$((minor + 1)); \
		new="$$major.$$new_minor.0"; \
	else \
		new="$(V)"; \
	fi; \
	echo "$$new" > $(VERSION_FILE); \
	echo "Version: $$current -> $$new"; \
	$(MAKE) bundle; \
	git add VERSION "$(BUNDLE_NAME)" ; \
	git commit -m "release: v$$new"; \
	git tag "v$$new"

sync:
	git add --all
	git commit -m "sync: $$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	git pull
	git push
