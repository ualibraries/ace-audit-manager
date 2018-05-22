#!/bin/sh
set -x

SED_DB_DATABASE=${DB_DATABASE:-aceamdb} 
SED_DB_HOST=${DB_HOST:-db-host}
SED_DB_PORT=${DB_PORT:-3306} 
SED_DB_USER=${DB_USER:-aceam}
SED_DB_PASSWORD=${DB_PASSWORD:-ace}
SED_SMTP_HOST=${SMTP_HOST:-smtp.gmail.com:587}
SED_SMTP_TLS=${SMTP_TLS:-true}
SED_SMTP_USER=${SMTP_USER:-dockertestfilesender}
SED_SMTP_FROM=${SMTP_FROM:-dockertestfilesender@gmail.com}
SED_SMTP_PSWD=${SMTP_PASSWORD:-thisisalongpassword}

cat /opt/$ACE_AUDIT_TAR/ace-am.xml | \
sed -e "s|localhost/aceam|$SED_DB_HOST:$SED_DB_PORT/$SED_DB_DATABASE|g" \
    -e "s|username=\"aceam\"|username=\"$SED_DB_USER\"|g" \
    -e "s|password=\"ace\"|password=\"$SED_DB_PASSWORD\"|g" \
> ${CATALINA_HOME}/conf/Catalina/localhost/ace-am.xml

if [ "xx${BOOTSTRAP_SLEEP}" != "xx" ]; then
  sleep $BOOTSTRAP_SLEEP
fi

mkdir -p "$CATALINA_HOME/webapps/ace-am"
cd "$CATALINA_HOME/webapps/ace-am"
unzip /opt/$ACE_AUDIT_TAR/ace-am.war

/opt/ace-am/bootstrap.sh &
