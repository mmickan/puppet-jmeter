# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter (
  $installer_path    = $::jmeter::params::installer_path,
  $bin_path          = $::jmeter::params::bin_path,
  $version           = $::jmeter::params::version,
  $plugins_install   = $::jmeter::params::plugins_install,
  $plugins_version   = $::jmeter::params::plugins_version,
  $plugins_set       = $::jmeter::params::plugins_set,
  $user_config       = $::jmeter::params::user_config,
  $download_url      = undef,
  $download_url_base = $::jmeter::params::download_url_base,
) inherits jmeter::params {

  $real_download_url = pick($download_url, "${download_url_base}/apache-jmeter-${version}.tgz")

  include staging
  file { "${::staging::path}/jmeter":
    ensure => 'directory',
  } ->
  staging::file { "apache-jmeter":
    source => $real_download_url,
    target => "${::staging::path}/jmeter/apache-jmeter-${version}.tgz",
  } ->
  staging::extract { "apache-jmeter-${version}.tgz":
    target  => $installer_path,
    source  => "${::staging::path}/jmeter/apache-jmeter-${version}.tgz",
    creates => "${installer_path}/apache-jmeter-${version}",
  } ->
  file { "${installer_path}/jmeter":
    ensure => link,
    force  => true,
    target => "${installer_path}/apache-jmeter-${version}",
  }

  file { "$bin_path/jmeter":
    ensure  => link,
    target  => "$installer_path/jmeter/bin/jmeter",
    require => File["${installer_path}/jmeter"],
  }

  file { "$installer_path/jmeter/bin/user.properties":
    ensure => file,
    content => template('jmeter/user.properties.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File["${installer_path}/jmeter"],
  }

  if $plugins_install == true {
    jmeter::plugins_install { $plugins_set:
      installer_path  => $installer_path,
      plugins_version => $plugins_version,
      require         => File["${installer_path}/jmeter"],
    }
  }
}
