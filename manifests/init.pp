# === Class: jpackage6
#
# This module installs the JPackage 6.0 YUM repository and its dependencies on RHEL-variants
#
# == Parameters
#
# $gpgcheck:
#   enable or disable GPG signature check (valid: '0'|'1')
# $enable_free:
#   enable or disable free repository (valid: '0'|'1')
# $enable_devel:
#   enable or disable devel repository (valid: '0'|'1')
# $enable_nonfree:
#   enable or disable non-free repository (valid: '0'|'1')
#
# === Actions
#
# - Install JPackage YUM repository
# - Install YUM plugin 'priorities'
#
# === Requires
#
# (none)
#
# === Sample Usage:
#
# class { '::jpackage':
#   gpgcheck     => '0',
#   enable_devel => '1'
# }
#
class jpackage6 ($gpgcheck = 1, $enable_free = 1, $enable_devel = 0, $enable_nonfree = 0) {
  case $::osfamily {
    'RedHat' : {
      # return variables used for distro specific repositories
      $distro = $::operatingsystem ? {
        'Fedora' => 'fedora',
        default  => 'redhat-el'
      }

      if $::operatingsystem != 'Fedora' and $::operatingsystemmajrelease == '5' {
        $distrover = '5.0'
      } else {
        $distrover = '$releasever'
      }

      # required to use repository priority
      if !defined(Package['yum-plugin-priorities']) {
        package { 'yum-plugin-priorities': ensure => present }
      }

      # install YUM repositories
      yumrepo { 'jpackage-generic-free':
        descr          => 'JPackage 6 free, generic',
        mirrorlist     => 'http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=6.0',
        failovermethod => priority,
        enabled        => $enable_free,
        gpgcheck       => $gpgcheck,
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
        priority       => 10
      }

      yumrepo { 'jpackage-generic-devel':
        descr          => 'JPackage 6 devel, generic',
        mirrorlist     => 'http://www.jpackage.org/mirrorlist.php?dist=generic&type=devel&release=6.0',
        failovermethod => priority,
        enabled        => $enable_devel,
        gpgcheck       => $gpgcheck,
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
        priority       => 10
      }

      yumrepo { 'jpackage-generic-nonfree':
        descr          => 'JPackage 6 non-free, generic',
        mirrorlist     => 'http://www.jpackage.org/mirrorlist.php?dist=generic&type=non-free&release=6.0',
        failovermethod => priority,
        enabled        => $enable_nonfree,
        gpgcheck       => $gpgcheck,
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
        priority       => 10
      }

      if ($::operatingsystem == 'Fedora' and $::operatingsystemmajrelease >= 9 and $::operatingsystemmajrelease <= 17 and
      $::operatingsystemmajrelease != '15') or $::operatingsystemmajrelease == '5' {
        yumrepo { 'jpackage-distro-free':
          descr          => 'JPackage 6 free, distro',
          mirrorlist     => "http://www.jpackage.org/mirrorlist.php?dist=${distro}-${distrover}&type=free&release=6.0",
          failovermethod => priority,
          gpgcheck       => $gpgcheck,
          gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
          enabled        => $enable_free,
          priority       => 10
        }

        yumrepo { 'jpackage-distro-devel':
          descr          => 'JPackage 6 devel, distro',
          mirrorlist     => "http://www.jpackage.org/mirrorlist.php?dist=${distro}-${distrover}&type=devel&release=6.0",
          failovermethod => priority,
          gpgcheck       => $gpgcheck,
          gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
          enabled        => $enable_devel,
          priority       => 10
        }

        yumrepo { 'jpackage-distro-nonfree':
          descr          => 'JPackage 6 non-free, distro',
          mirrorlist     => "http://www.jpackage.org/mirrorlist.php?dist=${distro}-${distrover}&type=non-free&release=6.0",
          failovermethod => priority,
          gpgcheck       => $gpgcheck,
          gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage',
          enabled        => $enable_nonfree,
          priority       => 10
        }
      }

      # install GPG key
      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => "puppet:///modules/${module_name}/RPM-GPG-KEY-jpackage",
      }

      jpackage6::rpm_gpg_key { 'JPackage GPG key': path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-jpackage' }
    }
    default  : {
      fail("Unsupported operating system family ${::osfamily}")
    }
  }
}
