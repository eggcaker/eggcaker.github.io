all: setenv serve

setenv:
	/usr/local/bin/emacsclient -n /Users/eggcaker/src/personal/emacs.cc/content-org/blog.org && git pull --rebase && open "http://localhost:1313/"

serve:
	hugo server -D --navigateToChanged

deploy:
	./deploy.sh
