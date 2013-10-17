# === Class: proftpd
#
# main proftpd class
# 
class proftpd (
        $settings   = $proftpd::params::settings,
        $pkgs_name  = $proftpd::params::pkgs_name
    ) inherits proftpd::params {

    # install packages
    package { $pkgs_name :
        ensure  => installed
    }

    package { 'pwgen' :
        ensure  => installed
    }

    if $settings['enabled'] {
        service { 'proftpd' :
            ensure  => 'running',
            enable  => true
        }
    }
    else {
        service{ 'proftpd' :
            ensure  => 'stopped'
        }
    }

    group { $settings['group'] :
        ensure  => present
    } ->

    user { $settings['user'] :
        ensure  => present,
        home    => '/var/run/proftpd',
        gid     => $settings['group'],
        shell   => '/bin/false'
    }

    File {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Package[$pkgs_name]
    }

    file { $config_file :
        content => template('proftpd/proftpd.conf.erb'),
        notify  => Service['proftpd']
    }

    # mkdir directories
    file { [ '/etc/proftpd', '/etc/proftpd/sftp.d' , '/etc/proftpd/messages.d', '/etc/proftpd/ssl' ] :
        ensure  => directory,
        mode    => '0755'
    }

    # modules conf
    file { '/etc/proftpd/modules.conf' :
        content => template('proftpd/modules.conf.erb')
    }

    # script pour creer de nouveau utilisateur ftp/sftp
    file { '/usr/local/sbin/new_ftp_account' :
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

    if $settings['enable_tls'] { 
        file { '/etc/proftpd/ssl/proftpd.cert.pem' :
            content => template('proftpd/proftpd.cert.pem')
        }
        file { '/etc/proftpd/ssl/proftpd.key.pem':
            content => template('proftpd/proftpd.key.pem')
        }
    }

}
