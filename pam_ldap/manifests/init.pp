# pam-ldap
#

class pam_ldap {

    $pam_ldap       = hiera_hash('pam_ldap')
    $dependencies   = $pam_ldap['dependencies']
    $service        = $pam_ldap['service']
    $config_file    = $pam_ldap['config_file']
    $config_template= $pam_ldap['config_template']
    $config_params  = $pam_ldap['config_params']

    #instal dep
    package { $dependencies :
        ensure => installed
    }

    service { $service:
        ensure  => running,
        enable  => true,
        require => Package[$dependencies]
    }


    File {
        owner   => nslcd,
        group   => nslcd,
        mode    => '0600',
        require => Package[$dependencies],
    }
    
    # nsswitch ldap
    file { '/etc/nsswitch.conf' :
        content => template('pam_ldap/nsswitch.conf.erb')
    }

    file { $config_file:
        content => template($config_template),
        notify  => Service[$service]
    }

}
