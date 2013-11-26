# Class tomcat
class tomcat (
        $install_java   = $tomcat::params::install_java,
        $java_home      = $tomcat::params::java_home,
        $users          = $tomcat::params::users,
        $roles          = $tomcat::params::roles
    ) inherits tomcat::params {

    if $install_java  {
        class { 'tomcat::java': }
    }

    file { 'tomcat_tar' :
        ensure  => present,
        path    => '/tmp/apache-tomcat-7.0.34.tar.gz',
        source  => 'puppet:///modules/tomcat/apache-tomcat-7.0.34.tar.gz'
    }


    group { 'tomcat':
        ensure  => present,
    } ->

    user { 'tomcat':
        ensure  => present,
        gid     => tomcat,
        home    => '/usr/share/tomcat',
    } ->

    exec { 'decompress' :
        command => 'tar -xzf /tmp/apache-tomcat-7.0.34.tar.gz  -C /usr/share/ --transform s/apache-tomcat-7.0.34/tomcat/ ',
        path    => ['/bin', '/usr/bin'],
        user    => tomcat,
        creates => '/usr/share/tomcat',
        require => File['tomcat_tar']
    }

    file { '/usr/share/tomcat' :
        ensure  => directory,
        owner   => 'tomcat',
        group   => 'tomcat',
        recurse => true
    }

    file { 'tomcat_init.d':
        path        => '/etc/init.d/tomcat',
        owner       => 'root',
        group       => 'root',
        mode        => '0755',
        content     => template('tomcat/tomcat.init.erb'),
        require     => Exec['decompress']
    }

    package { 'chkconfig' :
        ensure  => present,
        require => File['tomcat_tar'],
    }

    service { 'tomcat' :
        ensure  => running,
        require => File['tomcat_init.d'],
    }
}
