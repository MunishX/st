[Unit]
Description=Redis Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server___sfx___ /etc/redis___sfx___/redis.conf
ExecStop=/usr/local/bin/redis-cli___sfx___ shutdown
Restart=always

[Install]
WantedBy=multi-user.target
