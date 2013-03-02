maintainer        "Matteo Alessani"
maintainer_email  "alessani@gmail.com"
license           "Apache 2.0"
description       "Installs and configures the server, with logrotate and upstart"
version           "1.0.2"

recipe            "main", "Setup all settings for sytems included ebs"
recipe            "main::user", "Setup user for system"
recipe            "main::mysql", "Setup user for mysql"
recipe            "main::postgresql", "Setup user for pg"
recipe            "main::ec2_apps_mounting", "Setup system with ebs volumes for deploy apps"
recipe            "main::ec2_mysql_mounting", "Setup system with ebs volumes for deploy database"
recipe            "main::apt_postgresql_ppa", "set repository for postgresql 9"
recipe            "main::jetty", "logrotate for jetty"
recipe            "main::unicorn", "logorotate apps"
recipe            "main::nginx", "upstart configuration"

depends 'database'
depends 'logrotate'
depends 'apt'
depends 'git'
depends 'ntp'
depends 'openssl'
depends 'build-essential'
