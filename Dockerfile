FROM golang:1.19.2@sha256:25de7b6b28219279a409961158c547aadd0960cf2dcbc533780224afa1157fd4 as build

WORKDIR /app

# cache dependencies
ADD go.mod go.sum ./
RUN go mod download

# build
ADD . .
RUN go build -o /main

COPY knowledge-base /knowledge-base

# copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2@sha256:474828b1e530e5a34b2c093cddc3919fac9a9cee47ac6fb9453604da54d470e8
COPY --from=build /main /main
COPY --from=build /knowledge-base /knowledge-base
ENTRYPOINT [ "/main" ]     


