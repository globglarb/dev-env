WORKSPACE_DIR=~/Dev/
NVIM_CONFIG_DIR=~/Dev/dev_env/nvim_config

CONTAINER_EXISTS=`docker container ls -a | grep dev_env:latest`
if [[ -n "$CONTAINER_EXISTS" ]]; then 
    CONTAINER_ID=`echo $CONTAINER_EXISTS | cut -c1-12`
    echo "Trying to start container $CONTAINER_ID"
    ghostty --window-height=65 --window-width=220 -e docker start -i $CONTAINER_ID
else
    echo $NVIM_CONFIG_DIR $WORKSPACE_DIR
    docker run --volume $NVIM_CONFIG_DIR:/root/.config/nvim --volume $WORKSPACE_DIR:/workspace -w /workspace -it dev_env:latest
fi

