all: serve

serve:
	hugo server -D --navigateToChanged

deploy:
	./deploy.sh
