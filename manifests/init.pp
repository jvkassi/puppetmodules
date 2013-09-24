
node default {
    $nom = hiera('nom')
    notify { $nom: }
	include openssh_lpk
}
