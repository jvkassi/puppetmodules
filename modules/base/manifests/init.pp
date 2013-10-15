# class base
# Description: Define basic system

class base {

    $base = hiera_hash('base')
    # users stored in ldap
    #$users = $base('users')
    $dns = $base['dns']
    $admins_group = $base['admins_group']
    # set root users password
    #user { 'root':
    #    password => $base['root_password']
    #}

    # ensure install packages
    package { $base['packages'] :
        ensure => installed
    }


    # default file perms
    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

    # set issue, message prompt before login
    file { '/etc/issue':
        ensure  => present,
        content => template('base/issue.erb')
    }

    file { '/etc/issue.net' :
        ensure => symlink,
        target => '/etc/issue'
    }

    file { '/etc/hostname':
        ensure   => present,
        content => inline_template('<% @hostname %>')
    }

    file { '/etc/resolv.conf' :
        ensure   => present,
        content  => template('base/etc.resolv.conf')
    }

    file { '/etc/vim/vimrc' :
        content => template('base/etc.vimrc')
    }

    file { '/etc/tmux.conf' :
        content => template('base/etc.tmux.conf')
    }

    #file { '/etc/motd' :
    #    require  => Package['figlet'],
    #    ensure  => present,
    #    content => generate('/usr/bin/figlet', $::hostname)
    #}
    exec { "figlet ${::hostname} > /etc/motd" :
        require   => Package['figlet'],
        creates   => '/etc/motd',
        path    => ['/usr/bin']
    }

    # quand ce packet est installe....
    Package['sudo'] ->

    # ensured in the ldap
    #group { $base['groups'] :
    #    ensure => present
    #} ->

    # assure les acess au root, sudo NO PASSWD
    file { "/etc/sudoers.d/${admins_group}" :
        content => template("base/sudoers.admins.erb"),
        mode    => '0640',
    }

    file { '/etc/bash.bashrc' :
        content => template('base/root.bashrc'),
    }

    # utilise le bashrc global
    file { '/etc/skel/.bashrc' :
        ensure => absent,
    }

    file { '/etc/bash.bashrc.d' :
        ensure  => directory,
        mode    => '0755'
    } ->

    file { '/etc/bash.bashrc.d/README' :
        content => '#Extra bahsrc config\n'
    }

    define repo {
        notify{ 'lol !' :}
    }
}
