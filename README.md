#jpackage6

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Credits](#credits)

##Overview

The jpackage6 module installs the JPackage 6.0 YUM repository and its dependencies on all [RHEL variants](http://en.wikipedia.org/wiki/List_of_Linux_distributions#RHEL-based) including Fedora.

##Module description

[JPackage](http://www.jpackage.org/) is a project which goal is to provide a set of Java software on Linux platforms. Its repositories can be used to get access to Java related packages not available in the official repositories of most Linux distributions. This module only focuses on systems which use the YUM package manager, ie. RHEL variants.

The following repositories will be enabled by default:

* jpackage-generic-free
* jpackage-distro-free (depending on the distribution)

One can also enable these extra repositories:

* jpackage-generic-devel
* jpackage-distro-devel (depending on the distribution)
* jpackage-generic-nonfree
* jpackage-distro-nonfree (depending on the distribution)

##Setup

jpackage6 will affect the following parts of your system:

* JPackage 6 YUM repositories
* JPackage 6 GPG key

Including the main class is enough to get started. It will install the JPackage 6 free repositories as described above.

```puppet
include ::jpackage6
```

####A couple of examples

Also enable the 'devel' and 'non-free' repositories

```puppet
class { '::jpackage6':
  enable_devel   => 1,
  enable_nonfree => 1
}
```

Disable the GPG signature check

```puppet
class { '::jpackage6':
  …
  gpgcheck => 0
}
```

##Usage

####Class: `jpackage6`

Primary class and entry point of the module.

**Parameters within `jpackage6`:**

#####`gpgcheck`

Switch to perform or not GPG signature checks on repository packages. Defaults to '1'

Note: some packages in the JPackage repositories are unfortunately unsigned, set to '0' if you run any kind of unattended package installation on the system.

#####`enable_free`

Enable 'free' repositories (both generic and distro-specific if relevant). Defaults to '1'

#####`enable_devel`

Enable 'devel' repositories (both generic and distro-specific if relevant). Defaults to '0'

#####`enable_nonfree`

Enable 'non-free' repositories (both generic and distro-specific if relevant). Defaults to '0'

##Credits

The `rpm_gpg_key` defined type was reused from the ['epel' module by Michael Stahnke](https://forge.puppetlabs.com/stahnma/epel) (stahnma).

Features request and contributions are always welcome!