# Nvimconfigs #

My neovim settings. Contrary to popular opinion of breaking down your configs, this configuration is a single file because why not!! It is becoming very difficult to split them anyways with plugin dependencies on other settings, plugins defining keybinds in their setup and so on.

This uses Lazy as the plugin manager.

# Prerequisites #

- Tested on Arch and Windows native. Should probably work on most linux distros.
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

- `make install` if on linux.

## Manually ##

Above command will take a backup of your current vim settings in `~/.config/nvim/init.lua` and installs the configs from this project. Therefore, to install manually, you can

- Download and place this manually as well in that location
- Download it elsewhere and create a symlink to this file

# Post Install #

- Open `init.lua`. Lazy will take care of installing everything that is required. You might need to manually install the netcoredbg for debugging C#. Check the comments in the init.lua for more guidance.

# Updating #

- Periodically run `git pull`, open `init.lua`, run `:Lazy` and `<Shift> + s` to update the plugins.

