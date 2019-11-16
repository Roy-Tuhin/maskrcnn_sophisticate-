#! /bin/bash
# error: only source 
#*TAG:25875 5:Feb 3 1973:0644:busycursor: 
# Author: Brian Hiles <b...@iname.com> 
# Copyright: (c) 1998-2001 
# Date: 1996/09 
# Description: implement an animated "busy" cursor 
# Name: busyprompt 
# Project: @(#)busycursor.sh 1.0 1996/09 b...@iname.com (Brian Hiles) 
# Thanks-to: Peter Turnbull <pet...@deet.gov.au> 
# Usage: busycursor [-number] [prompt] 
# Version: 1.00 


#01 CALIBRATE 
typeset -i _inst=0 
typeset -ix calibration 
((!calibration)) && calibration=$( 
# 5000 is 1st approx of iterations sufficient to give a meaningful delay 
        IFS='ms 
'                                               # <= newline 
        set -- $( 
                {       time {  typeset -i _inst 
                                while (((_inst+=1)<=5000)) 
                                do      : 
                                done 2>&1 
                        } 
                } 2>&1 
        ) 
        # 0.25 below is to mean a target of 4 "frames" per second 
        awk "BEGIN { print 0.25/$2*5000 }" /dev/null 
) 


#02 
function _delayloop # [iterations] 
{       set -o noglob 
        typeset -i iter guess=${1:-5000} 
        while (((iter+=1)<=guess)) 
        do      : 
        done 



} 


