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

# Expose port 8000 for the streamable HTTP endpoint
EXPOSE 8000

# Default command to run the MCP server via supergateway proxy
CMD ["./node_modules/.bin/supergateway", "--stdio", "node build/index.js", "--outputTransport", "streamableHttp", "--port", "8000", "--streamableHttpPath", "/fred/mcp"]