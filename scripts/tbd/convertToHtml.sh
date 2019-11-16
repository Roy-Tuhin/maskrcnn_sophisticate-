#!/bin/bash

# make_page - A script to produce an HTML file

cat <<- _EOF_
    <HTML>
    <HEAD>
        <TITLE>
        The title of your page. ECHO Command is not used!!!
        </TITLE>
    </HEAD>

    <BODY>
        Your page content goes here.
    </BODY>
    </HTML>
_EOF_


echo "<HTML>"
echo "<HEAD>"
echo "  <TITLE>"
echo "  The title of your page: ECHO command is used!!"
echo "  </TITLE>"
echo "</HEAD>"
echo ""
echo "<BODY>"
echo "  Your page content goes here."
echo "</BODY>"
echo "</HTML>"

