
if [ -z "$1" ]; then
	echo "Please input a class name"	
	exit 1
fi

AUTHOR="Drinking"
DATE=`date +%d/%m/%Y`
YEAR=`date +%Y`

./sourcery --args name="$1",author="$AUTHOR",date="$DATE",year="$YEAR" --sources ./Model.swift --templates ./ViewController_m.stencil --output ./$1ViewController_m.temp
./sourcery --args name="$1",author="$AUTHOR",date="$DATE",year="$YEAR" --sources ./Model.swift --templates ./ViewController_h.stencil --output ./$1ViewController_h.temp
tail -n +5 ./$1ViewController_m.temp > ./$1ViewController.m
tail -n +5 ./$1ViewController_h.temp > ./$1ViewController.h
rm ./$1ViewController_m.temp
rm ./$1ViewController_h.temp