# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter (
  $jmeter_version         = '2.13',
  $jmeter_plugins_install = false,
  $jmeter_plugins_version = '1.2.1',
  $jmeter_plugins_set     = ['Standard'],
) {

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  package { 'unzip':
    ensure => present,
  }

  package { 'wget':
    ensure => present,
  }

  exec { 'download-jmeter':
    command => "wget -P /tmp http://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${jmeter_version}.tgz",
    creates => "/tmp/apache-jmeter-${jmeter_version}.tgz"
  }

  exec { 'install-jmeter':
    command => "tar xzf /tmp/apache-jmeter-${jmeter_version}.tgz && mv apache-jmeter-${jmeter_version} jmeter",
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  if $jmeter_plugins_install == true {
    jmeter::plugins_install { $jmeter_plugins_set:
      plugins_version => $jmeter_plugins_version,
      require         => [Package['wget'], Package['unzip'], Exec['install-jmeter']],
    }
  }
}
