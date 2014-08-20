## Crem.sh

Crem.sh is a simple bash script that allows to add a custom resolution for an
unknwon external monitor and apply it immediately.

### Why might someone need this?

My laptop with Ubuntu at first and Debian after, can't detect the max resolution
of an external monitor. So, I found a [solution][solution] of this problem, but quicky get tired
of retyping the sequence of `cvt` + `xrandr` commands every time I need to connect to a
new monitor. So, I wrote this script and decided to publish it here, as I saw on the Web,
I'm not the only one having this problem. Crem.sh was tested on three external monitors and did
its job good.

This is my first experience with Bash, so please, don't be too strict with me ;)


### Usage

Using crem is very simple, just provide desired resolution and specify the output device.

```
usage: /usr/bin/crem [-h] -x screen_width -y screen_height -c output

This script changes the resolution of external monitor.

   -c   Output port name
   -h   Show this message
   -x   Screen width
   -y   Screen heigt

Example:
   /usr/bin/crem -x 1366 -y 768 -c VGA1
```

### Intallation

If you like it, download it from here. To make the script runnable globally
move it to `/usr/bin` or `/usr/local/bin`.


### Links

~ [Source code](https://github.com/PropheticBird/crem.sh.git)

[solution]: http://askubuntu.com/questions/138408/how-to-add-display-resolution-fo-an-lcd-in-ubuntu-12-04-xrandr-problem



