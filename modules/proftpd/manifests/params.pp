# === Class proftpd
class proftpd::params {

    $proftpd    = hiera_hash('proftpd')
    $settings   = $proftpd['settings']
    $sftp       = $proftpd['sftp']

    $pkgs_name  = $::osfamily ? {
        'Debian'    => [ 'proftpd-basic', 'proftpd-mod-vroot' ],
        'RedHat'    => 'proftpd',
        default     => fail( "${::osfamily} not supported ")
    }

    $config_file = $::osfamily ? {
        'Debian'    => '/etc/proftpd/proftpd.conf',
        'RedHat'    => '/etc/proftpd.conf',
        default     => fail( "${::osfamily} not supported ")

    }
}
