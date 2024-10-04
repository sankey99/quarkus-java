package com.cs.grpc;

import io.quarkus.grpc.MutinyService;

@jakarta.annotation.Generated(value = "by Mutiny Grpc generator", comments = "Source: hello.proto")
public interface HelloGrpc extends MutinyService {

    io.smallrye.mutiny.Uni<com.cs.grpc.HelloReply> sayHello(com.cs.grpc.HelloRequest request);
}
