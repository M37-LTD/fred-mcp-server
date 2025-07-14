FROM node:lts-alpine

# Create app directory
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy package.json and lock files
COPY package.json pnpm-lock.yaml* ./

# Install all dependencies (including dev dependencies for building)
RUN pnpm install --ignore-scripts

# Copy source code
COPY . .

# Build the project
RUN pnpm run build

# Remove dev dependencies to reduce image size
RUN pnpm prune --prod

# Expose no ports, use stdio

# Default command to run the MCP server
CMD ["node", "build/index.js"]