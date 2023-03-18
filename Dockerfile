FROM nginx

USER root

RUN mkdir /var/www/

COPY hello.txt /var/www/
