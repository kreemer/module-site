class site::profile::subsonic {

    user { 'subsonic':
        ensure      => 'present',
        
    }

    class { 'subsonic':
        home         => '/var/subsonic',
        http_port    => '4040',
        https_port   => '0',
        context_path => '/',
        max_memory   => '150',
        pidfile      => '/var/run/subsonic',
        user         => 'subsonic',
    }
}