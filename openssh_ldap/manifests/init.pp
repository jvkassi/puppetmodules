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
    $settings = $openssh_ldap['settings']

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
        mode    => '0644',
        replace => true,
        ensure  => present,
        require => Package[$dependencies]
    } 

    file { '/etc/ssh/sshd_config.conf' :
        content => template('openssh_ldap/sshd_config.conf.erb'),
        mode    => '0640',
        notify  => Service[$service]
    }

    file { $bin :
        source  => $bin_source,
        mode    => '0755',
        notify  => Service[$service]
    } 

    file { '/var/empty':
        ensure => directory;
    } 

    file { '/etc/pam.d/sshd' :
        content => template("openssh_ldap/${::osfamily}.etc.pam.d.sshd")
    }
}
