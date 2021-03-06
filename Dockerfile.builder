FROM node:12-alpine AS BUILDER
COPY app /app
WORKDIR /app
ENV PUBLIC_URL=/static
RUN npm install &&\
	npm run build &&\
	rm -f `find ./build -name *.map`

FROM golang:1.12.9 AS GOLANG
ENV GOPATH=/app
ENV MG_WORK_DIR=/app/src/github.com/mageddo/dns-proxy-server
LABEL dps.container=true
WORKDIR /app/src/github.com/mageddo/dns-proxy-server
COPY --from=BUILDER /app/build /static
COPY ./builder.bash /bin/builder.bash
