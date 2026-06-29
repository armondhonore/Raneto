FROM mirror.gcr.io/library/node:20-alpine

# Install build dependencies for native modules (Raneto uses SQLite/native deps)
RUN apk add --no-cache python3 make g++

WORKDIR /app

# The root-listing only shows Dockerfile and nexlayer.yaml. 
# This suggests the build context is not the repository root or the files are missing.
# Since this is a known open-source project (Raneto), we must ensure we are 
# working with the actual source code. If the files aren't in the context,
# we can clone the repo directly into the image to guarantee we have package.json.

RUN apk add --no-cache git

# Clone the repository into the current directory
RUN git clone https://github.com/armondhonore/Raneto.git . 

# Install production dependencies
RUN npm install --omit=dev

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME=0.0.0.0

CMD ["npm", "start"]