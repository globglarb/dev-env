# TODO, full from scratch installation of docker, git
# TODO, optionally install a terminal emulator to open the dev env
FONT_NAME=GeistMono
FONT_SETUP=`fc-list | grep $FONT_NAME`

echo "Installing font $FONT_NAME, this will change the font for ALL terminals"
./fonts.sh $FONT_NAME

IMAGE_BUILT=`docker image ls -a | grep "dev_env"`
if [[ -n "$IMAGE_BUILT" ]]; then 
    echo "Docker image exists"; 
else
    echo "Docker image missing, building...";
    docker build . dev_env:latest 
fi

echo "Installing terminal emulator Ghostty using snap"
# install via snap
if [[ -z "systemctl --type=service --state=running | grep snapd" ]];   then
    # clean up block snap configuration
    echo "Installing snap..."
    sudo rm /etc/apt/preferences.d/nosnap.pref
    sudo apt-get install snapd
fi
if ! type "ghostty" > /dev/null; then
    echo "Installing ghostty..."
    snap install ghostty --classic
fi

if ! type "dev" > /dev/null; then
    echo "Creating a link to start dev env as CLI command"
    DEV_ENV_PATH=`pwd`
    cd /usr/local/bin && sudo ln -s $DEV_ENV_PATH/dev.sh dev
fi

