# class ntp
# set time 

class ntp {
    
    $ntp            = hiera_hash('ntp')
    $service        = $ntp['service']

    # install dep
    package { $ntp['dependencies'] :
        ensure => installed
    } ->

    service { $service:
        ensure => running
    }

    file { $ntp['config_file'] :
        ensure  => present,
        content => template('ntp/etc.ntp.conf.erb')
    }
   
}
