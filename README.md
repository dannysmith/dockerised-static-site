# Basic Website

To build an image locally and push to dockerhub:

```shell
docker build -t dannysmith/dockerised-static-site .
docker push dannysmith/dockerised-static-site
```

To run three instances on a server (SSH'd into the server):

```shell
docker run -d -p 8081:80 --name web1 dannysmith/dockerised-static-site
docker run -d -p 8082:80 --name web2 dannysmith/dockerised-static-site
docker run -d -p 8083:80 --name web3 dannysmith/dockerised-static-site
```

To use nginx to load balance between them, install it and add a `nginx.conf` file... See `provision.sh` for more.

Remember to [enable firewall forwarding](https://www.digitalocean.com/community/tutorials/docker-explained-how-to-containerize-and-use-nginx-as-a-proxy#installation-instructions-for-ubuntu) by changing `DEFAULT_FORWARD_POLICY=` in `sudo nano /etc/default/ufw` from `DROP` to `ACCEPT` (or use `$> sudo ufw default allow forward`).
