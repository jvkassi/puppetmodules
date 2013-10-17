class tomat {

	file { "/usr/local/apache-tomcat-7.0.2.tar.gz" :
       owner   => "root",
       group   => "root",
       mode    => 0775,
       ensure  => present,
   	   source  => 'puppet:///modules/staging/apache-tomcat-7.0.2.tar.gz'
	}

	exec { "detare";
		command =>  "tar xzf /usr/local/apache-tomcat-7.0.2.tar.gz  && mv apache-tomcat-7.0.2 tomcat ", 
		cwd =>  /usr/local/,
		user => root,
		require => File["/usr/local/apache-tomcat-7.0.2.tar.gz"]
	}	

	group { "tomcat": 
        ensure => present,
		gid => 100,
		require => Exec["detare"]
	}

	user { "tomcat":
		enuser = pr