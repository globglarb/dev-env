
WORKSPACE_DIR=/home/christianbaczynski
NVIM_CONFIG_DIR=$WORKSPACE_DIR/dev-env/nvim_config
GHOSTTY_CONFIG=$WORKSPACE_DIR/dev-env/ghostty/config

CONTAINER_EXISTS=`docker container ls -a | grep dev_env:latest`
if [[ -n "$CONTAINER_EXISTS" ]]; then 
    CONTAINER_ID=`echo $CONTAINER_EXISTS | cut -c1-12`
    echo "/// Trying to start container $CONTAINER_ID"
    ghostty --window-height=65 --window-width=220 --config-file=$GHOSTTY_CONFIG -e docker start -i $CONTAINER_ID
else
    echo "/// Running new container"
    echo $NVIM_CONFIG_DIR $WORKSPACE_DIR
    ghostty --window-height=65 --window-width=220 -e docker run --volume $NVIM_CONFIG_DIR:/root/.config/nvim --volume $WORKSPACE_DIR:/workspace -w /workspace -it dev_env:latest
fi

