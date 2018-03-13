FROM jguyomard/hugo-builder AS build

WORKDIR /usr/src/
COPY . /usr/src/
RUN hugo 


FROM nginx:1.13.9-alpine
COPY --from=build /usr/src/public /usr/share/nginx/html/
