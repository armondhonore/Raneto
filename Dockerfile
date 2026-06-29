FROM mirror.gcr.io/library/node:20-alpine
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production
WORKDIR /opt
RUN npm install raneto@0.18.1 && npm cache clean --force
WORKDIR /opt/node_modules/raneto
EXPOSE 3000
CMD ["node", "server.js"]
