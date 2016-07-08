class site::profile::gitlab {
    class { '::gitlab':
        external_url => 'http://gitlab.mydomain.tld',
    }
}