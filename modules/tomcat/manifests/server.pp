# === Class tomcat::server
class tomcat::server ( 
        $version = $tomcat::params::version
    ) {
        
        $pkg_name = "tomact${version}"
        $base_dir = "/var/lib/${pkg_name}"
        $conf_dir = "${base_dir}/conf"

        package { $pkg_name:
            ensure  => installed
        }

        File {
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            ensure  => present
        }

        file { "${conf_dir}/server.xml" :
            content => template('tomcat/server.xml.erb')
        }

        file { "${conf_dir}/tomcat-users.xml" :
            content => template('tomcat/tomcat-users.xml')
        }

        file { "${conf_dir}/

            
            
            
    }
