
git clone https://github.com/Kristof95/example-app.git

groupadd node-demo
useradd -d /example-app -s "/bin/false" -g node-demo node-demo

chown -R "node-demo:node-demo" /example-app

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
cd example-app && sudo pm2 start app.js