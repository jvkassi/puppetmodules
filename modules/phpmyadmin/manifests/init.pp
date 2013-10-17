# === Class phpmyadmin
#
# main phpmyadmin class
#
class phpmyadmin (
            $pkg_name       = $phpmyadmin::params::pkg_name,
            $settings       = $phpmyadmin::params::settings,
            $dbservers      = $phpmyadmin::params::dbservers,
            $httpd_server   = $phpmyadmin::params::httpd_server,
            $httpd_symlink  = $phpmyadmin::params::httpd_symlink,
            $config_file    = $phpmyadmin::params::config_file,
            $config_dir     = $phpmyadmin::params::config_dir,
            $httpd_config   = $phpmyadmin::params::httpd_config
      ) inherits phpmyadmin::params {

      package { $pkg_name :
        ensure  => present
      }

      #ensure web server
      package { $httpd_server:
        ensure  => present
      }

      service { $httpd_server:
        ensure  => running,
        enable  => true,
        require => Package[$httpd_server]
      }

      File {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Package[$pkg_name],
        notify  => Service[$httpd_server]
      }

      # database connection config
      file { $config_file:
        content => template('phpmyadmin/config.inc.php.erb')
      }

      # webserver config
      file { $httpd_config:
        content    => template('phpmyadmin/httpd.conf.erb'),
      }

      # symlink
      file { $httpd_symlink:
        ensure     => 'link',
        target     => $httpd_config
      }

}
