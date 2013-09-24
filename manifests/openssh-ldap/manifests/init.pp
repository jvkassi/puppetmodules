
class openssh_lpk {

	$openssh_lpk = hiera_hash('openssh_ldap')
	$packages = $openssh_lpk['packages']
	$scripts = $openssh_lpk['scripts']
	
	package { $packages:
		ensure => installed
	}


}
