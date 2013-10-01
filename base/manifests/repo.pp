# define repo
# install new repo
#
define base::repo (
    $url,
    $name,
    $distrib,
    $sections,
    $enabled = true,
    $pubkeytype = 'http',
    $pubkeyurl = undef
    ) {
        inlcude base

        $is_enabled = $enabled ? {
            true    => 'present',
            false   => 'absent'
        }

        $base = hiera_hash('base')
        $repo_dir = $base['repo_dir']
 
        $repo_path = "${repo_dir}/${name}.list"
        file { $repo_path :
            ensure  => $is_enabled,
            content => template("base/repository.${::osfamily}"),
            owner   => 'root',
            group   => 'root',
            mode    => '0644'
        }

        if $::osfamily == 'Debian' {
            if $pubkeyurl != undef {
                case pubkeytype {
                    /http/: {
                        exec { "/usr/bin/wget -O - ${pubkeyurl} | /usr/bin/apt-key add -" :
                            refreshonly     => true,
                            susbscripe      => File[$repo_path]
                        }
                    } 
                    /gpg/: {
                        $gpgparams = split($pubkeyurl, ':')
                        exec { "/usr/bin/apt-key adv --recv-keys --keyserver ${gpgparams[0]} ${gpgparams[1]}" :
                            refreshonly     => true,
                            suscribe        => File[$repo_path]
                        }
                    }
                 }
               }
            exec { "aptupdate-${name}" :
                command     => '/usr/bin/apt-get update',
                refreshonly => true,
                subscribe   => File[$repo_path]
            }
        }
   }
