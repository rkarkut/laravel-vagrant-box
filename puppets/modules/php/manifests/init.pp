class php {

  package { ['php5','php5-cli','libapache2-mod-php5','php-apc','php5-curl','php5-gd','php5-imagick','php5-imap','php5-mcrypt','php5-mysql','php5-pspell','php5-tidy','php5-xdebug','php5-xmlrpc','php5-xsl']:
    ensure  => latest,
    require => [ Exec['apt-get update']]
  }

  package { ['php-mail','php-mail-mime','php-mail-mimedecode','php-net-smtp','php-auth-sasl','phpunit']:
    ensure  => installed,
    require => [ Exec['apt-get update']]
  }

    $php_changes = [
        'set PHP/error_reporting "E_ALL | E_STRICT"',
        'set PHP/display_errors On',
        'set PHP/display_startup_errors On',
        'set PHP/html_errors On',
        'set PHP/log_errors On',
        'set PHP/error_log /logs/php.log',
        'set PHP/short_open_tag On',
        "set Date/date.timezone Europe/Warsaw",
        'set PHP/memory_limit 128M',
        'set PHP/post_max_size 256M',
        'set PHP/upload_max_filesize 256M',
    ]

    augeas { "php5_cli" :
        context => "/files/etc/php5/cli/php.ini",
        changes => $php_changes,
        require => Package["php5-cli"],
    }

    augeas { "php5_apache2" :
        context => "/files/etc/php5/apache2/php.ini",
        changes => $php_changes,
        require => Package["php5"]
    }
}