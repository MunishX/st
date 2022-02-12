[Unit]
Description=Advanced key-value store
After=network.target
Documentation=https://docs.keydb.dev, man:keydb-server(1)

[Service]
Type=forking
ExecStart=/usr/local/bin/keydb-server___sfx___ /etc/keydb___sfx___/keydb.conf
ExecStop=/bin/kill -s TERM $MAINPID
PIDFile=/var/run/keydb___sfx___/keydb-server.pid
TimeoutStopSec=0
Restart=always
User=keydb
Group=keydb
RuntimeDirectory=keydb___sfx___
RuntimeDirectoryMode=2755

UMask=007
PrivateTmp=yes
LimitNOFILE=65535
PrivateDevices=yes
ProtectHome=yes
ReadOnlyDirectories=/
ReadWriteDirectories=-/var/lib/keydb___sfx___
ReadWriteDirectories=-/var/log/keydb___sfx___
ReadWriteDirectories=-/var/run/keydb___sfx___

NoNewPrivileges=true
CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX

# keydb-server can write to its own config file when in cluster mode so we
# permit writing there by default. If you are not using this feature, it is
# recommended that you replace the following lines with "ProtectSystem=full".
ProtectSystem=true
ReadWriteDirectories=-/etc/keydb

[Install]
WantedBy=multi-user.target
