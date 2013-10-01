class mysql {
    
    $mysql = hiera_hash('mysql')

    package { $mysql['dependencies'] :
        ensure      => installed
    }

}