#03 SELECT CURSOR, LOOP FOREVER 
function busycursor # [-number] [string] 
{       set -o noglob 
        typeset -i _1=-1 _2 _3 
        typeset IFS anim cursnum 
        trap 'tput cnorm' EXIT 
        trap done=1 TERM 
        tput civis 
        [[ $1 = -+([0-9]) ]] && cursnum=${1#-} shift 
        (($#)) && print -nr "$@" 
        # make cursor animation array: if anim array already exists, use it, 
        # else if CURSORS array exists, load nth one (random if not specified), 
        # else use a default. 
        if ((${#anim[@]})) 
        then    : 
        elif ((${#CURSORS[@]}>${cursnum:-0})) 
        then    IFS=' 
"'         # cursor animation frames are double-quote or newline delimited 
                set -A anim -- ${CURSORS[${cursnum:-RANDOM%(${#CURSORS[@]}-1)}]} 
        else    set -A anim \| / - \\   # default busy cursor 
        fi 
        while ((!${done:-0})) 
        do      print -nru3 -- "${anim[_3=(_1+=1)%${#anim[@]}]}" 
                _delayloop $calibration 
                _2=0 
                while (((_2+=1)<=${#anim[$_3]})) 
                do      print -nu3 \\b 
                done 
        done 3>&1 


} 


#04 CURSOR DATABASE 
# Sample cursors to choose; "frames" are double-quote or newline delimited 
# (bsh: the first seven are mine) 
[[ -z $CURSORS ]] && set -A CURSORS \ 
'|"/"-"\' \ 
'8//=\\_;"8//=/\_;' \ 
'||||||"//////"------"\\\\\\' \ 
'>--->---"->--->--"-->--->-"--->--->' \ 
'-"=">")"|"("<"=' \ 
' .oOo. ". .oOo."o. .oOo"Oo. .oO"oOo. .o".oOo. .' \ 
'10% "20% "30% "40% "50% "60% "70% "80% "90% ' \ 
'|   " |  "  | "   |"  | " |  ' \ 
'_   " _  "  _ "   _"   -"  - " -  "-   ' \ 
'_   " _  "  _ "   _"   |"   -"  - " -  "-   "|   ' \ 
'o___"_o__"__o_"___o"___O"__O_"_O__"O___' \ 
'O_O"o_o"_o_"_O_' \ 
'>    "<    " >   " <   "  >  "  <  "   > "   < "    >"    <' \ 
'>    "->   "-->  "---> "---->"    <"   <-"  <--" <---"<----' \ 
'>><<"<<>>"><><' \ 
'<><>"><><' \ 
' o o" O O"o o "O O ' \ 
'oooo"OOOO"    "oooO"ooOo"oOoo"Oooo' \ 
'^_^"_^_"^-^"-^-' \ 
'-_-"_-_' \ 
'(_)"[-]"{+}' \ 
'^*^"*^*' \ 
'----">---"->--"-->-"--->"*^&%' \ 
'>---"->--"-->-"--->"---<"--<-"-<--"<---' \ 
'()")(' \ 
'()")("))"((' \ 
' - " = " _ "  -"  ="  _"-  "=  "_  ' \ 
'<->">-<' \ 
'|___|"|---|"|   |' \ 
'|___|"|^__|"|_^_|"|__^|"|--^|"|-^-|"|^--|"|---|' \ 
' o o"o o ' \ 
'_o_o"o_o_"_oo_"o__o' \ 
'o   " o  "  o "   o"  o " o  ' \ 
'<()>"<)(>">()<">)(<' \ 
'oo  " oo "  oo" o o"o  o" oo ' \ 
'o    "  o  "    o"   o " o   "  o  "   o "    o' \ 
'  o  " o   "   o "o    "    o' \ 
'(-)")-("(_)")_(' \ 
'!!!"___"   "+++' \ 
'0"1"2"3"4"5"6"7"8"9' \ 
'    ",   " ,  "  , "   ,"  ,," ,,,",,,,' \ 
'@-@"@_@"@+@"+@+"_@_"-@-' \ 
'   o"o   " oo " ooo"oooo"o  o' \ 
'/_/"\_\"/_\"\_/' \ 
'<=>  ">=<  " <=> " >=< "  <=>"  >=<' \ 
'*-*" _ " ^ " ~ "+|+' \ 
'*&&*"&**&' \ 
'_-_-"-_-_"-__-"-___"____"___-"__--"_---"----' \ 
'(  )"(oo)") o("(o )")oo(' \ 
'__--"--__"-__-"_--_' \ 
'___-"___="__-="__=="_-=="_==="-==="====' \ 
'_|_"|__"__|"___' \ 
'<_|_>"<- ->">-+-<">_^_<' \ 
'--__"__--' \ 
'HELP" ME " GET"OUT!' \ 
'SIT  "BACK "AND  "ENJOY' \ 
'REALLY"IT    "IS    "A     "BIT   "SILLY "TO    "WATCH "THIS! ' \ 
'A"B"C"D"E"F"G"H"I"J"K"L"M"N"O"P"Q"R"S"T"U"V"W"X"Y"Z' \ 
'/-\"/_\"\_/"\-/' 

#05 EMBEDDED MANPAGE FOR "src2man" 
: ' 
#++ 
NAME 
        busycursor - show an animated "busy" cursor 


SYNOPSIS 
        busycursor [-number] [prompt] 


DESCRIPTION 
        Show an animated "busy" cursor indication of a concurently running 
        program. 


OPTIONS 
        -<number> - Use cursor number <number> from the CURSORS database. 


RETURN CODE 


EXAMPLE 
        set +o bgnice                   # interactive priority for cursor 
        trap : HUP INT QUIT TERM        # signals get passed off to busy prompt 
        busycursor -0 please wait... &      # note: always invoked in background 
        sleep 5                         # ... the "busy" code goes here ... 
        print " done."                        # this supplies the necessary newline 
        kill $! 3>&-                     # terminate busy prompt; flush output 
        trap - HUP INT QUIT TERM        # reset signal handlers to default 
        set -o bgnice                   # reset priority of bg processes 


ENVIRONMENT 
        CURSORS         - Database of available cursors. 


SEE ALSO 
        eread(3S) 


BUGS 
