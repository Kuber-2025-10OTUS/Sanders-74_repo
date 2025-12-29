# Этап 1: Сборка
FROM alpine:latest AS builder

RUN apk add --no-cache build-base openssl-dev wget linux-headers gd-dev

WORKDIR /src

# Актуальные версии на конец 2025 года
ENV NGINX_VERSION=1.27.4
ENV PCRE_VERSION=8.45
ENV ZLIB_VERSION=1.3.1

# Скачивание с исправленными ссылками
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz  && tar -xzf nginx-${NGINX_VERSION}.tar.gz

# Используем официальное зеркало SourceForge для PCRE
RUN wget https://altushost-swe.dl.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz \
    && tar -xzf pcre-${PCRE_VERSION}.tar.gz

# Используем официальный сайт zlib
RUN wget https://zlib.net/zlib-1.3.1.tar.gz \
    && tar -xzf zlib-${ZLIB_VERSION}.tar.gz

WORKDIR /src/nginx-${NGINX_VERSION}

# Статическая сборка: библиотеки PCRE и Zlib будут ВНУТРИ файла /usr/sbin/nginx
RUN ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --with-pcre=/src/pcre-${PCRE_VERSION} \
    --with-zlib=/src/zlib-${ZLIB_VERSION} \
    --with-http_stub_status_module \
    && make -j$(nproc) \
    && make install

# Этап 2: Финальный образ
FROM alpine:latest

# libc6-compat нужен для совместимости бинарников в Alpine
RUN apk add --no-cache libc6-compat

# Копируем самодостаточный бинарник и конфигурацию
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /etc/nginx /etc/nginx

# Подготовка окружения
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/lib/nginx/tmp

# Эта команда проверит, что зависимость от libpcre.so исчезла
RUN ldd /usr/sbin/nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
