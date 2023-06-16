{
  "event_log": {
    "level": "ERROR",
    "destination": "/var/log/updater/error.log"
  },
  "db_connection_string": "${database_user}:${database_password}@tcp(${database_address}:${database_port})/z42",
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
  }
}
