# == Class: jmeter::params
#
class jmeter::params {
  case $::osfamily {
    'RedHat', 'Debian': {
      $installer_path  = '/opt'
      $bin_path        = '/usr/local/bin'
      $version         = '2.13'
      $plugins_install = true
      $plugins_version = '1.2.1'
      $plugins_set     = ['Standard']
      $server_ip       = '0.0.0.0'
      $server_port     = '1099'
      $user_config     = {}
    }
    default: {
      fail("Class['jmeter::params']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
