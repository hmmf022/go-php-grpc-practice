FROM php:8.0-cli as base

ENV PROTO_VER 22.2
ENV GRPC_VER v1.53.0

RUN apt update && apt install -y \
    cmake \
    gcc \
    git \
    libtool \
    make \
    wget \
    zlib1g-dev \
    zip \
&& apt clean \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VER}/protoc-${PROTO_VER}-linux-x86_64.zip \
&& unzip -d protoc protoc-${PROTO_VER}-linux-x86_64.zip

WORKDIR /var/local
RUN git clone --depth 1 --recursive -b ${GRPC_VER} https://github.com/grpc/grpc.git
WORKDIR /var/local/grpc
RUN mkdir -p cmake/build
WORKDIR /var/local/grpc/cmake/build
RUN cmake ../.. && make protoc grpc_php_plugin


FROM php:8.0-cli as main

ARG USERNAME=webmaster
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

COPY --from=base /tmp/protoc/bin/* /usr/local/bin/
COPY --from=base /tmp/protoc/include/* /usr/local/include/
COPY --from=base /var/local/grpc/cmake/build/grpc_php_plugin /usr/local/bin/

USER $USERNAME

ENTRYPOINT ["protoc", "--proto_path=/var/local/protos", "--php_out=/var/local/gen", "--plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin"]
