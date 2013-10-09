# === Define users
# create users
Define postgresql::users (
    ) inherits postgresql::params {
        
        $bin_path = $postgresql
    }
