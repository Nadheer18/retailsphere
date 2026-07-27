**Yes.** This work should be done on your **developer machine**, not on the Kubernetes control plane.

The backend source code (`pom.xml`, `application.yml`, Java code) belongs in your development environment. The cluster should only run the built application.

## Workflow

### 1. Go to your Developer Server

This is where your RetailSphere Spring Boot project lives.

```bash
cd ~/retailsphere/backend
```

(or the directory where your Spring Boot source code is located)

---

### 2. Modify the application

We'll edit:

```
backend/
├── pom.xml
└── src/
    └── main/
        └── resources/
            └── application.yml
```

Specifically:

* `pom.xml`

  * Add Spring Boot Actuator (if missing)
  * Add Micrometer Prometheus Registry (if missing)

* `application.yml`

  * Enable Actuator endpoints
  * Enable Prometheus metrics

---

### 3. Build the application

```bash
mvn clean package
```

---

### 4. Build a new Docker image

For example:

```bash
docker build -t nadheer/retailsphere-backend:v2 .
```

---

### 5. Push to Docker Hub

```bash
docker push nadheer/retailsphere-backend:v2
```

---

### 6. Update your Helm values

On your infrastructure/control-plane machine, update the backend image tag in your Helm values, for example:

```yaml
backend:
  image:
    repository: nadheer/retailsphere-backend
    tag: v2
```

Then upgrade the release:

```bash
helm upgrade retailsphere ./helm/retailsphere -n retailsphere
```

---

### 7. Verify

Finally, we'll create the `ServiceMonitor` and confirm Prometheus is scraping the `/actuator/prometheus` endpoint.

---

## Since I Know Your Project

You've previously completed:

* ✅ Spring Boot application
* ✅ Dockerization
* ✅ Helm packaging
* ✅ GitOps

So we should **modify the source code on the developer machine**, then rebuild and redeploy. This follows the same development workflow you've used throughout the RetailSphere project.

### Next Step

On your **developer machine**, please run:

```bash
cd ~/retailsphere/backend

grep "<artifactId>" pom.xml
```

and

```bash
cat src/main/resources/application.yml
```

Paste both outputs here. I'll tell you exactly what needs to be added without changing anything unnecessarily.
