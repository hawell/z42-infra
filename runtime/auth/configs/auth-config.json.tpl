{
  "server": {
    "bind_address": "0.0.0.0:3002",
    "max_body_size": 1000000,
    "web_server": "auth.chordsoft.org",
    "html_templates": "/var/cs/templates/*.tmpl",
    "recaptcha": {
      "secret_key": "${recaptcha_secret_key}",
      "server": "https://www.google.com/recaptcha/api/siteverify"
    }
  },
  "mailer": {
    "address": "email-smtp.eu-west-3.amazonaws.com:465",
    "from_email": "noreply@mail.chordsoft.org",
    "web_server": "chordsoft.org",
    "html_templates": "/var/cs/templates/*.tmpl",
    "auth": {
      "username": "${email_user}",
      "password": "${email_password}"
    }
  },
  "database": {
    "connection_string": "${database_user}:${database_password}@tcp(${database_address}:${database_port})/auth"
  },
  "logger": {
    "access": {
      "level": "INFO",
      "destination": "/var/log/api/access.log"
    },
    "event": {
      "level": "WARNING",
      "destination": "/var/log/api/error.log"
    }

  }
}
