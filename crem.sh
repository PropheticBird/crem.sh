#!/bin/bash

export XAUTHORITY=/home/username/.Xauthority
export DISPLAY=:0.0

# woring arguments status variable
E_WRONG_ARGS=95

# constants which represent valid number of script arguments
HELP_ARG=1
RESOLUTION_ARGS=6

# regex to validate resolution params
RESOLUTION_REG="^[0-9]{3,4}$"

# regex to validate output param
OUTPUT_REG="^[a-zA-Z0-9]{3,5}$"

# POSIX variable
# Reset getops in case it has been previously used
OPTIND=1

function show_usage ()
{
    echo -e "\nusage: $0 [-h] -x screen_width -y screen_height -c output\n"
    echo -e "This script changes the resolution of external monitor.\n"

    echo "   -c   Output port name"
    echo "   -h   Show this message"
    echo "   -x   Screen width"
    echo "   -y   Screen heigt"

    echo -e "\nExample:"
    echo "   $0 -x 1366 -y 768 -c VGA1"
    exit 1
}

function check_input ()
{
    if [[ ! $1 =~ $2 ]]; then
        echo -e "\nOops.. the argument '$1' is not valid. See example."
        show_usage
    fi
}

# check if there has been supplied correct number of arguments
if [ "$#" -ne "$HELP_ARG" -a "$#" -ne "$RESOLUTION_ARGS" ]; then
    echo -e "\nOops.. there is not enough arguments to run script. See example."
    show_usage
fi

# parse command-line arguments
while getopts "h :x: :y: :c:" opt
do
    case $opt in
        h)
            show_usage
            exit 0
            ;;
        x)
            width=$OPTARG
            check_input $width $RESOLUTION_REG
            ;;
        y)
            height=$OPTARG
            check_input $height $RESOLUTION_REG
            ;;
        c)
            output=$OPTARG
            check_input $output $OUTPUT_REG
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit $E_WRONG_ARGS
            ;;
        \?)
            exit $E_WRONG_ARGS
    esac
done

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
xrandr --addmode $output $mode_name
xrandr --output $output --mode $mode_name
exit 0
