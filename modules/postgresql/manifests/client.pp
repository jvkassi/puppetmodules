# === Class postgresql::client
#
class postgresql::client inherits postgresql::params {
    
    $client_package = $::osfamily ? {
        'Debian'    => "${postgresql::package}-client",
        'RedHat'    => "${postgresql::package}"

    package { $client_package :
        ensure  => present
    }

}
