# CLass: pdns::server 
# 
# manages the install of the powerdns and backend
#

class pdns::server {
    
    $pdns = hiera_hash('pdns')
    $server = $pdns['server']
    packages = $server['packages']
    service = $server['service']
    $conf_file = $server['conf_file']
    $template = $server['template']
    $backend = $server['backend']
    $host  = $backend['dbhost']
    $dbport = $backend['dbport']
    $dbname = $backend['dbname']
    $dbuser = $backend['dbuser']
    $dbpass = $backend['dbpass']
    $file = $backend['file']
    $template = $backend['template']

    package { $packages:
        ensure => installed
    }
    
    service { $service: 
        ensure => running,
        enable => true
        require => Packages[$packages]
    }

    File {
        owner => root,
        mode => 755,
        ensure => file,
    }
    file { $conf_file : 
        content => template($template)    
    }
}


