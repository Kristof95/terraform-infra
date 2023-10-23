
git clone https://github.com/Kristof95/example-app.git

groupadd node-demo
useradd -d /home/ubuntu/example-app -s "/bin/false" -g node-demo node-demo

chown -R "node-demo:node-demo" /home/ubuntu/example-app

echo '''user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}
http {
    server {
        listen 80;
        location / {
            proxy_pass http://localhost:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}''' > /tmp/nginx.conf

sudo cat /tmp/nginx.conf > /etc/nginx/nginx.conf

sudo systemctl restart nginx && sudo systemctl status nginx
cd /home/ubuntu/example-app || true
sudo npm install --save || true
sudo chown -R "node-demo:node-demo" /home/ubuntu/example-app || true

echo '''[Service]
ExecStart=/usr/bin/nodejs /home/ubuntu/example-app
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=node-demo
User=node-demo
Group=node-demo
Environment=NODE_ENV=production

[Install]
WantedBy=multi.user.target''' > /tmp/node-demo.service
sudo cat /tmp/node-demo.service > /etc/systemd/system/node-demo.service

sudo systemctl enable node-demo
sudo systemctl start node-demo