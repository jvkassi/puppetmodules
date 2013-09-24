node default {
	#$packages = hiera_hash("packages")
	include openssh_lpk
}
