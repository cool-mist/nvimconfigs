# Nvimconfigs #

My neovim settings. Contrary to popular opinion of breaking down your configs, this configuration is a single file because why not!! It is becoming very difficult to split them anyways with plugin dependencies on other settings, plugins defining keybinds in their setup and so on.

This uses Packer as the plugin manager.

# Prerequisites #

- Tested on Arch. Should probably work on most linux distros.
- `neovim`
- `npm`
- `python`
- `python-pynvim`
- `pip`
- `go`
- `rust`

# Installation #

- `make install`

## Manually ##

Above command will take a backup of your current vim settings in `~/.config/nvim/init.lua` and installs the configs from this project. You can download and place this manually as well.

# Post Install #

- Open `init.lua` and run `:PackerSync`.
- On Arch WSL, you would need to retry by pressing `R` on the `:PackerSync` menu few times to install all the plugins, the first time around. Check [this issue](https://github.com/wbthomason/packer.nvim/issues/456)

