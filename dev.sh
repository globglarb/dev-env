WORKSPACE_DIR=/home/christianbaczynski
NVIM_CONFIG_DIR=$WORKSPACE_DIR/dev-env/nvim_config
GHOSTTY_CONFIG=$WORKSPACE_DIR/dev-env/ghostty/config

touch $GHOSTTY_CONFIG
cghostty="ghostty --window-height=65 --window-width=220 --config-file=$GHOSTTY_CONFIG "
CONTAINER_EXISTS=$(docker container ls -a | grep dev_env:latest)
if [[ -n "$CONTAINER_EXISTS" ]]; then
  CONTAINER_ID=$(echo $CONTAINER_EXISTS | cut -c1-12)
  echo "/// Trying to start container $CONTAINER_ID"
  cghostty+="-e docker start -i $CONTAINER_ID"
  eval $cghostty
else
  echo "/// Running new container"
  echo $NVIM_CONFIG_DIR $WORKSPACE_DIR
  # XDG_DATA_HOME is set to a folder mounted into the container as for some reason trash-cli fails when trying to save trash, seems it tries to write to the host root (no permission) instead of the docker root
  cghostty+="-e docker run --volume /var/run/docker.sock:/var/run/docker.sock --volume $NVIM_CONFIG_DIR:/root/.config/nvim --volume $WORKSPACE_DIR:/workspace --volume /snap/ghostty/current/share/terminfo:/lib/terminfo -e XDG_DATA_HOME=/workspace/ -e TERMINFO=/lib/terminfo -e TERM=xterm-ghostty -w /workspace -it dev_env:latest"
  eval $cghostty
fi
