FROM golang:1.22 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/gosvc main.go
FROM gcr.io/distroless/base-debian12
COPY --from=build /out/gosvc /usr/local/bin/gosvc
ENTRYPOINT ["/usr/local/bin/gosvc"]
