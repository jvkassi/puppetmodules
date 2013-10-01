# class puppet::client
# set template puppet.conf

class puppet::client {

    $settings = $puppet::puppet['settings']
    $client = $puppet::puppet['client']

    package { $client['dependencies'] :
        ensure => installed
    }

    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
   
    service { 'puppet' :
        ensure  => running,
        enable  => true
    }

    file { '/etc/puppet/puppet.conf':
        content => template('puppet/etc.client.puppet.conf.erb')
        ensure  => present,
        notify  => Service['puppet']
    }
}
