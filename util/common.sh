#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

. $SCRIPT_DIR/util/suppress_gedit.sh

#Variables that change the color of text when used in echo -e
R='\033[0m' #Reset color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

function echo_status() {
   echo -e "${YELLOW}$*"
   tput sgr0
}

function line_add_msg() {
   clear
   echo_status "[Please add the following line(s) (copied to clipboard)]"
}

function line_change_msg() {
   clear
   echo_status "[Please change the following line(s)]"
}

function pause() {
   read -p "[33m$*[0m: "
}

function pause_general() {
   pause "[Press ENTER to continue]"
   clear
}

#Opens a file in gedit at the first line that matches the grep pattern
#$1 File path
#$2 Line grep pattern
function gedit_at_line() {
   gedit $1 +$(grep $2 -m 1 -n $1 | cut -f1 -d:)
}

function copy() {
   echo $* | xclip -selection c
}
