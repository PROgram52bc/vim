create_link() {
	echo "Creating a link of .vimrc to $HOME..."
	ln -s $(realpath .vimrc) ~/.vimrc && echo "done!" || echo "Error occurred when trying to create symbolic link"
}

ls $HOME/.vimrc 1>/dev/null 2>&1
if [ $? -eq 0 ]; then # if the file exists
	while true; do
		echo ".vimrc already exists in $HOME, to continue, enter one option: "
		echo "r) replace the current file"
		echo "s) show diff"
		echo "q) quit"
		read -n 1 answer
		case $answer in
			r)
				echo
				rm $HOME/.vimrc
				create_link
				break
				;;
			s)
				echo
				diff -u .vimrc $HOME/.vimrc | less
				echo
				;;
			*)
				echo
				echo "exit..."
				break
				;;
		esac
	done
else
	create_link
fi
