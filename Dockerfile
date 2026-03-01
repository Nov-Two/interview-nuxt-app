# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build application
RUN pnpm run build

# Runtime stage
FROM node:20-slim

WORKDIR /app

# Copy output from builder
COPY --from=builder /app/.output ./.output

# Set environment variables
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000
ENV NODE_ENV=production

# Expose port
EXPOSE 3000

# Start application
CMD ["node", ".output/server/index.mjs"]
