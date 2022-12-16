#!/bin/bash
# this script exists because running 'checkupdates' in
# polybar directly will fail when ran on multiple monitors
# with the same interval.
# !!!
# you need 'pacman-contrib'
# !!!

cd ~/.config/polybar/

{ # try
	checkupdates | wc -l >> updates_list.txt;
	tail -1 updates_list.txt;
} || { # catch
	tail -1 updates_list.txt;
}

