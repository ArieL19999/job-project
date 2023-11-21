FROM nginx:latest

COPY nginx.conf /etc/nginx/conf.d/

COPY index.html /usr/share/nginx/html/index.html

# Expose to port 80
EXPOSE 80
