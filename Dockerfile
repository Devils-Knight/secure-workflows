FROM golang:1.17@sha256:bfb57478eb0b381f242b3ab27b373bca5516eb9d35eef98a41a0ba2742ab517d as build

WORKDIR /app

# cache dependencies
ADD go.mod go.sum ./
RUN go mod download

# build
ADD . .
RUN go build -o /main

COPY knowledge-base /knowledge-base

# copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2@sha256:f3bfbf83a7d8d8b821c62e8597b790b4fd7d8b309fed61584a913cbd148f4bb9
COPY --from=build /main /main
COPY --from=build /knowledge-base /knowledge-base
ENTRYPOINT [ "/main" ]     


