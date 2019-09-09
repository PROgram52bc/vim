# Create a link to ~/.vimrc
create_link() {
	echo "Creating a link of .vimrc to $HOME..."
	ln -s $(realpath .vimrc) $HOME/.vimrc && echo "done!" || echo "Error occurred when trying to create symbolic link" 
}

if [ ! -e $HOME/.vimrc ]; then # if vimrc does not exist
	create_link
elif [ -L $HOME/.vimrc -a "$(readlink $HOME/.vimrc)" -ef .vimrc ]; then # if vimrc exists and is a link to the current directory
	#: # do nothing
	echo "$HOME/.vimrc already points to the .vimrc in the current directory"
else # if vimrc exists and is not pointing to the current directory
	while true; do
		echo ".vimrc already exists in $HOME, to continue, enter one option: "
		echo "r) replace with a symlink to the .vimrc in current directory"
		echo "c) replace with a copy of the .vimrc in current directory"
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
			c)
				cp .vimrc ~/.vimrc && echo "replaced with a copy of .vimrc in current directory"
				break
				;;
			s)
				diff -u $HOME/.vimrc .vimrc | less
				echo
				;;
			*)
				break
				;;
		esac
	done
fi

# Install Vundle
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

# temporary solution: install prettier (should be done with vim plugin manager's post-install hook)
PRETTIERPATH=$HOME/.vim/bundle/vim-prettier
if [ ! -d ${PRETTIERPATH} ]; then # if prettier not installed
	echo "Prettier not installed (install with Vundle by executing :PluginInstall in vim)"
elif [ ! -d ${PRETTIERPATH}/node_modules ]; then # if prettier installed but not built
	cd $PRETTIERPATH
	echo "Building prettier..."
	npm install 1>/dev/null 2>&1 && echo "Prettier built in $PRETTIERPATH" || "Failed to install prettier"
else
	echo "Prettier already built."
fi
