
default:
	@echo "starting docker to test first steps ubuntu"
	@docker build -t=bernardolm/dotfiles .
	@docker run --rm -v `pwd`:/opt/dotfiles --workdir=/opt/dotfiles bernardolm/dotfiles ./first-steps-ubuntu.sh
