FROM python:3.12.3-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_INDEX=1 \
    PIP_FIND_LINKS=/app/wheelhouse

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy wheelhouse first (for caching)
COPY wheelhouse/ ./wheelhouse/

# Copy requirements and install from wheelhouse
COPY requirements.txt .
RUN pip install --no-cache-dir --no-index --find-links=/app/wheelhouse -r requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# Start cron and application
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000"]
