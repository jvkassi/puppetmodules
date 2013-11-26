# Class java
class tomcat::java (
    $java_file = $tomcat::params::java_file
    ) {

    file { 'java_tar' :
        ensure  => present,
        path    => "/tmp/${java_file}",
        source  => "puppet:///modules/tomcat/${java_file}"
    }

    exec { 'decompress java' :
        command => "mkdir -p /usr/lib/jvm &&  tar -xzf /tmp/${java_file}  -C /usr/lib/jvm",
        path    => ['/bin', '/usr/bin'],
        user    => root,
        creates => '/usr/lib/jvm/jdk1.7.0_45',
        require => File['java_tar']
    }
}
