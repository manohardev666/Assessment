FROM golang:alpine as temp

LABEL  Manohar Guri manohardevops1@gmail.com

RUN mkdir /app
ADD go.mod main.go /app/
WORKDIR /app/
RUN go build -o app .

#########################
# Main Container
#########################

FROM alpine
COPY --from=temp /app/app .
RUN addgroup -S app-grp && adduser -S app-usr -G app-grp
USER app-usr
HEALTHCHECK  --interval=1m --timeout=20s \
  CMD wget --no-verbose --tries=5 http://localhost:3030/health || exit 1
CMD [ "./app" ]