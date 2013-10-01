# class apache
# install apache server
#
class apache {
    
    $apache = hiera_hash('apache')

    
    # install dependencies
    package { $apache['dependencies'] :
        ensure => latest
    }

    File {
        owner   => 'root',
        group   => $apache['group'],
        mode    => '066',
        ensure  => present
    }

    file { $apache['config_dir'] :
        content => template($config_template)
    }


}
