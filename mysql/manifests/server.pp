# CLass: pdns::server 
# 
# manages the install of the powerdns and params
#

class pdns::server {

        $pdns = hiera_hash('pdns')
        $server = $pdns['server']
        $packages = $server['packages']
        $service = $server['service']
        $config_file = $server['conf_file']
        $conffig_template = $server['template']
        $directories = $server['directories']
        $root_password = $server['root_password']
        $old_password = $server['old_password']

        package { $packages:
            ensure => installed
        }

        file { $directories : 
            ensure => directory,
            mode => 755
        }
        #  manage root password if it is set
        if $root_password != 'UNSET' {
        case $old_root_password {
            '': { $old_pw='' }
            default: { $old_pw="-p'${old_root_password}'" }
        }

        exec { 'set_mysql_rootpw':
            command => "mysqladmin -u root ${old_pw} password '${root_password}'",
            logoutput => true,
            environment => "HOME=${root_home}",
            unless => "mysqladmin -u root -p'${root_password}' status > /dev/null",
            path => '/usr/local/sbin:/usr/bin:/usr/local/bin',
            require => File['/etc/mysql/conf.d'],
        }


        service { $service: 
            ensure => running,
              enable => true
                require => Packages[$packages]
        }

        File {
            owner => root,
                  mode => 755,
                  ensure => file,
        }
        file { $config_file : 
            content => template($template)    
        }
    }


