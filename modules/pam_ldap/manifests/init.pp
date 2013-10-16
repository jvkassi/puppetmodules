# pam-ldap
#
class pam_ldap {
    $pam_ldap       = hiera_hash('pam_ldap')
    $dependencies   = $pam_ldap['dependencies']
    $settings       = $pam_ldap['settings']

    #instal dep
    package { $dependencies :
        ensure => installed
    }

    service { ['nslcd', 'nscd']:
        ensure  => running,
        enable  => true,
        require => Package[$dependencies]
    }


    File {
        owner   => nslcd,
        group   => nslcd,
        mode    => '0644',
        require => Package[$dependencies],
    }

    # nsswitch ldap
    file { '/etc/nsswitch.conf' :
        content => template('pam_ldap/nsswitch.conf.erb')
    }

    file { '/etc/nscld.conf':
        content => template('pam_ldap/nslcd.conf.erb'),
        notify  => Service['nslcd']
    }

    file { '/etc/nscd.conf' :
        content => template('pam_ldap/nscd.conf.erb'),
        notify  => Service['nscd']
    }
}
