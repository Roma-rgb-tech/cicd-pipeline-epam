FROM node:7.8.0
WORKDIR /opt
ADD . /opt
ENV PORT=3005
RUN npm install
ENTRYPOINT npm run start
