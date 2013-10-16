# === Class proftpd
class proftpd {

    $proftpd    = hiera_hash('proftpd')
    $settings   = $proftpd['settings']
    $sftp       = $proftpd['sftp']

    $pkgs_name  = $::osfamily ? {
        'Debian'    => [ 'proftpd-basic', 'proftpd-mod-vroot' ],
        'RedHat'    => 'proftpd',
        default     => fail( "${::osfamily} not supported ")
    }

    # install packages
    package { $pkgs_name :
        ensure  => installed
    }

    package { 'pwgen' :
        ensure  => installed
    }

    service { 'proftpd' :
        ensure  => 'running',
        enable  => true
    }

    File {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Package[$pkgs_name]
    }

    file { '/etc/proftpd/proftpd.conf' :
        content => template('proftpd/proftpd.conf.erb'),
        notify  => Service['proftpd']
    }

    file { [ '/etc/proftpd/sftp.d' , '/etc/proftpd/messages.d' ] :
        ensure  => directory,
        mode    => '0755'
    }

    # script pour creer de nouveau utilisateur ftp
    file { '/usr/bin/new_ftp_account.sh' :
        mode    => '0755',
        content => template('proftpd/new_ftp_account.sh')
    }

    # create sftp instances
    each($sftp) { | $index, $value |
        File['/etc/proftpd/sftp.d'] ->
        proftpd::sftp { "install sftp vhost - ${value} ":
            settings    => $sftp[$index]
        }
   }
}
