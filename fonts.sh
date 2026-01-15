# the terminal of the host system is used to render NeoVim
# this installs the configuration utility and configures the terminal font

# nerd font download and config
FONT_NAME=$1

FONT_SETUP=`fc-list | grep $FONT_NAME`
if [[ -z "$FONT_SETUP" ]]; then 
    curl -OL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_NAME.zip" && mkdir -p  "$HOME/.fonts" && unzip "$FONT_NAME.zip" -d "$HOME/.fonts/$FONT_NAME/" && fc-cache -fv
    rm ${FONT_NAME}.zip
fi

# install command line configuration for terminal and other config
if ! type "dconf" > /dev/null; then
    sudo apt-get update && sudo apt-get install dconf-editor
fi

# get terminal profile folder name 
PROFILE_NAME=`dconf list /org/gnome/terminal/legacy/profiles:/`

# change to nerd font
FONT_CONFIG="$FONT_NAME Nerd Font 12"
dconf write /org/gnome/terminal/legacy/profiles:/${PROFILE_NAME}font "'$FONT_CONFIG'"