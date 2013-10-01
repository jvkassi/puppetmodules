# class puppet 
# basic puppet 

class puppet {

    include base
        $puppet = hiera_hash('puppet')


    base::repo { 'http://apt.puppetlabs.com' :                           
            name            => 'puppetlabs',                                  
            sections        => 'main dependencies',                           
            distrib         => 'wheezy',                                      
            pubkeyurl       => 'http://apt.puppetlabs.com/pubkey.gpg'         

    }
 }
