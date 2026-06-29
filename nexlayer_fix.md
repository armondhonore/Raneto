# Nexlayer Fix

## Fixed Dockerfile

```dockerfile
FROM mirror.gcr.io/library/node:20-alpine
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production
ENV SESSION_SECRET=raneto_nexlayer_session_secret_key_2026
WORKDIR /opt
RUN npm install raneto@0.18.1 && npm cache clean --force
WORKDIR /opt/node_modules/raneto
EXPOSE 3000
CMD ["node", "server.js"]
```

## Fixed nexlayer.yaml

```yaml
application:
  name: raneto
  pods:
  - name: app
    image: "# filled by pipeline"
    path: /
    servicePorts:
    - 3000
    vars:
      HOST: "0.0.0.0"
      PORT: "3000"
      NODE_ENV: production
      SESSION_SECRET: "raneto_nexlayer_session_secret_key_2026"
```

## Notes

Raneto is a Node/Express markdown knowledgebase. It is file-based — the npm package ships its own `content/` directory, so no database is required.

Root cause of the 503:
- The previous Dockerfile ran `CMD ["raneto"]`, but the `raneto` npm package has NO executable (`"bin": "none"`). The container exited immediately with "command not found".
- Raneto's real entrypoint is `node server.js` (the package `start` script), run from inside the installed package directory (it uses relative ESM imports).
- Raneto binds to `process.env.HOST || '127.0.0.1'` and `process.env.PORT || 8080`. Defaulting to `127.0.0.1` means the platform probe (which hits the pod IP) cannot reach it → 502, and the default port 8080 mismatched the route's port 3000.

Fixes:
- Install `raneto@0.18.1` and start it with `node server.js` from `/opt/node_modules/raneto`.
- Set `HOST=0.0.0.0` (bind to all interfaces so the pod is reachable) and `PORT=3000` (match the service port).

Do NOT regenerate this Dockerfile or nexlayer.yaml — they are pinned.
