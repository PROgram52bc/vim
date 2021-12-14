# vim
vim configuration file

## Usage
Clone the repository to some local directory, and execute
```bash
./set_up_vimrc.sh
```
Currently it requires `pip` (for `autopep8`) and `node` (for `coc-nvim`) to be installed in the system.

## Windows with wsl
The `set_up_vimrc.sh` script is intended to be used for linux systems exclusively.

On Windows, if there is a wsl with vim initialized using the above method, you can perform the following manual setup to share the configuration file and plugin files for the Windows machine:

- Set the `$HOME` environment variable to `C:\Users\<username>`. This can be done permanently in the control panel or temporarily using [Powershell](https://www.educba.com/powershell-set-environment-variable/).
- Create a _hard link_ from the original `.vimrc` file to `C:\Users\<username>/_vimrc`. 
	- In Powershell, use something like `New-Item -ItemType HardLink -Path C:\Users\<username> -Name _vimrc -Value path\to\original\.vimrc`.
	- If run with admin, can replace `HardLink` with `SymbolicLink`, so that vim can infer the actual directory when editing the configuration file.
- Create a _junction_ from the original `.vim` directory to `C:\Users\<username>/.vim`. (In Powershell, use something like `New-Item -ItemType Junction -Path C:\Users\<username> -Name .vimrc -Value path\to\original\.vim`).

Now type `vim` in Powershell, the configuration and plugins should be loaded.
