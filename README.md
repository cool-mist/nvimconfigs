# Nvimconfigs #

My neovim settings. Contrary to popular opinion of breaking down your configs, this configuration is a single file because why not!! It is becoming very difficult to split them anyways with plugin dependencies on other settings, plugins defining keybinds in their setup and so on.

This uses Packer as the plugin manager.

# Prerequisites #

- Tested on Arch and Arch WSL. Should probably work on most linux distros.
- `neovim`
- `npm`
- `python`
- `python-pynvim`
- `pip`
- `go`
- `rust`
- `ripgrep` - for fuzzy searching
- `fzf` - for fuzzy searching
- `zk` - for notetaking

# Installation #

- `make install`

## Manually ##

Above command will take a backup of your current vim settings in `~/.config/nvim/init.lua` and installs the configs from this project. Therefore, to install manually, you can

- Download and place this manually as well in that location
- Download it elsewhere and create a symlink to this file

# Post Install #

- Open `init.lua` and run `:PackerSync`.

## Arch on WSL fixes ##

- On Arch WSL, you would need to retry by pressing `R` on the `:PackerSync` menu few times to install all the plugins, the first time around. Check [this issue](https://github.com/wbthomason/packer.nvim/issues/456)
- On Arch WSL, you would need to uncomment the clipboard settings present in the `init.lua` for faster startup times.

# Updating #

- Periodically run `git pull`, open `init.lua` and run `:PackerSync`
- TODO: AUR integration

