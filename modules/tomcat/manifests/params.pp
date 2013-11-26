# === Class tomcat
#
class tomcat::params {

    $tomcat     = hiera_hash('tomcat')
    $install_java = $tomcat['install_java']
    $java_file = "jdk-7u45-linux-${::architecture}.tar.gz"

    $java_home = $install_java ? {
        true  => '/usr/lib/jvm/jdk1.7.0_45',
        false => $params['java_home'],
        default => fail( 'Undefined java_home in hiera' )
    }
}
