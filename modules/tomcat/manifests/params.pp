# === Class tomcat
#
class tomcat::params {
    
    $tomcat     = hiera_hash('tomcat')
    $version    = $tomcat['version']
    $settings   = $tomcat['settings']

}
