# define vhosts
#

define apache::vhost(
    $docroot,
    $ssl        = false,
    $servername = name,
    ) {

    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        ensure  => present,
        require => Package[$apache::dependencies],
        notify  => Service[$apache::service]
    }

    # ensure docroot,.
    file { $docroot :
        ensure  => directory,
        owner   => $apache::user,
        group   => $apache::group,
        mode    => '0755'
    }
    # add vhost

    file { $servername :
        ensure  => present,
        path    => "${apache::vhost_dir}/${servername}.conf",
        content => template('apache/vhost.conf.erb'),
    }

    # add symlink if a debian
    if $::osfamily == 'Debian' {
        file {"link-${servername}" :
            ensure  => link,
            path    => "${apache::vhost_enable_dir}/${servername}.conf",
            target  => "${apache::vhost_dir}/${servername}.conf"
            require => File[$servername]
        }
    }
}
