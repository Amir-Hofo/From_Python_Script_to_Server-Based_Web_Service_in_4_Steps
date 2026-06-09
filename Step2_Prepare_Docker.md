# Step 2 — Prepare Docker Setup for FastAPI Service

Before creating a Docker container, make sure all external Python dependencies are properly managed.

## 1. Define dependencies

For any non-built-in Python package, you should first check its installed version:

```bash
pip show package-name
```

Then write it inside `requirements.txt` in this format:

```
package-name==version
```

This ensures your environment is reproducible and stable across different systems.

## 2. Create a wheelhouse (offline-friendly dependencies)

A `wheelhouse` is a folder that stores pre-downloaded Python packages.  
This allows you to install dependencies without re-downloading them again, which is especially useful for servers with limited or no internet access.

To create it, run:

```bash
pip wheel --wheel-dir=wheelhouse -r requirements.txt
```

## 3. What is Docker?

Docker is a platform that allows you to package your application and all its dependencies into a single isolated unit called a container.

- Image: A snapshot of your application (code + dependencies + environment)
- Container: A running instance of an image

This ensures your application runs the same way on any system.

## 4. Install Docker

<details>
<summary>Set up Docker's apt repository (click to expand)</summary>

```bash
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```

Install Docker packages:

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Check status:

```bash
sudo systemctl status docker
```

Start Docker if needed:

```bash
sudo systemctl start docker
```

Test installation:

```bash
sudo docker run hello-world
```

</details>




## 5. Create a Dockerfile

Now we package the application into a Docker image using a `Dockerfile`.

### 1. Base image

```dockerfile
FROM python:3.12.3-slim
```

We start from a lightweight Python image.
*You can change the Python version based on your project needs.*

---

### 2. Environment variables

```dockerfile
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_INDEX=1 \
    PIP_FIND_LINKS=/app/wheelhouse
```

These settings make Python execution cleaner and ensure pip installs from the local wheelhouse.

---

### 3. Working directory

```dockerfile
WORKDIR /app
```

All commands will run inside `/app`.

---

### 4. System dependencies

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*
```

Install minimal OS tools needed inside the container.

---

### 5. Copy wheelhouse

```dockerfile
COPY wheelhouse/ ./wheelhouse/
```

We bring pre-downloaded dependencies into the image.

---

### 6. Install Python dependencies

```dockerfile
COPY requirements.txt .
RUN pip install --no-cache-dir --no-index --find-links=/app/wheelhouse -r requirements.txt
```

Install all Python packages from the wheelhouse instead of downloading them again.

---

### 7. Copy application code

```dockerfile
COPY . .
```

Add your FastAPI project files into the container.

---

### 8. Expose port

```dockerfile
EXPOSE 8000
```

Defines the port that the service will listen on.
*You can change this port depending on your deployment setup.*

---

### 9. Health check

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1
```

Checks if the service is running correctly inside the container.
*Make sure the port matches the one defined in EXPOSE.*

---

### 10. Start command

```dockerfile
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000"]
```

This is the command that runs the FastAPI server when the container starts.
*Make sure the port matches the one defined in EXPOSE.*



✔️ Step 2 is complete. Now it's time to move on to Step 3

[Step_3.md](Step_3.md)