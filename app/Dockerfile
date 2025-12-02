# Step 1 - Build environment
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Step 2 - Runtime environment
FROM python:3.12-slim
WORKDIR /app

# Create non-root user
RUN useradd -ms /bin/bash appuser

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY src ./src

# Switch user
USER appuser

EXPOSE 5000
CMD ["gunicorn", "--chdir", "src", "app:app", "--bind", "0.0.0.0:5000"]

