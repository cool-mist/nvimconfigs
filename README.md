# Nvimconfigs #

My neovim settings. Contrary to popular opinion of breaking down your configs, this configuration is a single file because why not!! It is very difficult to split them anyways with plugin dependencies on other plugins, plugins defining keybinds in their setup and so on.

This uses Lazy as the plugin manager.

# Prerequisites #

- Tested on Arch and Windows native. Should probably work on both linux and windows.
- `neovim`
- `npm`
- `python`
- `python-pynvim`
- `pip`
- `go`
- `rust`
- `ripgrep` - for fuzzy searching

# Installation #

- `make install` if on linux.
- Otherwise, follow the manual process below

## Manually ##

Above command will take a backup of your current vim settings in `~/.config/nvim/init.lua` and installs the configs from this project. Therefore, to install manually, you can

- Download and place this manually in that location. On windows, it is `$env:LocalAppData\nvim\init.lua`. On Linux, it is `~/.config/nvim/init.lua`.

# Post Install #

- Open `init.lua`. Lazy will take care of installing everything that is required. You might need to manually install the netcoredbg for debugging C#. Check the comments in the init.lua for more guidance.

# Updating #

- Periodically run `git pull`, open `init.lua`, run `:Lazy` and `<Shift> + s` to update the plugins.

