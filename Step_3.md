# Step 3 — Run and Deploy with Docker Compose

## 1. What is Docker Compose?

Docker Compose is a tool for running applications using a simple configuration file (`docker-compose.yml`).

In this project, it is used to:

* Run your Docker image as a service
* Simplify execution with one command
* Make deployment repeatable on any server

You will use it together with the Docker image you built in Step 2.

---

## 2. Docker Compose (section by section)

### Services

```yaml
services:
  service-name:
```

* `service-name` should be changed to your desired service name

---

### Image

```yaml
    image: service-name:0.0.1
```

* Change:

  * `service-name` → your project name
  * `0.0.1` → your version tag

---

### Container name

```yaml
    container_name: service-name
```

* Change this to match your service name

---

### Ports

```yaml
    ports:
      - "8000:8000"
```

* Left side: host port
* Right side: container port
* If you change FastAPI port, update both values here as well

---

### Restart policy

```yaml
    restart: unless-stopped
```

* Keeps the service running unless manually stopped

---

### Environment variables

```yaml
    environment:
      - PYTHONUNBUFFERED=1
```

* Ensures logs are shown immediately

---

### Healthcheck

```yaml
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
```

* Checks if the service is alive
* ⚠️ Important: if you change the port, update it here as well

---

## 3. Build Docker Image

```bash
docker build -t service-name:0.0.1 ./
```

* Change:

  * `service-name` → your project name
  * `0.0.1` → your version tag

---

## 4. Run Service

```bash
docker compose up -d
```

View logs:

```bash
docker compose logs -f
```

---

## 5. Stop Service

```bash
docker compose down
```

---

## 6. Save Image for Deployment

```bash
docker save -o service-name.tar.gz service-name:0.0.1
```

* Change:

  * `service-name`
  * `0.0.1`

---

## 7. Transfer to Server

```bash
scp service-name.tar.gz docker-compose.yml server-name@server-ip:project_path
```

* Replace:

  * `server-name`
  * `server-ip`
  * `project_path`

---

## 8. Connect to Server

```bash
ssh server-name@server-ip
cd project_path
```

---

## 9. Load Image on Server

```bash
docker load -i service-name.tar.gz
```

---

## 10. Run on Server

```bash
docker compose up -d && docker compose logs -f
```

---

## 11. Test Service

Open in browser:

```
http://server-ip:8000/docs
```

---

## 12. Test API with Python

```python
import requests

url = "http://server-ip:8000/endpoint_name"

data = {
    "input_var_1": 1,
    "input_var_2": "test",
    "input_var_3": {}
}

response = requests.post(url, json=data)

print(response.json())
```

---

✔️ Step 3 is complete.

Just like that, in three simple steps, we turned a Python script into a running and deployable web service.