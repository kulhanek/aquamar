class aquamar::packages {

# standard packages ------------------------------
    $pkglst = [ 
            'vim',
            'mc',
            'git',
            ];

    package { $pkglst:
        ensure => installed,
    }

# vim configuration ------------------------------

    file { '/root/.vimrc':
        source => 'puppet:///modules/aquamar/vimrc',
        owner => 'root',
        group => 'root',
        mode => '640',
    }

    file { '/home/pi/.vimrc':
        source => 'puppet:///modules/aquamar/vimrc',
        owner => 'pi',
        group => 'pi',
        mode => '640',
    }

}

