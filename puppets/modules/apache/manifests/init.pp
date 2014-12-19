class apache {

    package { ['apache2']:
        ensure => installed,
        require => [Exec['apt-get update']]
    }

    exec { 'enable-mod-rewrite':
        command => '/usr/sbin/a2enmod rewrite',
        path    => ['/bin', '/usr/bin'],
        unless  => "/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load",
        require => Package['apache2']
    }

    exec { 'enable-mod-ssl':
        command => '/usr/sbin/a2enmod ssl',
        path    => ['/bin', '/usr/bin'],
        unless  => "/bin/readlink -e /etc/apache2/mods-enabled/ssl.load",
        require => Package['apache2']
    }

    file { '/etc/apache2/sites-available/hosts':
        source => 'puppet:///modules/apache/virtual_hosts',
        audit  => content,
        require => Package['apache2']
    }

    exec { 'enable-hosts':
        command => '/usr/sbin/a2ensite hosts',
        unless  => '/bin/readlink -e /etc/apache2/sites-enabled/hosts',
        require => File['/etc/apache2/sites-available/hosts']
    }

    exec { 'apache-reload':
        command => '/etc/init.d/apache2 restart',
        require => Package['apache2']
    }
}