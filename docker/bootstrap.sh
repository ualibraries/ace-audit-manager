#!/bin/sh
set -x

sleep 10

# Force reload of ace-am
touch "$CATALINA_HOME/webapps/ace-am/WEB-INF/web.xml"
