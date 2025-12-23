set -e

nginxversion=1.27.4
USERNAME='Sanders-74'
IMAGE_NAME="ghcr.io/${USERNAME,,}/nginxstub:${nginxversion}"

# Check if the token variable is set
if [ -z "$GITHUBTOKEN" ]; then
    echo "Error: GITHUBTOKEN environment variable is not set."
    exit 1
fi
docker buildx build --load --build-arg "NGINX_VERSION=$nginxversion" -t nginxstub:${nginxversion} .
docker login ghcr.io -u ${USERNAME} -p=${GITHUBTOKEN}
if [ $? -ne 0 ]; then
    echo "Error: Docker login failed. Check your token and permissions."
    exit 1
fi
docker tag nginxstub:${nginxversion} ${IMAGE_NAME}
docker push ${IMAGE_NAME}