{
  "event_log": {
    "level": "ERROR",
    "destination": "/var/log/resolver/error.log"
  },
  "access_log": {
    "level": "INFO",
    "destination": "/var/log/resolver/access.log"
  },
  "server": [
    {
      "ip": "0.0.0.0",
      "port": 1053,
      "protocol": "udp",
      "count": 1,
      "tls": {
        "enable": false,
        "cert_path": "",
        "key_path": "",
        "ca_path": ""
      }
    }
  ],
  "redis_data": {
    "zone_cache_size": 10000,
    "zone_cache_timeout": 60,
    "zone_reload": 60,
    "record_cache_size": 1000000,
    "record_cache_timeout": 60,
    "redis": {
      "address": "${redis_address}:${redis_port}",
      "net": "tcp",
      "db": 0,
      "password": "",
      "prefix": "z42_",
      "suffix": "_z42",
      "connection": {
        "max_idle_connections": 10,
        "max_active_connections": 10,
        "connect_timeout": 500,
        "read_timeout": 500,
        "idle_keep_alive": 30,
        "max_keep_alive": 0,
        "wait_for_connection": false
      }
    }
  },
  "redis_stat": {
    "redis": {
      "address": "${redis_address}:${redis_port}",
      "net": "tcp",
      "db": 0,
      "password": "",
      "prefix": "z42_",
      "suffix": "_z42",
      "connection": {
        "max_idle_connections": 10,
        "max_active_connections": 10,
        "connect_timeout": 500,
        "read_timeout": 500,
        "idle_keep_alive": 30,
        "max_keep_alive": 0,
        "wait_for_connection": false
      }
    }
  },
  "handler": {
    "upstream": [
      {
        "ip": "1.1.1.1",
        "port": 53,
        "protocol": "udp",
        "timeout": 400
      }
    ],
    "geoip": {
      "enable": true,
      "country_db": "/var/z42/geoCity.mmdb",
      "asn_db": "/var/z42/geoIsp.mmdb"
    },
    "log_source_location": true
  },
  "ratelimit": {
    "enable": false,
    "burst": 10,
    "rate": 60,
    "whitelist": [],
    "blacklist": []
  }
}
