FROM golang:1.20@sha256:9be8859445523843084e09747a6f25aee06ce92d23ae320e28d7f101dd6a39e2 as build

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


