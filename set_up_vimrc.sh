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
		echo "*) do nothing"
		read -n 1 answer
		echo
		case $answer in
			r)
				rm $HOME/.vimrc
				create_link
				break
				;;
			s)
				diff -u .vimrc $HOME/.vimrc | less
				echo
				;;
			*)
				break
				;;
		esac
	done
else
	create_link
fi

VUNDLEPATH=$HOME/.vim/bundle/Vundle.vim
VUNDLELINK=https://github.com/VundleVim/Vundle.vim.git 
ls $VUNDLEPATH 1>/dev/null 2>&1
if [ $? -eq 0 ]; then # if Vundle installed
	echo "Vundle detected in $VUNDLEPATH."
else
	while true; do
		echo
		echo "Vundle not detected, install it now? (requires network)"
		echo "y) yes, install"
		echo "*) no, don't install now"
		read -n 1 answer
		echo
		case $answer in
			y)
				mkdir -p ${VUNDLEPATH%/*}
				echo "Start Installing vundle"
				echo "cloning from $VUNDLELINK..."
				git clone $VUNDLELINK $VUNDLEPATH 1>/dev/null 2>&1 && echo "Vundle installed in $VUNDLEPATH" || echo "Failed to install Vundle"
				break
				;;
			*)
				echo
				echo "Not install vundle"
				break
				;;
		esac
	done
fi
