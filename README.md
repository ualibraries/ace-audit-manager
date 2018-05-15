# ACE Audit Manager docker

- [Introduction](#introduction)
- [Dependencies](#dependencies)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)

## Introduction

[Ace Audit Manager](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Main) (ace-am) runs [fixity](https://www.dpconline.org/handbook/technical-solutions-and-tools/fixity-and-checksums) checks on archival storage. It is designed to integrate with the [Ace Integrity Management Service](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Ace_IMS_System) (ace-ims), which taken together form an ACE [Auditing Control Environment](https://wiki.umiacs.umd.edu/adapt/index.php/Ace)

This docker image is part of a set provided by the [University of Arizona Libraries](https://github.com/ualibraries) to implement open fixity solutions based on [Ace Audit Manager](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Main):

* [ace-dbstore-mysql](https://github.com/ualibraries/ace-dbstore-mysql) - provides a mysql instance that will auto-create a dynamic number of ace-audit-manager databases and one ace-integrity-manager database.
* [ace-integrity-management](https://github.com/ualibraries/ace-integrity-management) - provides the [Ace Integrity Management Service](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Ace_IMS_System) service, running within the [glassfish](https://en.wikipedia.org/wiki/GlassFish) based [Payara](https://www.payara.fish/) J2EE application container.
* [ace-audit-manager](https://github.com/ualibraries/ace-audit-manager) - provides the [Ace Audit Manager Service](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Audit_Manager_Installation_Guide) fixity calculation and verification service, running within a [tomcat 8.5](http://tomcat.apache.org/) web servlet container.

## Dependencies
### Host system dependencies
1. [docker-compose](https://docs.docker.com/compose/overview/) is installed on the system.
2. The host system's time synchronized with a master [ntp](https://en.wikipedia.org/wiki/Network_Time_Protocol) server.
3. No other service on the system is listening at port 8080.
4. Archival storage directories located or mounted under /mnt

### External dependencies

1. An [mysql variant database](https://en.wikipedia.org/wiki/MySQL#Current) server to persist checksum values and runtime data. Connection to the database is controlled through docker [environment variables](#environment-variables). Note mysql is not a pre-requisite of ace-am, but of this docker image which has the mysql jdbc driver pre-installed.
2. An [smtp](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) server to send emails. The smtp server settings are set by clicking on the "System Settings" top right link after ace-am is up and running.
3. An [ace integrity management system](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Ace_IMS_System) to send audit tokens. The public default of ims.umiacs.umd.edu:8080 will be used if an over-ride is not specified in the "System Settings" ace-am configuration page.

## Environment Variables

The following environment variables control the docker setup:

* ACE_AUDIT_SHARES - host directory containing archival content to mount into ace-am docker container which it can be setup to audit. Defaults to /mnt
* ACE_AM_DATABASE - the database name to connect to on the database system, defaults to 'aceamdb'.
* ACE_AMDB_HOST - the database system hostname to connect to, defaults to 'db-host'
* ACE_AMDB_PORT - the database system port to connect to, defaults '3306'
* ACE_AMDBA_USER - the database user account to connect with, defaults to 'aceam'
* ACE_AMDBA_PASSWORD - the database user password to connect with, defaults to 'ace'.
* ACE_AM_BOOTSTRAP_SLEEP - on the first time startup of the container, the number of seconds to wait for a docker database container to complete bootstrapping, defaults to 45 seconds. When an external database is being used, this variable can be set to 0.

## Deployment

A docker-compose example using a mysql docker container is located at [compose/fixity-db](https://github.com/ualibraries/ace-audit-manager/tree/master/compose/fixity-db).

To test out ACE Audit Manager, run the following commands:

```
	
	git clone https://github.com/ualibraries/ace-audit-manager.git
	cd ace-audit-manager/compose/fixity-db
	docker-compose up -d
	
```

Then browse to [http://localhost:8080/ace-am](http://localhost:8080/ace-am)

After getting it up and running, follow the [3. Register your first collection](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Audit_Manager_Installation_Guide) instructions. The docker image mounts /mnt from the host into to docker container, so any shares that have been mounted underneath this will be available to create a collection with for fixity auditing.

To cleanup the above test instance, run:

```
	
	git clone https://github.com/ualibraries/ace-audit-manager.git
	cd ace-audit-manager/compose/fixity
	docker-compose rm -fsv
	docker volume prune  # Enter y
	
```

Two docker containers will be created, validate by running **docker ps -a**

* fixitydb_audit_1 - contains ace audit manager running under tomcat
* fixitydb_db-host_1 - contains a mysql database used by ace audit manager.

