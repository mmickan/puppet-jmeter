# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter (
  $installer_path  = $::jmeter::params::installer_path,
  $bin_path        = $::jmeter::params::bin_path,
  $version         = $::jmeter::params::version,
  $plugins_install = $::jmeter::params::plugins_install,
  $plugins_version = $::jmeter::params::plugins_version,
  $plugins_set     = $::jmeter::params::plugins_set,
  $user_config     = $::jmeter::params::user_config,
) inherits jmeter::params {

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  ensure_packages(['unzip', 'wget'])

  exec { 'download-jmeter':
    command => "wget -P /tmp http://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${version}.tgz",
    creates => "/tmp/apache-jmeter-${version}.tgz"
  }

  exec { 'install-jmeter':
    command => "tar xzf /tmp/apache-jmeter-${version}.tgz && mv apache-jmeter-${version} jmeter",
    cwd     => $installer_path,
    creates => "$installer_path/jmeter",
    require => Exec['download-jmeter'],
  }

  file { "$bin_path/jmeter":
    ensure => link,
    target => "$installer_path/jmeter/bin/jmeter",
    require => Exec['install-jmeter'],
  }

  file { "$installer_path/jmeter/bin/user.properties":
    ensure => file,
    content => template('jmeter/user.properties.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Exec['install-jmeter'],
  }

  if $plugins_install == true {
    jmeter::plugins_install { $plugins_set:
      installer_path    => $installer_path,
      plugins_version => $plugins_version,
      require         => [Package['wget'], Package['unzip'], Exec['install-jmeter']],
    }
  }
}
