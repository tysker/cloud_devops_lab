import os

# Where to bind
bind = os.getenv("GUNICORN_BIND", "0.0.0.0:5000")

# Concurrency
workers = int(os.getenv("GUNICORN_WORKERS", "2"))
threads = int(os.getenv("GUNICORN_THREADS", "2"))

# Timeouts / keepalive
timeout = int(os.getenv("GUNICORN_TIMEOUT", "60"))
keepalive = int(os.getenv("GUNICORN_KEEPALIVE", "5"))

# Logging to container stdout/stderr
accesslog = "-"
errorlog = "-"
loglevel = os.getenv("GUNICORN_LOGLEVEL", "info")

# If behind a reverse proxy (nginx/traefik), this is often useful:
# forwarded_allow_ips = "*"
# proxy_protocol = False
