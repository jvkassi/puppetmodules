
class openssh_lpk {

	$openssh_lpk = hiera_hash('openssh_lpk')
	$dependencies = $openssh_lpk['dependencies']
	$bin = $openssh_lpk['bin']
	$bin_source = $openssh_lpk['bin_source']
	$config_file = $openssh_lpk['config_file']
	$config_template = $openssh_lpk['config_template']
	$config_params	= $openssh_lpk['config_params']

   # notify{ $dependencies: }
	package { $dependencies:
		ensure => installed
	}

	File {
		owner => root,
		group => root,
		mode => 655,
		replace => true,
        ensure => present
	}

	file { $config_file:
		content => template("$config_template"),
        mode => 600
	}

	file { $bin :
		source => $bin_source,
        mode => 755
	}
	
	file { '/var/empty':
		ensure => directory;
	}
}
