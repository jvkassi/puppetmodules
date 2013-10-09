# === Class postgresql
#
class postgresql::server(
        $version        = $postgresql::params::version,
        $config_dir     = $postgresql::params::config_path,
        $package        = $postgresql::params::package,
        $service        = $postgresql::params::service,
        $settings       = $postgresql::params::settings,
        $data_dir       = $postgresql::params::data_dir,
        $config_dir     = $postgresql::params::config_dir,
        $bin_dir        = $postgresql::params::bin_path,
        $need_initdb    = $postgresql::params::need_initdb
    ) inherits postgresql::params {
    
    notify{ $settings :}
    include postgresql
    # server package
    $server_package = $::osfamily ? {
        'RedHat'    => "${package}-server",
        'Debian'    => $package,
        default     => fail(" ${::osfamily} not supported ")

    }

    # default file permission
    File { 
        ensure  => present,
        owner   => postgres,
        group   => postgres,
        mode    => '0640'
    }

    file { $config_dir :
        ensure  => directory,
        owner   => postgres,
        group   => postgres
    }

    if $need_initdb == true {
        
        # initdb unless already exist
        exec { 'initdb' :
            command     => "${bin_dir}/initdb -D ${datadir}",
            user        => postgres,
            group       => postgres,
            logoutput   => on_failure,
            before      => File[$datadir]
        }

    }
    file { 'pg_hba.conf':
        path    => "${config_dir}/pg_hba.conf",     
        content => template('postgresql/pg_hba.conf.erb')
    }

    file { 'postgresql.conf':
        path    => "${config_dir}/postgresql.conf",
        content => template('postgresql/postgresql.conf.erb')
    }

    package { $server_package:
        ensure  => present
    } 
    ->
    service { $service :
        enable      => true,
        ensure      => running,
        subscribe   => [ File['pg_hba.conf'],
                         File['postgresql.conf']]
    }

}
