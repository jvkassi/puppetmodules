
# === Class: proftpd
#
# Documentation
#
#
class proftpd {

    $proftpd    = hiera_hash('proftpd')
    $settings   = $proftpd['settings']
    $sftp       = $proftpd['sftp']
    # install packages

    package { 'proftpd' :
        ensure  => installed
    }


    # create sftp virtual host
    each($sftp) { | $index,$value | 
       File['/etc/proftpd/sftp.d'] ->
       proftpd::sftp{ $value: 
            settings    => $sftp[$index]
       }
    }

    service { 'proftpd' :
        ensure      => 'running',
        enable      => true,
    }

    # Default file configuration
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['proftpd'],
    }

    # proftpd configuration
    file { '/etc/proftpd/proftpd.conf' :
        content => template('proftpd/proftpd.conf.erb'),
        notify  => Service['proftpd']
    }
    
    # directories
    file { [ '/etc/proftpd/sftp.d', '/etc/proftpd/messages.d' ] :
        mode    => '0755',
        ensure  => directory
    }

    # création du scritp d'ajout de nouveau client ftp
    file { '/usr/local/bin/new_ftp_account.sh' :
        mode    => '0755',
        content => template('proftpd/new_ftp_account.sh')
    }
}
