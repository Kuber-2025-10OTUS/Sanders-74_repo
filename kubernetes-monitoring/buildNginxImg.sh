nginxversion=1.29.4
docker buildx build --build-arg "NGINX_VERSION=$nginxeversion" -t nginxstub:${nginxversion} .
