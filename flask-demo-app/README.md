# Flask Demo App

A minimal, production-ready, containerized Flask application.

### Features
- **Main route (`/`)**: Returns "Hello, Dockerized Flask!"
- **Health check route (`/health`)**: Returns a JSON status
- **Error handling**: Custom 404 and 500 responses
- **Config**: Separate production and development settings
- **Multi-stage Docker build**: Minimal, secure, and optimized image
- **Security**: Runs as a non-root user in the container

---

### Project Structure
```
flask-demo-app/
├── app/
│   ├── __init__.py
│   └── routes.py
├── Dockerfile
├── requirements.txt
├── .dockerignore
├── README.md
└── docker-compose.yml  # (optional, for local dev)
```

---

### Docker & Usage Instructions

**Build the Docker image:**
```bash
docker build -t avivdani/flask-demo .
```

**Run the container:**
```bash
docker run -d -p 5000:5000 --name flask-demo avivdani/flask-demo
```

**Push to Docker Hub:**
```bash
docker login
docker push avivdani/flask-demo
```

**Test the endpoints:**
```bash
curl http://localhost:5000/         # Hello, Dockerized Flask!
curl http://localhost:5000/health   # {"status": "healthy"}
```

**Local development with Docker Compose (optional):**
```bash
docker-compose up --build
```

---

All files are production-ready and follow current best practices for Python/Flask Docker deployments. 
You can now build, run, and push this app to Docker Hub as requested!

If you need any customizations or want to add more features, just let me know. 
