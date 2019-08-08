#Get the directory of the script
SCRIPT_DIR="$(dirname "$0")"

cat "$SCRIPT_DIR/util/aliases.txt" >> ~/.bashrc
. ~/.bashrc
