FROM node:10-alpine
MAINTAINER Cumberland Group <apps@cumberlandgroupit.com>

ARG PORT=8080
ENV PORT ${PORT}
EXPOSE ${PORT}

# Set node env to production
ENV NODE_ENV production

# Copy application to image
COPY . /app

# Change to /app
WORKDIR /app

# Install project libs (alpine specific)
RUN apk add --no-cache --virtual .build-deps alpine-sdk python \
 && npm install --production \
 && apk del .build-deps

# Start node app
CMD node app.js
