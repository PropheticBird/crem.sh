#!/bin/bash

export XAUTHORITY=/home/username/.Xauthority
export DISPLAY=:0.0

NO_ARGS=0

E_WRONG_ARGS=95

# POSIX variable
# Reset getops in case it has been previously used
OPTIND=1

function show_usage ()
{
    echo -e "usage: $0 [-h] -x screen_width -y screen_height -c output\n"
    echo -e "This script changes the resolution of external monitor.\n"

    echo "   -c   Output port name"
    echo "   -h   Show this message"
    echo "   -x   Screen width"
    echo "   -y   Screen heigt"
    echo "   -v   Verbose"

    echo -e "\nExample:"
    echo "   $0 -x 1366 -y 768 -c VGA1"
    exit 1
}


# parse command-line arguments
while getopts "h?x:y:c:" opt; do
    case $opt in
        h|\?)
            show_usage
            exit 0
            ;;
        x)
            width=$OPTARG
            ;;
        y)
            height=$OPTARG
            ;;
        c)
            connection_type=$OPTARG
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit $E_WRONG_ARGS=95
            ;;
    esac
done

# check if there has been supplied enough arguments
if [ "$#" -eq "$NO_ARGS" ]; then
    show_usage
fi

shift $(($OPTIND - 1))

# calculate VESA CVT modeline, more details can be found at:
# http://en.wikipedia.org/wiki/XFree86_Modeline
cvt_output=`cvt $width $height`

# parse the cvt output to extract the label of the resolution
mode_name=`echo $cvt_output | cut -d'"' -f 2`

# parse the output of cvt and extract clk, x- and x- resolutions
# the following code extracts substuing from the input string strating
# from the last matched double quote
mode_params=${cvt_output##*'"'}

# call xrandr to add and apply the new resolution
xrandr --newmode $mode_name$mode_params
xrandr --addmode $connection_type $mode_name
xrandr --output $connection_type --mode $mode_name
exit 0
