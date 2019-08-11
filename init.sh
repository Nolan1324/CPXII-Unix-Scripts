#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

#Install xclip for copying text
sudo apt-get install xclip

#Load aliases
cat "$SCRIPT_DIR/util/aliases.txt" >> ~/.bashrc

#Reload bash (causes ~/.bashrc to execute; allows for the new aliases to be loaded into this terminal session)
exec bash
