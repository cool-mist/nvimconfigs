# nvimconfigs

My neovim settings. Contrary to popular opinion of breaking down your configs, this configuration is a single file because why not!! It is becoming very difficult to split them anyways with plugin dependencies on other settings, plugins defining keybinds in their setup and so on.

This uses Packer as the plugin manager.

# Dependencies #

- neovim
- npm
- python
- python-pynvim
- pip
- go
- rust


# Installation #

Tested on Arch. Should probably work on most linux distros.

On Arch WSL, you would need to retry by pressing `R` on the `:PackerSync` menu few times to install all the plugins, the first time around. Check [this issue](https://github.com/wbthomason/packer.nvim/issues/456)

```
make install
```

That will take a backup of your current vim settings in `~/.config/nvim/init.lua` and installs the configs from this project.

Once done, open `init.lua` and run `:PackerSync`.

