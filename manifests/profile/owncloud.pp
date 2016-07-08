class site::profile::owncloud {
    # Create a new MySQL database
    mysql::db { "owncloud":
        user => "owncloud",
        password => "myowncloudpassword",
        host => "127.0.0.1",
        require => Class['mysql::server'],
    }

    # Setup nginx via the jfryman/nginx puppet module
    # https://forge.puppetlabs.com/jfryman/nginx
    class { 'nginx': }

    # Setup a sufficient php5 installation via the nodes/php puppet module
    # https://forge.puppetlabs.com/nodes/php
    class { 'php::extension::gd': }
    class { 'php::extension::curl': }
    class { 'php::extension::ldap': }
    class { 'php::cli': ensure => present }
    class { 'php::fpm::daemon': ensure => running }
    class { 'php::extension::mysql': }

    # Make sure php5-fpm is configured correctly
    php::fpm::conf { 'www':
        listen => '/var/run/php5-fpm.sock',
        user => 'www-data',
    }

    # Configure php correctly
    php::config { 'php-owncloud-conf':
        inifile  => '/etc/php5/fpm/php.ini',
        settings => {
            set => 
            {
                'Date/date.timezone' => 'Europe/Berlin',
                'PHP/upload_tmp_dir' => '/srv/owncloud/data',
                'PHP/upload_max_filesize' => '1000M',
                'PHP/post_max_size' => '1000M',
            }
        }
    }

    # Install owncloud
    class { 'owncloud':
        path => '/srv/owncloud'
    }

    # Configure nginx to serve owncloud
    class { 'owncloud::nginx':
        hostname => 'mydomain.tld',
        upload_max_filesize => '1000M',
        php_fpm => 'unix:/var/run/php5-fpm.sock',
        # ssl => true,
        # ssl_key => 'mydomain.tld.key',
        # ssl_cert => 'mydomain.tld.crt',
    }
}