FROM mirror.gcr.io/library/node:20-alpine
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production
ENV SESSION_SECRET=raneto_nexlayer_session_secret_key_2026
WORKDIR /opt
RUN npm install raneto@0.18.1 && npm cache clean --force
# Raneto computes its theme path as raneto/node_modules/@raneto/theme-default,
# but npm hoists the theme to the top-level node_modules. Make sure the theme
# resolves at the nested path Raneto expects (templates live in its dist/).
RUN set -eux; \
    mkdir -p /opt/node_modules/raneto/node_modules/@raneto; \
    if [ ! -e /opt/node_modules/raneto/node_modules/@raneto/theme-default ]; then \
      if [ -d /opt/node_modules/@raneto/theme-default ]; then \
        cp -a /opt/node_modules/@raneto/theme-default /opt/node_modules/raneto/node_modules/@raneto/theme-default; \
      fi; \
    fi; \
    ls /opt/node_modules/raneto/node_modules/@raneto/theme-default/dist/templates
WORKDIR /opt/node_modules/raneto
EXPOSE 3000
CMD ["node", "server.js"]
