
default:
	@echo 'starting docker to test first steps ubuntu'
	@docker build -t=bernardolm/first-steps-ubuntu .
	@docker run --rm -v `pwd`:/opt/first-steps-ubuntu --workdir=/opt/first-steps-ubuntu bernardolm/first-steps-ubuntu ./first-steps-ubuntu.sh
