#!/bin/bash

BLUE="\[\033[0;34m\]"
DARK_BLUE="\[\033[1;34m\]"
RED="\[\033[0;31m\]"
DARK_RED="\[\033[1;31m\]"
NO_COLOR="\[\033[0m\]"

cat <<EOF
REFERECE:
http://www.thegeekstuff.com/2008/09/bash-shell-ps1-10-examples-to-make-your-linux-prompt-like-angelina-jolie/

ForeGround Colouring:
\$? - Status of the last command 
\e[ - Indicates the beginning of color prompt 
x;ym - Indicates color code. Use the color code values mentioned below. 
\e[m - indicates the end of color prompt 

Black 0;30
Blue 0;34
Green 0;32
Cyan 0;36
Red 0;31
Purple 0;35
Brown 0;33
[Note: Replace 0 with 1 for dark color]


Background Colours:
\e[40m 
\e[41m 
\e[42m 
\e[43m 
\e[44m 
\e[45m 
\e[46m 
\e[47m 

tput Color Capabilities:

tput setab [1-7] - Set a background color using ANSI escape 
tput setb [1-7] - Set a background color 
tput setaf [1-7] - Set a foreground color using ANSI escape 
tput setf [1-7] - Set a foreground color 
tput Text Mode Capabilities:

tput bold - Set bold mode 
tput dim - turn on half-bright mode 
tput smul - begin underline mode 
tput rmul - exit underline mode 
tput rev - Turn on reverse mode 
tput smso - Enter standout mode (bold on rxvt) 
tput rmso - Exit standout mode 
tput sgr0 - Turn off all attributes 
Color Code for tput:


0 - Black 
1 - Red 
2 - Green 
3 - Yellow 
4 - Blue 
5 - Magenta 
6 - Cyan 
7 - White 

Create your own prompt using the available codes for PS1 variable
Use the following codes and create your own personal PS1 Linux prompt that is functional and suites your taste. Which code from this list will be very helpful for daily use? Leave your comment and let me know what PS1 code you've used for your Linux prompt.

\a an ASCII bell character (07) 
\d the date in "Weekday Month Date" format (e.g., "Tue May 26") 
\D{format} - the format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required 
\e an ASCII escape character (033) 
\h the hostname up to the first part 
\H the hostname 
\j the number of jobs currently managed by the shell 
\l the basename of the shell's terminal device name 
\n newline 
\r carriage return 
\s the name of the shell, the basename of $0 (the portion following the final slash) 
\t the current time in 24-hour HH:MM:SS format 
\T the current time in 12-hour HH:MM:SS format 
\@ the current time in 12-hour am/pm format 
\A the current time in 24-hour HH:MM format 
\u the username of the current user 
\v the version of bash (e.g., 2.00) 
\V the release of bash, version + patch level (e.g., 2.00.0) 
\w the current working directory, with $HOME abbreviated with a tilde 
\W the basename of the current working directory, with $HOME abbreviated with a tilde 
\! the history number of this command 
\# the command number of this command 
\$ if the effective UID is 0, a #, otherwise a $ 
\nnn the character corresponding to the octal number nnn 
\\ a backslash 
\[ begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt 
\] end a sequence of non-printing character 

EOF
