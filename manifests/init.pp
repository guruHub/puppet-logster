# Class: logster
#
# This module manages logster
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class logster(
  $build_dir='/usr/local/src'
) {

  case $::operatingsystem {
    'Debian' : {
      package { 'build-essential' :
        ensure => present
      }
      exec { "Download and uncompress logster" :
        command => "wget -O - https://github.com/etsy/logster/tarball/4f134128cdc410322b30e759bb0a74e66898cfb5 | tar xz ",
        creates => "${build_dir}/etsy-logster-4f13412",
        cwd     => "$build_dir"
      }
      exec { "Install logster":
        command     => "make install",
        path        => '/usr/bin',
        cwd         => "${build_dir}/etsy-logster-4f13412",
        subscribe   => Exec['Download and uncompress logster'],
        logoutput   => on_failure,
        refreshonly => true,
        require     => [ Exec['Download and uncompress logster'], Package['build-essential'] ]
      }
    }
    default : {
      package {
        'logster':
         ensure => present,
      }
    }
  }

  package {
    'logcheck':
      ensure => present,
  }

}
