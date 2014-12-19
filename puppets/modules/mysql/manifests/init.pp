class mysql {
    $bin = '/usr/bin:/usr/sbin'

    if ! defined(Package['mysql-server']) {
        package { 'mysql-server':
            ensure => 'present',
        }
    }

    if ! defined(Package['mysql-client']) {
        package { 'mysql-client':
            ensure => 'present',
        }
    }

    service { 'mysql':
        alias   => 'mysql::mysql',
        enable  => 'true',
        ensure  => 'running',
        require => Package['mysql-server'],
    }

    file { '/etc/my.cnf':
        source => 'puppet:///modules/mysql/my.cnf',
        audit  => content,
        notify  => Service["mysql"],
        require => Package['mysql-server']
    }

    file { '/tmp/create_database.sql':
        source  => 'puppet:///modules/mysql/create_database.sql',
        audit  => content,
        require => Package['mysql-server']
    }

    exec { 'create_database':
        command => 'mysql -u root < /tmp/create_database.sql',
        path    => ['/bin', '/usr/bin'],
        require => File['/tmp/create_database.sql'],
    }
}
