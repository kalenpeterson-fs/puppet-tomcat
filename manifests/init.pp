# Class: tomcat
# ===========================
#
# Full description of class tomcat here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'tomcat':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class tomcat (
  $server_port    = '8005',
  $connector_port = '8080',
){

  # Set the Module Path
  $module_path  = '/etc/puppetlabs/code/modules'

  # Install the tomcat package
  package { 'tomcat7':
    ensure => 'installed',
    before => File['/etc/tomcat7/server.xml'],
  }

  # Manage the tomcat service
  service { 'tomcat7':
    ensure  => 'running',
    require => Package['tomcat7'],
  }

  # Manage the server.xml file
  file { '/etc/tomcat7/server.xml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['tomcat7'],
    content => epp('tomcat/server.xml.epp', {
      'server_port'    => $server_port,
      'connector_port' => $connector_port,
    }),
  }

  # Manage the content of the website
  file { '/var/lib/tomcat7/webapps/ROOT/index.html':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['tomcat7'],
    source  => "${module_path}/tomcat/files/index.html",
  }
}
