# Class tomcat
class tomcat {

    file { '/usr/local/apache-tomcat-7.0.34.tar.gz/':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0775',
        source  => 'puppet:///modules/staging/apache-tomcat-7.0.34.tar.gz'
    }

    exec { 'decompress' :
        command => 'tar xzf /usr/local/apache-tomcat-7.0.34.tar.gz  && mv apache-tomcat-7.0.2 tomcat ',
        cwd     => '/usr/local/',
        path    => ['/usr/bin', '/usr/sbin'],
        user    => root,
        require => File['/usr/local/apache-tomcat-7.0.34.tar.gz']
    }

    group { 'tomcat':
        ensure  => present,
        gid     => 100,
        require => Exec['detare']
    }

    user { 'tomcat':
        ensure  => present,
        gid     => 100,
        home    => '/usr/local/tomcat/',
        groups  => www-data,
        require => Group['tomcat']
    }

    file { '/etc/init.d/tomcat':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/tomcat/init.d/tomcat',
        require => Exec['detare']
    }

    package { 'chkconfig' :
        ensure  => present,
        require => File['/usr/local/apache-tomcat-7.0.34.tar.gz']
    }

    exec { 'chkonfig tomcat on ' :
        cwd     => '/etc/home/',
        user    => root,
        require => Package[ 'chkconfig']
    }

}
