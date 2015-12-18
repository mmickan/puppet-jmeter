define jmeter::plugins_install (
  $installer_path,
  $plugins_version,
  $plugins_set = $title,
) {

  $base_download_url = 'http://jmeter-plugins.org/downloads/file/'
  $plugins_file_base = "JMeterPlugins-${plugins_set}-${plugins_version}"

  exec { "download-jmeter-plugins-${plugins_set}":
    command => "wget -P /tmp ${base_download_url}/${plugins_file_base}.zip",
    creates => "/tmp/${plugins_file_base}.zip"
  }

  exec { "install-jmeter-plugins-${plugins_set}":
    command => "unzip -q -o -d JMeterPlugins-${plugins_set} ${plugins_file_base}.zip && cp -r JMeterPlugins-${plugins_set}/lib/* $installer_path/jmeter/lib/",
    cwd     => '/tmp',
    creates => "$installer_path/jmeter/lib/ext/JMeterPlugins-${plugins_set}.jar",
    require => Exec["download-jmeter-plugins-${plugins_set}"],
  }
}
