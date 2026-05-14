FROM node:7.8.0
WORKDIR /opt
ADD . /opt
ENV REACT_APP_BRANCH=$BRANCH_NAME

RUN npm run build
ARG BRANCH_NAME

RUN npm install
ENTRYPOINT npm run start
