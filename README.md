# Srunner
A tiny lil' side project I'm working on that focuses on bringing a handy Steam games library to the Terminal!
It's effectively a TUI based Steam library ~

## Current Usage
As of the current usage, this is not compiled into some fancy .sh file, a package on the AUR or any shit like that, it's simply a bundle of LUA files that *should* work fine!

Obviously, to run this, you probably need *at least* lua 5.3.5, but I have no clue if it works in previous versions!

Usage *should* be as simple as (inside the directory where main.lua is stored):
`lua main.lua`
which should explain the basic functionality fairly well ^

Then, if you know the ID, or have taken a peak inside the `library.json` file, which should hold all the IDs and Names of currently installed apps, then you can run:
`lua main.lua -r -id <app ID>`
which should run the app relative to the ID provided, as provided by the example that is given when you run `lua main.lua` without any arguments!

### Side Notes
In the future, there's a possibility I might fork certain functionality of this program and create more projects out of it!
This would most likely include the basic graphics library/engine/idk wtf to call this, that I use to draw basic ascii boxes out of provided characters

Also, I have a little module, that I made, that outputs all app names, **with their IDs**, that you have installed, to a handy JSON file, which might also be a neat little fork in the future for anyone interested!

***No more shitty and unintuitive UIs made purely in CSS***
