FROM node:lts-alpine AS build

WORKDIR /app

COPY package*.json .
RUN npm ci
RUN npm audit fix
COPY . .
RUN npm run build


FROM nginxinc/nginx-unprivileged:stable-alpine as production-stage

COPY --from=build /app/public /usr/share/nginx/html
EXPOSE 8080
USER 101
CMD ["nginx", "-g", "daemon off;"]