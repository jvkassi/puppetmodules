define postgresql::db (
        $name,
        $user,
        $pass,
        $bin_path = $postgresql::params:bin_path
    ) inherits postgresql::params {
    
        exec { 'create db' :
            exec    => "${bin_path}/createdb ${name}"
        }
}
