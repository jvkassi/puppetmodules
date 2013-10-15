# === Class phpmyadmin
#
# Documentationsdf
#
# install phpmyadmin
#
class phpmyadmin {

      # variable hiera
      $phpmyadmin     = hiera_hash('phpmyadmin')
      $httpd_config   = $phpmyadmin['httpd_config']
      $web_server     = $phpmyadmin['web_server']
      $settings       = $phpmyadmin['settings'];

      case $::osfamily {
          'RedHat' : {
              $pkg_name     = 'phpMyAdmin'
              $config_dir   = '/usr/share/phpMyAdmin'
              $config_file  = '/etc/phpMyAdmin/config.inc.php'

              # ensure epel repo
              yumrepo { 'epel':
                    mirrorlist      => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::os_maj_version}&arch=${::architecture}",
                    failovermethod  => 'priority',
                    enabled         => '1',
                    gpgcheck        => '1',
                    gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::os_maj_version}",
                    descr           => "Extra Packages for Enterprise Linux ${::os_maj_version} - ${::architecture}"
              }
          }
          'Debian' : {
              $pkg_name      = 'phpmyadmin'
              $config_dir    = '/usr/share/phpmyadmin'
              $config_file   = '/etc/phpmyadmin/config.inc.php'
          }
          default : {
              fail( "${::osfamily} not supported" )
          }
      }

      # install main package
      package { $pkg_name :
        ensure  => installed
      }

      # ensure web server
      package { $web_server :
        ensure  => present
      }

      service { $web_server :
        ensure  => running,
        enable  => true,
        require => Package[$web_server]
      }

      File {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Package[$pkg_name],
      }

      # database connection config
      file { $config_file:
        content => template('phpmyadmin/config.inc.php.erb')
      }

      # webserver config
      file { $httpd_config:
        content    => template('phpmyadmin/httpd.conf.erb'),
        notify     => Service[$web_server]
      }

}
