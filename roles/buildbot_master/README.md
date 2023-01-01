Ansible Role: Buildbot Master
=============================

This is a role to install and configure a buildbot master.

Platforms
=========

* RHEL/CentOS 7
* RHEL/CentOS 8

Description
===========

This role is designed to allow the management of the buildbot without root
access, assuming Python3 is already available on the system.

Tasks requiring sudo to install Python3 are run conditionally in order to
support molecule tests.  See the `buildbot_master_have_sudo` and
`buildbot_master_install` variables.

This role will automatically restart the buildbot master after a
configuration change, instead of just reloading the configuration.  This has
been found to be more reliable.
