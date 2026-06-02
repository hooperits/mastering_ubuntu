# 🚀 Lab 12: Container Engine Deployments

## Scenario Context
Containers have revolutionized application hosting. Under the hood, container engines (like Docker or Podman) manage local bridge interfaces, volume mount abstractions, and lifecycle actions. Advanced systems engineers write automation scripts to launch containers and declare infrastructure state using orchestrators like **Docker Compose**.

Your task is to write a container runner shell script and define a standard multi-container compose file.

---

## 🎯 Lab Objectives

### 1. Write the Container Launch Script
Write a bash script at `/root/launch-container.sh` to launch a container programmatically:
- The script must create a custom Docker network bridge named `mastery-net` (using `docker network create`).
- Start an Nginx container named `web-nested` attached to the custom network `mastery-net`.
- Map host port `8080` to the container port `80` (so traffic requests route correctly).
- Use the image `nginx:alpine`.
- Run in detached background mode (`-d`).
- Ensure the script is executable (`chmod +x`).

### 2. Define the Docker Compose Infrastructure
Write a declarative YAML file at `/root/docker-compose.yml` to set up Nginx:
- Define a service (e.g. `web` or `app`).
- Set its container image to `nginx:alpine`.
- Configure the port mapping list to map host port `8080` to container port `80` (`8080:80`).
- Configure a volume mount linking the host folder `/var/www/html` to `/usr/share/nginx/html` in the container (`/var/www/html:/usr/share/nginx/html`).
- Ensure you define custom networks mapping or baseline compose parameters.

---

## 🔍 Docker & Compose Reference

### Command Line parameters syntax:
* **Create custom network**:
  ```bash
  docker network create mastery-net
  ```
* **Run a container on custom network and ports**:
  ```bash
  docker run -d --name web-nested --network mastery-net -p 8080:80 nginx:alpine
  ```

### Docker Compose YAML format template:
Write `/root/docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - /var/www/html:/usr/share/nginx/html
```

---

## 💡 How to Complete
1. Use `u-lab attach 12-containers` to enter the container.
2. Create `/root/launch-container.sh` containing the network and container execution commands, and make it executable.
3. Write the `/root/docker-compose.yml` configuration mapping ports and volumes.
4. Exit the container and run `u-lab check 12-containers` to verify.
