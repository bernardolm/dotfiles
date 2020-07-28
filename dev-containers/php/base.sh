NOW=$(date +"%Y%m%d%H%M%S%N")

if [[ "$(docker images -q $container_name 2> /dev/null)" == "" ]]; then
    echo -n "building $container_name"
    docker build -f $container_path/Dockerfile $container_path -t $container_name
fi

# echo "Command to run: $@"

$(sleep 10s && docker stop $container_name-${NOW} &> /dev/null) &
