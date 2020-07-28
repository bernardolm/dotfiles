function kube_shell () {
    IMAGE=`pwd`
    IMAGE=`basename $IMAGE`
    if [ -n "$1" ]; then
        IMAGE="$1"
    fi
    echo "Opening shell into pod '$IMAGE'..."
    kubectl exec -it "$IMAGE" sh
}
