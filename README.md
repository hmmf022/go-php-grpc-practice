# gRPC PHP コード生成環境 (Dockerized)

## 概要

このプロジェクトは、Protocol Buffers (`.proto` ファイル) からPHP用のgRPCクライアントおよびサービススタブを生成するためのDockerベースの環境を提供します。`protoc` コンパイラとgRPC PHPプラグインをDockerコンテナ内に構築することで、OS環境に依存せず、一貫したコード生成プロセスを実現します。

## 主な機能

*   **Dockerized環境**: `protoc` と `grpc_php_plugin` を含むPHP CLIベースのDockerイメージを提供。
*   **PHPクラス生成**: `.proto` ファイルからメッセージを扱うPHPクラスを生成。
*   **gRPCスタブ生成**: `.proto` ファイルで定義されたサービスに基づき、PHP用のgRPCサービスインターフェースおよびクライアントスタブを生成。
*   **Makefileによる簡易操作**: ビルドおよびコード生成プロセスをシンプルな`make`コマンドで実行。
*   **サンプルProtoファイル**: `protos/hello.proto` に基本的なgRPCサービス定義の例が含まれています。

## 技術スタック

*   **コンテナ化**: Docker, Docker Compose (Makefile経由)
*   **言語**: PHP (CLI), Protocol Buffers (.proto)
*   **コード生成ツール**: `protoc`, `grpc_php_plugin`
*   **ビルドツール**: Makefile

## 環境構築とコード生成

この環境を利用してPHP gRPCコードを生成するための手順です。

### 前提条件

*   [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Docker Engine および Docker Compose を含む) がインストールされていること。
*   `make` コマンドが利用できること。

### セットアップ手順

1.  **リポジトリをクローンします。**
    ```bash
    git clone https://github.com/hmmf022/go-php-grpc-practice.git
    cd go-php-grpc-practice
    ```

2.  **Dockerイメージのビルド**
    `protoc` と `grpc_php_plugin` が含まれるDockerイメージをビルドします。
    ```bash
    make build
    ```
    これにより `grpc-php` という名前のDockerイメージが作成されます。このビルドには少し時間がかかります。

3.  **Protoファイルを配置**
    PHPコードを生成したい`.proto`ファイルを `protos/` ディレクトリ内に配置します。
    例として、`protos/hello.proto` が既に配置されています。

4.  **PHPコードの生成**
    `make run` コマンドを使用して、`.proto` ファイルからPHPコードを生成します。
    生成されたPHPファイルは `gen/` ディレクトリに出力されます。

    ```bash
    make run target=hello.proto
    ```
    *   `target` 引数には、生成対象の`.proto`ファイルパスを指定します。
    *   `--rm` オプションにより、コード生成後にコンテナは自動的に削除されます。
    *   `protos/` ディレクトリと `gen/` ディレクトリはDockerコンテナにマウントされるため、ホスト側のファイルが更新されます。

### 生成されるファイル

上記の `make run target=protos/hello.proto` コマンドを実行すると、`gen/` ディレクトリに以下のファイルが生成されます。

```
gen/
└── App
    └── gRPC
        ├── GreetingServiceClient.php
        ├── HelloRequest.php
        └── HelloResponse.php
```

これらのファイルは、PHPアプリケーションでgRPCクライアントやサーバーを実装する際に利用できます。

## `protos/hello.proto` の内容例

```protobuf
syntax = "proto3";

package myapp;

option php_namespace = "App\\gRPC";
option php_metadata_namespace = "App\\gRPC";

service GreetingService {
    rpc Hello (HelloRequest) returns (HelloResponse);
}

message HelloRequest {
    string name = 1;
}

message HelloResponse {
    string message = 1;
}
```

## カスタマイズ

*   **Protocol Buffers および gRPC のバージョン**:
    `Dockerfile` の先頭にある `PROTO_VER` と `GRPC_VER` 環境変数を変更することで、使用するProtocol BuffersおよびgRPCのバージョンを更新できます。バージョン変更後は、再度 `make build` を実行してください。

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細については`LICENSE`ファイルを参照してください。
