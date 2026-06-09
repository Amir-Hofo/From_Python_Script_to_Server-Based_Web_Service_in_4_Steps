# From Python Script to Server-Based Web Service in 4 Steps

This project is a minimal and practical guide to turning a simple Python script into a running web service. The goal is not to build a production-ready system, but to show how quickly a basic FastAPI application can be containerized with Docker and deployed as a service on a server. By the end, you will have a working API that runs inside a Docker container and can be accessed like a real backend service.

## Step 1 — Create a Simple FastAPI Web Service

First, install the required packages:

```bash
pip install fastapi uvicorn
```

FastAPI is a lightweight framework for building APIs, and Uvicorn is a server that runs the application.

### 1. Create your main file

Create a file named `main.py`. This file will contain your web service logic. You can import your existing Python code here:

```python
from your_code_file_name import your_class_or_function
```

### 2. Initialize FastAPI app

```python
from fastapi import FastAPI

app = FastAPI()
```

This creates your web application instance.

### 3. Create your first endpoint (test route)

```python
@app.get("/")
def root():
    return {"status": "ok"}
```

This endpoint is mapped to:

http://localhost:8000/

When you open this URL, the function runs and returns a response.

### 4. Create a POST endpoint with input data

```python
from pydantic import BaseModel

class DataInput(BaseModel):
    input_var_1: int
    input_var_2: str
    input_var_3: dict

@app.post("/endpoint_name")
def endpoint_name(data: DataInput):
    response = your_function(
        data.input_var_1,
        data.input_var_2,
        data.input_var_3
    )
    return {"result": response}
```

FastAPI automatically validates and parses incoming JSON data.

### 5. Run your service locally

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

- 8000 is the port number (can be changed)
- 0.0.0.0 allows external access (important for server deployment)

🎉 congratulations — you have just created your first web service with very little effort.

### 6. Test your API

After running the server, open:

http://127.0.0.1:8000/docs

This opens Swagger UI where you can:
- View endpoints
- Test APIs
- Send requests interactively

In Swagger UI, each endpoint you defined in your FastAPI application is automatically listed and documented. You can click on any endpoint to see its details and interact with it.

For testing, click on the "Try it out" button. This will open an input form where you can enter the request data based on the structure you defined in your Pydantic model, then execute the request and see the response.



✔️ Step 1 is complete. Now it's time to move on to Step 2

[Step_2.md](Step_2.md)