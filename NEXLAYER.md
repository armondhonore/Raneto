# Nexlayer — Raneto

<!-- nexlayer:meta version=1 analyzed=2026-06-29T20:10:50Z repo=https://github.com/armondhonore/Raneto branch=nexlayer -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
Raneto is a lightweight, open-source wiki engine designed for simplicity and ease of deployment, providing a structured way to organize and display documentation.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| PHP | language | 8.x | Dockerfile |
| Apache | infra | 2.4 | Dockerfile |
| SQLite | database | 3 | Dockerfile |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- root/ — Application source and configuration
- Dockerfile — Container definition for the PHP/Apache environment
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
_No external services detected._
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js >= 16
- npm

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
PORT=3000
NODE_ENV=development
```

### Steps

1. `npm install` — Install project dependencies
2. `npm start` — Launch the Raneto server on http://localhost:3000

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `ROOT_URL` | `"<% URL %>"` | plain |
| `app` | `MONGO_URL` | `"mongodb://mongo.pod:27017/raneto"` | plain |
| `app` | `PORT` | `"3000"` | plain |
| `raneto-mongo-data` | `size` | `10Gi` | plain |
| `raneto-mongo-data` | `mountPath` | `/data/db` | plain |

### nexlayer.yaml

```yaml
application:
  name: raneto
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/raneto:9f152d0-fix2"
      path: /
      servicePorts:
        - 3000
      vars:
        ROOT_URL: "<% URL %>"
        MONGO_URL: "mongodb://mongo.pod:27017/raneto"
        PORT: "3000"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars: {}
      volumes:
        - name: raneto-mongo-data
          size: 10Gi
          mountPath: /data/db
```
<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| raneto-app | mirror.gcr.io/library/node:20-alpine | 3000 | web |
| raneto-db | mirror.gcr.io/library/postgres:16-alpine | 5432 | database |

### Deployment notes

- While Raneto defaults to SQLite, the Nexlayer topology mandates a separate database pod for persistence.
- The application communicates with the database via raneto-db.pod:5432.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-29T21:12:35Z  
**Live URL:** https://relaxed-weasel-raneto.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: raneto
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/raneto:9f152d0-fix2"
      path: /
      servicePorts:
        - 3000
      vars:
        ROOT_URL: "<% URL %>"
        MONGO_URL: "mongodb://mongo.pod:27017/raneto"
        PORT: "3000"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars: {}
      volumes:
        - name: raneto-mongo-data
          size: 10Gi
          mountPath: /data/db
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-29T20:58:36Z | analyzed | initial repo analysis |
| 2026-06-29T21:12:35Z | success | deployed https://relaxed-weasel-raneto.cloud.nexlayer.ai |
<!-- nexlayer:end -->






