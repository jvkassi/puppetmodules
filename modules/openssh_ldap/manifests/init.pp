# class openssh_ldap
#
#

class openssh_ldap {

    $openssh_ldap = hiera_hash('openssh_ldap')
    $dependencies = $openssh_ldap['dependencies']
    $service = $openssh_ldap['service']
    $bin = $openssh_ldap['bin']
    $bin_source = $openssh_ldap['bin_source']
    $config_file = $openssh_ldap['config_file']
    $config_template = $openssh_ldap['config_template']
    $config_params  = $openssh_ldap['config_params']

    if( $::osfamily == 'Debian') {
        if( $::lsbmajdistrelease < 7 ) {
            file{ '/etc/apt/sources.list.d/wheezy.list':
                ensure  => present,
                content => template('openssh_ldap/wheezy.list.erb')
            }
        }
    } 

    package { $dependencies:
        ensure => latest
    } 

    service { $service:
        ensure  => running,
        enable  => true
    } 

    File {
        owner   => root,
        group   => root,
        mode    => '0655',
        replace => true,
        ensure  => present
    } 

    file { $config_file:
        content => template($config_template),
        mode    => '0600',
        notify  => Service[$service]
    }

    file { $bin :
        source  => $bin_source,
        mode    => '0755'
    } 

    # nsswitch ldap
    file { '/etc/nsswitch.conf' :
        content => template('openssh_ldap/nsswitch.conf.erb')
    } 

    file { '/var/empty':
        ensure => directory;
    } 
}
