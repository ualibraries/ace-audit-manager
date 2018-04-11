FROM tomcat:8.5-jre8

ENV ACE_AUDIT_MANAGER_V=1.12 ACE_AUDIT_TAR=ace-am-1.12-RELEASE MYSQL_JCONNECT_V=5.1.46 MYSQL_JCONNECT=mysql-connector-java-5.1.46

RUN \
cd /opt && \
curl -kL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JCONNECT_V.tar.gz | tar xz && \
cp $MYSQL_JCONNECT/$MYSQL_JCONNECT-bin.jar /usr/local/tomcat/lib && \
curl -kL https://obj.umiacs.umd.edu/ace/releases/$ACE_AUDIT_MANAGER_V/ace-dist-$ACE_AUDIT_MANAGER_V-RELEASE-bin.tar.gz | tar xz && \
cp $ACE_AUDIT_TAR/ace-am.war /usr/local/tomcat/webapps/ && \
mkdir -p /usr/local/tomcat/conf/Catalina/localhost && \
cp $ACE_AUDIT_TAR/ace-am.xml /usr/local/tomcat/conf/Catalina/localhost && \
mkdir /opt/initdb.d && \
cp $ACE_AUDIT_TAR/ace-am.sql /opt/initdb.d && \
sed -i -e "s|YOUR_PASSWORD|ace-audit-5231@&|g" /usr/local/tomcat/conf/Catalina/localhost/ace-am.xml && \
sed -i -e "s|localhost/aceam|db-host:3306/aceamdb|g" /usr/local/tomcat/conf/Catalina/localhost/ace-am.xml && \
sed -i -e "s|YOUR_PASSWORD|ace-audit-5231@&|g" /opt/initdb.d/ace-am.sql && \
sed -i -e "s|MyISAM|InnoDB|g" /opt/initdb.d/ace-am.sql

VOLUME ["/opt/initdb.d"]
