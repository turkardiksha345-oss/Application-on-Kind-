FROM nginx:alpine

# Copy the frontend files to nginx
COPY . /usr/share/nginx/html/

# Copy custom nginx config (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
