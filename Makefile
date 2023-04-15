OUTPUT_DIR ?= output
OUTPUT_FILE ?= report

MAIN_BUILD_FILE=main

BUILD=xelatex
BUILD_OPT=-synctex=1 -interaction=nonstopmode -file-line-error -recorder -output-directory="$(OUTPUT_DIR)" -jobname=$(OUTPUT_FILE)
CLEAN_FILES=*.aux *.fdb_latexmk *.fls *.log *.out *.blg *.bbl *.ps *.synctex.gz *.toc *.nav *.snm *.xdv *.lot *lof

DOCKER_IMAGE ?= lanolin25/docker-latex
DOCKER_IMAGE_VERSION ?= v1.3
DOCKER_IMAGE_ALL ?= $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

all: clear build clean

clean:
	@cd ./$(OUTPUT_DIR)
	@rm -f $(CLEAN_FILES)
	@cd ../

clear:
	@rm -rf $(OUTPUT_DIR)

create_output_dir:
	@mkdir -p $(OUTPUT_DIR)

build: create_output_dir *.tex
	$(BUILD) $(BUILD_OPT) $(MAIN_BUILD_FILE).tex

docker-create:
	docker build -t $(DOCKER_IMAGE_NAME) .

docker-build:
	docker run --rm -ti -v ${PWD}:/build:Z $(DOCKER_IMAGE_NAME) sh -c "make clean clear build clean"