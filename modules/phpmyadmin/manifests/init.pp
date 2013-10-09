# === Class phpmyadmin
#
# Documentation
#
# install phpmyadmin
#
class phpmyadmin {

    $phpmyadmin     = hiera_hash('phpmyadmin')
    $httpd_config   = $phpmyadmin['httpd_config']
    $settings       = $phpmyadmin['settings']

    $config_file = $::osfamily ? {
        'Debian'    => '/etc/phpmyadmin/config.inc.php',
        'RedHat'    => '/etc/phpMyAdmin/config.inc.php',
        default     => fail("Distribution ${::lsbdistdescription} not supported")
    }

    package { 'phpmyadmin' :
        ensure => installed
    }

    File {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Package['phpmyadmin'],
    }

    # database connection config
    file { $config_file:
        content => template('phpmyadmin/config.inc.php.erb')
    }

    # webserver config
    file { $httpd_config:
        content  => template('phpmyadmin/httpd.conf.erb')
    }

}
