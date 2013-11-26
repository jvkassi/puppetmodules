# Tomcat

## Requirements / Compatibilty

This module works on Linux.
It will install tomcat and either use your java or install it
You got to download java xi386 and x64 for this module to install it from java.com
jdk-7u45-linux-i386.tar.gz and jdk-7u45-linux-x86_64.tar.gz

## Configuration Hiera

If you want use your own java version set java_home or set install_java

### common.yaml

    tomcat:
        settings:
            install_java: yes
            #java_home: /usr/lib/jvm/java
