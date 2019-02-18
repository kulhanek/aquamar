class aquamar::network {

# SETUP SETUP SETUP
# ------------------------------------------------
    $host = 'aquamar'
    $domain = 'trofa.inet'
# ------------------------------------------------
# SETUP SETUP SETUP


# correct hosts files are required by perun
# hostname -f must return FQDN of the machine

# /etc/hosts -------------------------------------

    $ip = $::ipaddress

    resources { 'host': purge => true }

    host { "${host}.${domain}":
        ip              =>  "$ip",
        host_aliases    =>  "$host",
        ensure          =>  'present',
    }

}
