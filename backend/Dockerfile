FROM node:20-alpine

# Update OS packages
RUN apk update && apk upgrade

# Create non-root user (security best practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

COPY . .

# Change ownership
RUN chown -R appuser:appgroup /app

# Run as non-root
USER appuser

EXPOSE 5000

CMD ["npm", "start"]
