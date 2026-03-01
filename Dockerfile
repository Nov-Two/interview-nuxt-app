# Build stage
FROM node:20 AS builder

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Rebuild native modules to ensure Linux compatibility
RUN pnpm rebuild better-sqlite3 sharp

# Copy source code
COPY . .

# Build application
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN pnpm run build

# Runtime stage
FROM node:20

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
