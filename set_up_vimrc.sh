#!/bin/bash
realpath() {
	perl -mCwd -e "print Cwd::abs_path('$1')"
}

# directory of the current script
DIR=$(dirname `realpath $0`) # get current directory
if [ ! -f "$DIR/.vimrc" ]; then
	echo ".vimrc not detected in $DIR, terminating script"
	exit -1
fi

# Create a link
create_link() {
	echo "Creating a link of $1 to $2..."
	local src=`realpath "$1"`
	local dest=`realpath "$2"`
	ln -s "$src" "$dest"
	if [ $? -eq 0 ]; then
		echo "done!"
	else
		echo "Error occurred when trying to create symbolic link" 
	fi
}

if [ -L $HOME/.vimrc -a "$(readlink $HOME/.vimrc)" -ef $DIR/.vimrc ]; then # if vimrc exists and is a link to the current directory
	#: # do nothing
	echo "$HOME/.vimrc already points to the .vimrc in the current directory"
elif [ ! -e $HOME/.vimrc ]; then # if vimrc does not exist
	if [ -L $HOME/.vimrc ]; then # if broken link, remove
		rm $HOME/.vimrc && echo "removed broken link $HOME/.vimrc"
	fi
	create_link $DIR/.vimrc $HOME/.vimrc
elif [ -f $HOME/.vimrc -o -L $HOME/.vimrc ]; then # if vimrc exists as a file or a link to some other file
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
				create_link $DIR/.vimrc $HOME/.vimrc
				break
				;;
			c)
				rm $HOME/.vimrc
				cp $DIR/.vimrc $HOME/.vimrc && echo "replaced with a copy of .vimrc in current directory"
				break
				;;
			s)
				diff -u $HOME/.vimrc $DIR/.vimrc | less
				echo
				;;
			*)
				break
				;;
		esac
	done
else
	echo "Undetected file type $HOME/.vimrc, symlink not created"
fi

# Install Plug
PLUGPATH=$HOME/.vim/autoload/plug.vim
PLUGLINK=https://github.com/junegunn/vim-plug.git
ls $PLUGPATH 1>/dev/null 2>&1
if [ $? -eq 0 ]; then # if Plug installed
	echo "Plug detected in $PLUGPATH."
else
	while true; do
		echo
		echo "Plug not detected, install it now? (requires network)"
		echo "y) yes, install"
		echo "*) no, don't install now"
		read -n 1 answer
		echo
		case $answer in
			y)
				mkdir -p ${PLUGPATH%/*}
				echo "Start Installing Plug"
				echo "cloning from $PLUGLINK..."
				curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				if [ $? -eq 0 ]; then
					echo "Plug installed in $PLUGPATH" 
					vim +PlugInstall +qall
					echo "Installed vim plugin"
				else
					echo "Failed to install Plug"
				fi
				break
				;;
			*)
				echo
				echo "Not install plug"
				break
				;;
		esac
	done
fi

# Set up UltiSnips
# TODO: Add more logic to automatically override when the folder is empty, or is a broken link
ULTISNIPSPATH=$HOME/.vim/UltiSnips

if [ -d "${DIR}/UltiSnips" ]; then # if snippet folder exists in current directory
	if [ -L ${ULTISNIPSPATH} -a "$(readlink ${ULTISNIPSPATH})" -ef $DIR/UltiSnips ]; then # if there is already a link pointing to the folder in current directory
		echo "$ULTISNIPSPATH already points to the current directory"
	elif [ -d ${ULTISNIPSPATH} -o -L ${ULTISNIPSPATH} ]; then # if the folder exists, or is a link to other directory (or a broken link), ask for conflict resolution
		echo "Directory ${ULTISNIPSPATH} already exists, symlink not created. Please check and merge any wanted snippet files."
	 	echo "You can rerun this script again with ${ULTISNIPSPATH} deleted"
	elif [ ! -e "$ULTISNIPSPATH" ]; then # if does not exist at all
		create_link $DIR/UltiSnips $ULTISNIPSPATH
	else # if exists in any other form
		echo "Undetected file type: ${ULTISNIPSPATH}, symlink not created"
	fi
fi
