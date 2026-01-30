# Multi-stage build for Astro static site
FROM oven/bun:1.1.30-alpine AS base
WORKDIR /app

# Install dependencies only when needed
FROM base AS deps
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# Build the application
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN bun run build

# Production image with Nginx
FROM nginx:1.25-alpine AS runner

# Install curl for health check
RUN apk add --no-cache curl

# Copy built static files to nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration with proper headers
COPY nginx.conf /etc/nginx/nginx.conf

# Nginx already runs as nginx user, just set correct permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d

EXPOSE 4321

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:4321 || exit 1

CMD ["nginx", "-g", "daemon off;"]