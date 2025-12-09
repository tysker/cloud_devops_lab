# Step 1 - Build environment
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 2 - Runtime environment
FROM python:3.12-slim

WORKDIR /app

# Create non-root user for security
RUN useradd -ms /bin/bash appuser

# Install curl for healthcheck and delete cached metadata from apt update
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy dependencies from builder
COPY --from=builder /usr/local /usr/local

# Copy application
COPY src ./src

RUN chown -R appuser:appuser /app

# Switch user
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Production command using Gunicorn
CMD ["gunicorn", "--chdir", "src", "app:app", "--bind", "0.0.0.0:5000"]

