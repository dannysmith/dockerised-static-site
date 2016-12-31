# Install nginx to use as reverse proxy load balancer
sudo apt-get update
sudo apt-get -y install nginx

# Allow incoming traffic and forwarded ports
sudo ufw default deny incoming
sudo ufw default allow forward
sudo ufw allow in 80

# Add a new nginx config file to handle proxying.
cat > /etc/nginx/nginx.conf <<'EOL'
events { worker_connections 1024; }
http {
    sendfile on;

    # List of application servers
    upstream app_servers {
        server 127.0.0.1:8081;
        server 127.0.0.1:8082;
        server 127.0.0.1:8083;
    }
    # Configuration for the server
    server {
        # Running port
        listen 80;

        # Proxying the connections connections
        location / {

            proxy_pass         http://app_servers;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host $server_name;

        }
    }
}
EOL

export DOCKER_INSTANCES=3

#Launch containers for the number of instances defined in DOCKER_INSTANCES.
COUNTER=1
while [  $COUNTER -le $DOCKER_INSTANCES ]; do
    PORT=$((8000+COUNTER))
    NAME="web$COUNTER"
    echo "docker run -d -p $PORT:80 --name $NAME dannysmith/dockerised-static-site"
    let COUNTER=COUNTER+1
done

# Start nginx reverse proxy
service nginx start

echo
echo 'Running containers'
echo '------------------'
docker ps
