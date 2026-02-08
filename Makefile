# ABOUTME: Build system entry points for bg-clock.
# Wraps Swift Package Manager commands for consistent developer experience.

APP_NAME := bg-clock
BUNDLE_NAME := BGClock.app
INSTALL_DIR := $(HOME)/Applications
EXECUTABLE := .build/release/BGClock
VERSION_FILE := VERSION
VERSION := $(shell cat $(VERSION_FILE) 2>/dev/null)
LAUNCHD_LABEL := dev.tigger.bg-clock
LAUNCHD_PLIST := $(HOME)/Library/LaunchAgents/$(LAUNCHD_LABEL).plist
HOMEBREW_TAP := $(realpath ../homebrew-tap)

.PHONY: build test run install uninstall release sync clean bundle \
        launchd-install launchd-uninstall launchd-restart

build:
	swift build -c release

test:
	swift test

run: bundle
	@pkill BGClock 2>/dev/null; true
	@open "$(BUNDLE_NAME)"

clean:
	swift package clean
	rm -rf "$(BUNDLE_NAME)"

bundle: build
	@mkdir -p "$(BUNDLE_NAME)/Contents/MacOS"
	@cp "$(EXECUTABLE)" "$(BUNDLE_NAME)/Contents/MacOS/BGClock"
	@cp Resources/Info.plist "$(BUNDLE_NAME)/Contents/"
	@plutil -replace CFBundleShortVersionString -string "$(VERSION)" "$(BUNDLE_NAME)/Contents/Info.plist"
	@plutil -replace CFBundleVersion -string "$(VERSION)" "$(BUNDLE_NAME)/Contents/Info.plist"
	@echo "Bundle created: $(BUNDLE_NAME) v$(VERSION)"

install: bundle
	@mkdir -p "$(INSTALL_DIR)"
	@cp -R "$(BUNDLE_NAME)" "$(INSTALL_DIR)/"
	@echo "Installed $(BUNDLE_NAME) to $(INSTALL_DIR)"

uninstall: launchd-uninstall
	@rm -rf "$(INSTALL_DIR)/$(BUNDLE_NAME)"
	@echo "Removed $(BUNDLE_NAME) from $(INSTALL_DIR)"

launchd-install: install
	@sed 's|__INSTALL_DIR__|$(INSTALL_DIR)|g' Resources/$(LAUNCHD_LABEL).plist > "$(LAUNCHD_PLIST)"
	@launchctl load "$(LAUNCHD_PLIST)" 2>/dev/null; true
	@echo "Launch agent installed: $(LAUNCHD_LABEL)"

launchd-uninstall:
	@if [ -f "$(LAUNCHD_PLIST)" ]; then \
		launchctl unload "$(LAUNCHD_PLIST)" 2>/dev/null; \
		rm -f "$(LAUNCHD_PLIST)"; \
		echo "Launch agent removed: $(LAUNCHD_LABEL)"; \
	fi

launchd-restart:
	@launchctl unload "$(LAUNCHD_PLIST)" 2>/dev/null; true
	@launchctl load "$(LAUNCHD_PLIST)" 2>/dev/null; true
	@echo "Restarted $(LAUNCHD_LABEL)"

release:
	@current=$$(cat $(VERSION_FILE)); \
	if [ -z "$(V)" ]; then \
		major=$$(echo "$$current" | cut -d. -f1); \
		minor=$$(echo "$$current" | cut -d. -f2); \
		new_minor=$$((minor + 1)); \
		new="$$major.$$new_minor.0"; \
	else \
		new="$(V)"; \
	fi; \
	echo "$$new" > $(VERSION_FILE); \
	echo "Version: $$current -> $$new"; \
	$(MAKE) bundle; \
	git add VERSION; \
	git commit -m "release: v$$new"; \
	git tag "v$$new"; \
	if [ -d "$(HOMEBREW_TAP)" ]; then \
		$(MAKE) update-homebrew VERSION="$$new"; \
	fi

update-homebrew:
	@if [ -z "$(VERSION)" ]; then echo "VERSION required"; exit 1; fi
	@echo "Updating Homebrew cask to v$(VERSION)"
	@if [ -f "$(HOMEBREW_TAP)/Casks/$(APP_NAME).rb" ]; then \
		sed -i '' 's/version ".*"/version "$(VERSION)"/' "$(HOMEBREW_TAP)/Casks/$(APP_NAME).rb"; \
		cd "$(HOMEBREW_TAP)" && git add "Casks/$(APP_NAME).rb" && \
		git commit -m "$(APP_NAME): update to v$(VERSION)" && \
		git push; \
		echo "Homebrew cask updated to v$(VERSION)"; \
	else \
		echo "No cask found at $(HOMEBREW_TAP)/Casks/$(APP_NAME).rb"; \
	fi

sync:
	git add --all
	@if git diff --cached --quiet; then \
		echo "Nothing to commit"; \
	else \
		git commit -m "sync: $$(date -u +%Y-%m-%dT%H:%M:%SZ)"; \
	fi
	git submodule update --init --recursive 2>/dev/null; true
	git pull --rebase
	git push
