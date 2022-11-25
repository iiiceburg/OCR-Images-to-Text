# stage 1
FROM node:16-alpine3.15 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY . .

#RUN npm ci --loglevel verbose
RUN npm install
RUN npm run build

# stage 2
FROM nginx:1.21.0-alpine
WORKDIR /etc/nginx/conf.d
RUN rm -rf ./*
COPY ./conf.d .
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/build .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]