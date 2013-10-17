# === Class phpmyadmin
#
# Documentation
#
# install phpmyadmin
#
class phpmyadmin::params {

      $phpmyadmin = hiera_hash('phpmyadmin')
      $settings   = $phpmyadmin['settings']
      $dbservers  = $phpmyadmin['dbservers'] 

      case $::osfamily {
          'RedHat' : {
              $pkg_name     = 'phpMyAdmin'
              $config_dir   = '/usr/share/phpMyAdmin'
              $config_file  = '/etc/phpMyAdmin/config.inc.php'
              $httpd_server  = 'httpd'
              $httpd_config = '/etc/phpMyAdmin/httpd.conf'
              $httpd_symlink= '/etc/httpd/conf.d/phpMyAdmin.conf'
              $gpg          = "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::os_maj_version}"

              # ensure key
              file { $gpg:
                ensure      => present,
                owner       => 'root',
                group       => 'root',
                mode        => '0644',
                content     => template("phpmyadmin/RPM-GPG-KEY-EPEL-${::os_maj_version}")
              }


              # ensure epel repo
              yumrepo { 'epel':
                mirrorlist      => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::os_maj_version}&arch=${::architecture}",
                failovermethod  => 'priority',
                enabled         => '1',
                gpgcheck        => '1',
                gpgkey          => "file://${gpg}",
              }

          }
          'Debian' : {
              $pkg_name      = 'phpmyadmin'
              $config_dir    = '/usr/share/phpmyadmin'
              $config_file   = '/etc/phpmyadmin/config.inc.php'
              $httpd_server  = 'apache2'
              $httpd_config  = '/etc/phpmyadmin/apache.conf'
              $httpd_symlink = '/etc/apache2/conf.d/phpmyadmin.conf'
          }
          default : {
              fail( "${::osfamily} not supported" )
          }
      } 

}
