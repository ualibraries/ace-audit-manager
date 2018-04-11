# ACE Audit Manager docker

- [Introduction](#introduction)
- [Dependencies](#dependencies)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)

## Introduction

[Ace Audit Manager](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Main) runs [fixity](https://www.dpconline.org/handbook/technical-solutions-and-tools/fixity-and-checksums) checks on archival storage. It is designed to integrate with the [Ace Integrity Management Service](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Ace_IMS_System)(IMS), which taken together form an ACE [Auditing Control Environment](https://wiki.umiacs.umd.edu/adapt/index.php/Ace)

## Dependencies
### Host system dependencies
1. [docker-compose](https://docs.docker.com/compose/overview/) is installed on the system.
2. The host system's time synchronized with a master [ntp](https://en.wikipedia.org/wiki/Network_Time_Protocol) server.
3. No other service on the system is listening at port 8080.
4. Archival storage directories located or mounted under /mnt

### External dependencies

1. An [smtp](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) server to send emails. For the examples located in the [compose/](https://github.com/ualibraries/archivematica/tree/1.6.1-beta3/compose) directory, they use a gmail test account. For a production deployment an organization's smtp server should be used.

## Environment Variables

The following environment variables control the docker setup:

* ACE_AUDIT_SHARES - host directory containing archival content to mount into the docker container so ACE audit manager can audit it. Defaults to /mnt
* ACE_AUDIT_DBSTORE - host directory where persistant mysql dbstore files should go. Defaults to creating a temporary docker volume

## Deployment

A [docker-compose](https://github.com/ualibraries/ace-audit-manager/blob/master/compose/fixity/docker-compose.yml) example using mysql is located within the [compose/fixity](https://github.com/ualibraries/ace-audit-manager/tree/master/compose/fixity) subdirectory.

To test out ACE Audit Manager, run the following commands:

```
	
	git clone https://github.com/ualibraries/ace-audit-manager.git
	cd ace-audit-manager/compose/fixity
	docker-compose up -d
	sleep 60 # wait one minute for database creation to complete
	docker-compose stop
	docker-compose up -d
	
```

Then browse to [http://localhost:8080/ace-am](http://localhost:8080/ace-am)

After getting it up and running, follow the instructions at [3. Register your first collection](https://wiki.umiacs.umd.edu/adapt/index.php/Ace:Audit_Manager_Installation_Guide). The docker image mounts /mnt from the host into to docker container, so any shares that have been mounted underneath this will be visible to begin fixity auditing on.

To cleanup the above test instance, run:

```
	
	git clone https://github.com/ualibraries/ace-audit-manager.git
	cd ace-audit-manager/compose/fixity
	docker-compose rm -fsv
	docker volume prune  # Enter y
	
```

Two docker containers will be created, validate by running **docker ps -a**

* fixity_audit_1 - contains ace audit manager running under tomcat
* fixity_db-host_1 - contains mysql database used by ace audit manager.

