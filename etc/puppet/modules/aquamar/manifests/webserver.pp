class aquamar::webserver {

# ==============================================================================
# self-signed SSL certificate

ssl::self_signed_certificate { 'aquamar.trofa.inet':
    common_name      => 'aquamar.trofa.inet',
    email_address    => 'kulhanek.petr@gmail.com',
    country          => 'CZ',
    organization     => 'TROFA',
    unit             => 'KULHANEK',
    days             => 3650,
    directory        => '/etc/ssl/web',
    subject_alt_name => "DNS:aquamar.trofa.inet",
    owner            => 'www-data',
    group            => 'www-data',
    notify           => Service['apache2'],
}

# ==============================================================================
# server

    class { 'apache':
        default_vhost   => false,
        serveradmin     => 'support@lcc.ncbr.muni.cz',
        mpm_module      => 'prefork',                   # required by apache::mod::php
    }

    class { 'apache::mod::php': }

# ==============================================================================
# non-ssl connections will be redirected to ssl version

    apache::vhost { 'aquamar-non-ssl':
        servername      => 'aquamar.trofa.inet',
        port            => '80',
        docroot         => '/opt/aquamar/1.0/var/html/no-ssl',

    # access for www-data is set via Posix ACL
        docroot_owner   => 'pi',
        docroot_group   => 'www-data',

    # redirect
        redirect_status => 'permanent',
        redirect_dest   => "https://${::ipaddress}/",

    # permissions
        directories => [
        # root
            {   path              => '/',
                allow_override    => 'none',
                require           => 'all denied',
            }
        ] 

    }

# ==============================================================================
# ssl version of web contents

    apache::vhost { 'aquamar-ssl':
        servername => 'aquamar.trofa.inet',
        port       => '443',
        docroot    => '/opt/aquamar/1.0/var/html',

    # access for www-data is set via Posix ACL
        docroot_owner   => 'pi',
        docroot_group   => 'www-data',

        ssl                 => true,
        ssl_cert            => '/etc/ssl/web/aquamar.trofa.inet.crt',
        ssl_key             => '/etc/ssl/web/aquamar.trofa.inet.key',
        ssl_verify_client   => 'none',

        require             => Ssl::Self_signed_certificate['aquamar.trofa.inet'],
    }
}
