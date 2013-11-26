# phpMyAdmin

## Requirements / Compatibilty

This module works on Debian. This module needs the mysql::server module to be enabled as well.
RedHat compatibility is dubious since the mysql module doesn seem to be RedHat compatible.

The phpMyAdmin will store some user-related information ([the pmadb](http://wiki.phpmyadmin.net/pma/Configuration_storage)) in a local database (hence the mysql::server requirement).

## Configuration files : 

The main configuration files imanaged by puppet are : 

**/etc/phpmyadmin/config.inc.php**

**/etc/phpmyadmin/apache.conf**

The information regarding the local database is in : **/etc/phpmyadmin/config-db.php**

This file is not managed by puppet.

## Configuration Hiera
