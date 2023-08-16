install: 
	touch ~/.config/nvim/init.lua
	cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.back
	cp init.lua ~/.config/nvim/.

clean:
	touch ~/.config/nvim/init.lua
	cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.back
	rm -rf ~/.config/nvim/init.lua
