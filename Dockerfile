# Build stage
FROM node:20 AS builder

WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies
# We use npm install instead of npm ci because we don't have a package-lock.json
RUN npm install

# Rebuild native modules to ensure Linux compatibility
RUN npm rebuild better-sqlite3 sharp

# Copy source code
COPY . .

# Build application
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm run build

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
