define base::repo (
    $name,
    $url,
    $params,
    $pubkeyurl,
    $pubkeytype = 'http',
    $enabled = true
) {

  $is_enabled = $enabled ? {
    true            => 'present',
    false           => 'absent'
  }

  case $::osfamily {
    'Debian':       { $path = "/etc/apt/sources.list.d/${name}.list" }
    'RedHat':       { $path = "/etc/yum.repos.d/${name}.repo" }
    default:        { fail('Operating system not supported.') }
  }

  file { $path :
    ensure          => $is_enabled,
    content         => template(downcase("base/repository.${::osfamily}")),
    owner           => 'root',
    group           => 'root',
    mode            => '0644',
  }

  if $::osfamily == 'Debian'
  {
    if $pubkeyurl != undef
    {
      case $pubkeytype {
        /http/: {
          exec { "/usr/bin/wget -O - ${pubkeyurl} | /usr/bin/apt-key add -" :
            refreshonly     => true,
            subscribe       => File["/etc/apt/sources.list.d/${name}.list"],
            before          => Exec["aptupdate-${name}"]
          }
        }
        /gpg/: {
          $gpgparams = split($pubkeyurl, ':')
          exec { "/usr/bin/apt-key adv --recv-keys --keyserver ${gpgparams[0]} ${gpgparams[1]}" :
            refreshonly     => true,
            subscribe       => File["/etc/apt/sources.list.d/${name}.list"],
            before          => Exec["aptupdate-${name}"]
          }
        }
        default: {
          fail('Public Key type unknown')
        }
      }
    }

    exec { "aptupdate-${name}" :
      command     => '/usr/bin/apt-get update',
      refreshonly => true,
      subscribe   => File["/etc/apt/sources.list.d/${name}.list"]
    }
  }
}
