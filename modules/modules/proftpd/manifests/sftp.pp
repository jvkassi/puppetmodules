# sftp virtual host

define proftpd::sftp(
        $settings
    ) {

        $vhost_name = $settings['vhost_name']

        # create login motd
        file { "/etc/proftpd/messages.d/login-${vhost_name}.msg" :
            ensure  => present,
            content => inline_template($settings['motd'])
        }

        # config file
        file{ "/etc/proftpd/sftp.d/${vhost_name}" :
            ensure  => present,
            content => template('proftpd/sftp.conf.erb'),
            notify  => Service['proftpd']
        }

    }
