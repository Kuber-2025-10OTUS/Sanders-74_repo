# Используем базовый образ с инструментами для сборки
FROM alpine:latest AS builder

# Устанавливаем зависимости для сборки
RUN apk add --no-cache build-base pcre-dev zlib-dev 
# libssl-dev

# Скачиваем и распаковываем исходники Nginx
ENV NGINX_VERSION=1.29.4
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar -xvf nginx-${NGINX_VERSION}.tar.gz \
    && rm nginx-${NGINX_VERSION}.tar.gz

WORKDIR /nginx-${NGINX_VERSION}

# Конфигурируем сборку с нужным модулем
RUN ./configure \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_stub_status_module \
    && make \
    && make install

# --with-http_ssl_module \    

# Создаем финальный образ
FROM alpine:latest

# Копируем собранные бинарники Nginx и конфигурационные файлы
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
#COPY --from=builder /usr/lib/nginx/modules /usr/lib/nginx/modules
COPY --from=builder /etc/nginx/nginx.conf /etc/nginx/nginx.conf
# Добавляем стандартные директории для логов и темп-файлов, если их нет
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/lib/nginx/tmp /var/lib/nginx/tmp/client_body /var/lib/nginx/tmp/proxy

# Копируем кастомный конфиг (если есть) или используем стандартный
# Можно добавить: COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
