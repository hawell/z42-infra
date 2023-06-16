{
  "db_connection_string": "${database_user}:${database_password}@tcp(${database_address}:${database_port})/z42",
  "event_log": {
    "level": "WARNING",
    "destination": "/var/log/api/error.log"
  },
  "access_log": {
    "level": "INFO",
    "destination": "/var/log/api/access.log"
  },
  "server": {
    "bind_address": "0.0.0.0:3000",
    "max_body_size": 1000000,
    "web_server": "www.zone-42.com",
    "api_server": "api.zone-42.com",
    "name_server": "ns.zone-42.com.",
    "html_templates": "/var/z42/templates/*.tmpl",
    "recaptcha_secret_key": "${recaptcha_secret_key}",
    "recaptcha_server": "https://www.google.com/recaptcha/api/siteverify"
  },
  "mailer": {
    "address": "email-smtp.eu-west-3.amazonaws.com:465",
    "from_email": "noreply@mail.zone-42.com",
    "web_server": "www.zone-42.com",
    "api_server": "api.zone-42.com",
    "name_server": "ns.zone-42.com.",
    "html_templates": "/var/z42/templates/*.tmpl",
    "auth": {
      "username": "${email_user}",
      "password": "${email_password}"
    }
  },
  "upstream": [
    {
      "ip": "1.1.1.1",
      "port": 53,
      "protocol": "udp",
      "timeout": 2000
    }
  ]
}
