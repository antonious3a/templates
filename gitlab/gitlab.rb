external_url "https://gitlab.antonio3a.net:443"
registry_external_url "https://registry.antonio3a.net:443"

nginx['enable'] = true
nginx['client_max_body_size'] = '500m'
nginx['redirect_http_to_https'] = true
nginx['redirect_http_to_https_port'] = 80
nginx['ssl_certificate'] = "/etc/gitlab/ssl/antonio3a.net/fullchain1.pem"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/antonio3a.net/privkey1.pem"
nginx['ssl_ciphers'] = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
nginx['ssl_protocols'] = "TLSv1.2 TLSv1.3"
nginx['listen_addresses'] = ['*', '[::]']
nginx['gzip_enabled'] = true
nginx['listen_port'] = 443
nginx['listen_https'] = true

registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/antonio3a.net/fullchain1.pem"
registry_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/antonio3a.net/privkey1.pem"

logging['logrotate_frequency'] = "daily"
logging['logrotate_rotate'] = 3
logging['logrotate_compress'] = "compress"

