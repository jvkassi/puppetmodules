# === Class Postgresql
#
class postgresql::params {

    $params = hiera_hash('postgresql')
    $version    = $params['version']
    $settings   = $params['settings']

    $bin_dir     = "/usr/lib/postgresql/${version}/bin"
    case $::osfamily {
        'RedHat' : { 
            
            $pkg = $params['pkg_version']

            $service = "postgresql-${version}"

            # package name
            $package = "postgresql${pkg_version}"

            # data dir
            $data_dir  = "/etc/postgresql/${version}/data"
            $config_dir  = "/var/lib/pgsql/${version}/data"

            # initialize db for RedHat os
            $need_initdb = true

            base::repo { 'postgresql' :
                name    => "postgresql-${version}",
                url     => "http://http://yum.postgresql.org/${version}/redhat",
                params  => "/rhel-${operatingsystemrelease}-${::architecture}",
            }
        }
        'Debian' : {
            
            $package    = "postgresql-${version}"
            
            $service    = 'postgresql'

            # data dir
            $data_dir  = "/var/lib/postgresql/${version}/main"
            $config_dir  = "/etc/postgresql/${version}/main"


            base::repo { 'postgresql' :
                name        => "postgresql-${version}",
                url         => 'http://apt.postgresql.org/pub/repos/apt/',
                params      => "${lsbdistcodename}-pgdg main",
                pubkeyurl   => 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
            }
        }
        default : {
            fail("${::osfamily} not supported")
        }
    }
    
}
