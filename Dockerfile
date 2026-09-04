# --------------------------------------------------------------------
# Stage 1: Build stage (compiles Odin code with SQLite)
# --------------------------------------------------------------------

FROM sendo2003/odin:dev-2026-08 AS builder

# Install C build tools and SQLite header libraries needed by Odin 
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev

WORKDIR /app

# Copy your source code
COPY src/ ./src/

# Build the ygg binary
RUN odin build src/ -out:ygg -o:speed

# --------------------------------------------------------------------
# Stage 2: Runtime stage (minimal runner)
# --------------------------------------------------------------------
FROM debian:bookworm-slim

# Install runtime SQLite library
RUN apt-get update && apt-get install -y \
    sqlite3 \
    libsqlite3-0  \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create directory where SQLite database file will live 
RUN mkdir -p /data

# Copy compiled binary from builder stage
COPY --from=builder /app/ygg /app/ygg

# Set execution entrypoint 
ENTRYPOINT ["/app/ygg"]


