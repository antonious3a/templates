FROM docker.io/bellsoft/buildpacks.builder:glibc
LABEL authors="antonio3a"

COPY buildpack.toml /cnb/buildpacks/bellsoft_buildpacks_liberica/20260225/

# docker buildx build --platform linux/amd64,linux/arm64 --push -t docker.io/antonio3a/bellsoft-buildpacks.builder:glibc -t quay.io/antonio3a/bellsoft-buildpacks.builder:glibc .