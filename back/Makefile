##
# emacs.cc build webiste
#
# @file
# @version 0.1

.ONESHELL:
COMMIT_TIME = $(date '+%Y-%m-%d %H:%M:%S')

all: build deploy commit

commit:
	git add .
	git ci -m 'added post' -a
	git push origin main

build:
	bash build.sh

serve: build
	@serve _site

deploy:
	@git add . && \
	git ci -m "update blog by eggcaker at ${COMMIT_TIME}" && \
	git push origin main && \
	echo "Deployed"


# end
