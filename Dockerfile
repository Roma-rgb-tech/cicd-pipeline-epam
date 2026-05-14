FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install
RUN npm run build
ARG BRANCH_NAME
ENV REACT_APP_BRANCH=$BRANCH_NAME
ENTRYPOINT npm run start
