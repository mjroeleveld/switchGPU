#switchGPU
If your Mac has two graphic cards, switchGPU makes your Mac automatically use the integrated GPU when you login. This is useful for people who want to save energy, but also for people who face issues with their discrete GPU, e.g. a lot of Macbook Pro 2011 owners from who the discrete GPU causes lots of trouble (like crashes, reboots, etc.)
This program is just a wrapper for gfxCardStatus, but the latter doesn't have an option to set a default and it has an frustrating bug that requires the user to tick a GPU version twice; switchGPU addresses those problems.

##Installation
Download the Automator file and drag it to your programs folder. Go to 'System settings > Users and groups > Log in' and add switchGPU from the programs folder with the plus sign. Tick the box in the dialog and you're good to go: switchGPU will start the next time you login.

##How it works
When you login, the automator program will start the integrated switchGPU script that installs gfxCardStatus at first usage. Next, the script will start gfxCardStatus three times consecutively to address the problem of the selection (which GPU) not being preserved immediately.

##Credits
[gfxCardStatus][1]

[MacOH][2] - The switchGPU script is actually a stripped and slightly edited version of the macoh.sh script.


  [1]: http://gfx.io/
  [2]: https://github.com/qnxor/macoh
