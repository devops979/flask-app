
FROM python:3.13-slim

# Install basic troubleshooting tools
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    iputils-ping \
    net-tools \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r flaskuser && useradd -r -g flaskuser flaskuser

# Create application directory and set permissions
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
COPY . .

# Change ownership of the application directory
RUN chown -R flaskuser:flaskuser /app

# Switch to non-root user
USER flaskuser

EXPOSE 5000

CMD ["python", "app.py"]
