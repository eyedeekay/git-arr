# to build: docker build -t git-arr .
# to run: docker run --cap-drop all --name git-arr -t git-arr
FROM alpine:3.6
RUN apk update
RUN apk add git darkhttpd python py-bottle py-markdown
RUN addgroup git-arr
RUN adduser -h /home/git-arr/ -s /usr/bin/darkhttpd -D -S -G git-arr git-arr
USER git-arr
WORKDIR /home/git-arr
COPY . /usr/bin/
COPY . /home/git-arr/repo/git-arr
RUN mkdir -p /home/git-arr/www
RUN echo "[projects]" | tee -a /home/git-arr/config.conf
RUN echo "path = /home/git-arr/repo" | tee -a /home/git-arr/config.conf
RUN echo "recursive = yes" | tee -a /home/git-arr/config.conf
RUN echo "embed_markdown = yes" | tee -a /home/git-arr/config.conf
RUN echo "desc = git-arr" | tee -a /home/git-arr/config.conf
RUN git-arr --config /home/git-arr/config.conf generate --output /home/git-arr/www
USER git-arr
CMD darkhttpd /home/git-arr/www \
        --pidfile /home/git-arr/darkhttpd.pid \
        --no-server-id \
        --ipv6 \
