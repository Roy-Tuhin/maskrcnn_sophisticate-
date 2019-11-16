#! /bin/bash

## Modified the script based on provided by NGRhodes @ askubuntu:
# https://askubuntu.com/questions/545881/list-all-the-ppa-repositories-added-to-my-system

OUTFILE="addppa.util.sh"
OUTFILE2="removeppa.util.sh"
#touch "$OUTFILE"
echo -e "#!/bin/bash\n" > "$OUTFILE"
echo -e "#!/bin/bash\n" > "$OUTFILE2"
# listppa Script to get all the PPA installed on a system ready to share for reininstall
for APT in `find /etc/apt/ -name \*.list`; do
    grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" $APT | while read ENTRY ; do
        USER=`echo $ENTRY | cut -d/ -f4`
        PPA=`echo $ENTRY | cut -d/ -f5`
        echo "#$USER/$PPA" >> "$OUTFILE"
        echo "#$USER/$PPA" >> "$OUTFILE2"
        echo sudo -E apt-add-repository ppa:$USER/$PPA >> "$OUTFILE"
        echo sudo -E apt-add-repository --remove ppa:$USER/$PPA >> "$OUTFILE2"
    done
done

chmod +x "$OUTFILE"
chmod +x "$OUTFILE2"
