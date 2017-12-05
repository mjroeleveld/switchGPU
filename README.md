# switchGPU

If your Mac has two graphic cards, switchGPU makes your Mac automatically use the integrated GPU when you login. This is useful for people who want to save on their batteries, but also for people who face issues with their discrete GPU, e.g. a lot of Macbook Pro 2011 owners of who the discrete GPU causes lots of trouble (like crashes, reboots, etc.)

This program is a wrapper for gfxCardStatus, which doesn't have an option to set a default and has an frustrating bug that requires the user to tick a GPU version twice; switchGPU addresses those problems.

Keep in mind that using only the integrated GPU may have some drawbacks. For example, connecting an external monitor might not work anymore afterwards. However, those who have still two working graphic cards can easily switch to the discrete GPU (or dynamic mode) when they need to.

Tested on a late 2011 Macbook with Mavericks, but it should work on most models.

## Installation

Download the zipped Automator file (switchGPU.zip), unzip it and drag it to your programs folder. Go to 'System settings > Users and groups > Log in' and add switchGPU from the programs folder using the plus sign. Tick the box in the dialog and you're good to go: switchGPU will start the next time you login. You can just start the app by yourself, so you won't have to restart your machine.

## How it works

When you login, the automator program will start the integrated switchGPU script that installs gfxCardStatus at its first run. Next, the script will start gfxCardStatus three times consecutively to address the problem of the selection (which GPU) not being preserved immediately.

switchGPU uses a version of gfxCardStatus that accepts the mode you want to start the program in as a command line parameter. In this way, gfxCardStatus can be started in integrated GPU mode.

## Credits

- gfxCardStatus
- MacOH - The switchGPU script is actually a stripped and slightly edited version of the macoh.sh script.
