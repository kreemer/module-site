class site::profile::sshd {
    package { 'openssh-server':
        ensure => present,
    }
}