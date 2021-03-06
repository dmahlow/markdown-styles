UNAME := $(shell uname)

build:
	for name in `find ./layouts -mindepth 1 -maxdepth 1 -type d | sed -e 's/.\/layouts\///'` ; do \
		./bin/generate-md --layout $$name --output ./output/$$name/; \
	done

preview:
ifeq ($(UNAME), Linux)
	xdg-open output/index.html
endif
ifeq ($(UNAME), Darwin)
	open output/index.html
endif

# Note: for fonts to render you need to download them first
screenshots: build
	rm -f ./screenshots/*.png
	for name in `find ./output -mindepth 1 -maxdepth 1 -type d | sed -e 's/.\/output\///'` ; do \
				cutycapt --url=file://$(CURDIR)/output/$$name/index.html --out=./screenshots/$$name.png ; \
				convert ./screenshots/$$name.png -resize "800x" -crop 800x600+0+0  +repage ./screenshots/$$name-cropped.png ; \
				rm ./screenshots/$$name.png ; \
				mv ./screenshots/$$name-cropped.png ./screenshots/$$name.png ; \
	done

# Download google fonts for cutycapt
get-fonts:
	node font-download.js

.PHONY: build screenshots get-fonts
