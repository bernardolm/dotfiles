# nodejs

```sh
alias docker-nodejs="docker run -it -v $HOME/.docker-nodejs:/home/node -u $(id -u) -v $(pwd):/home/node/app -w /home/node/app node"
```