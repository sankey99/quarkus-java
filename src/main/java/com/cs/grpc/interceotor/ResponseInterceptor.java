package com.cs.grpc.interceotor;

/**
 * Created by Santosh Choudhary on 2024-10-04.
 */

import io.grpc.*;
import io.quarkus.grpc.GlobalInterceptor;
import jakarta.enterprise.context.ApplicationScoped;

@GlobalInterceptor
@ApplicationScoped
public class ResponseInterceptor implements ServerInterceptor {

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(
            ServerCall<ReqT, RespT> call,
            Metadata headers,
            ServerCallHandler<ReqT, RespT> next) {

        // Get the original ServerCall.Listener
        ServerCall.Listener<ReqT> listener = next.startCall(new ForwardingServerCall.SimpleForwardingServerCall<ReqT, RespT>(call) {

            @Override
            public void sendMessage(RespT response) {
                // Transform the response before sending it to the client
                RespT transformedResponse = transformResponse(response);
                super.sendMessage(transformedResponse); // Send the transformed response
            }

            @Override
            public void close(Status status, Metadata trailers) {
                if (!status.isOk()) {
                    // Transform the error before sending it to the client
                    Status transformedStatus = transformError(status);
                    Metadata transformedTrailers = transformTrailers(trailers);
                    super.close(transformedStatus, transformedTrailers); // Send transformed error
                } else {
                    super.close(status, trailers); // Normal close on success
                }
            }
        }, headers);

        return new ForwardingServerCallListener.SimpleForwardingServerCallListener<>(listener) {
            @Override
            public void onHalfClose() {
                try {
                    super.onHalfClose(); // Handle the request
                } catch (Exception e) {
                    // Catch and handle exceptions during request processing
                    Status status = Status.INTERNAL.withDescription("Custom error").withCause(e);
                    call.close(status, new Metadata()); // Send custom error response
                }
            }
        };
    }

    // Method to transform a successful response before sending it to the client
    private <RespT> RespT transformResponse(RespT response) {
        // Add custom transformation logic here
        return response; // Example: return the modified response
    }

    // Method to transform the error status before sending it to the client
    private Status transformError(Status status) {
        // Modify the status, such as changing the description or adding details
        return status.withDescription("Transformed Error: " + status.getDescription());
    }

    // Method to transform metadata (trailers) before sending it to the client
    private Metadata transformTrailers(Metadata trailers) {
        // Add or modify metadata (e.g., custom error information)
        Metadata.Key<String> key = Metadata.Key.of("custom-error-info", Metadata.ASCII_STRING_MARSHALLER);
        trailers.put(key, "Additional custom error details");
        return trailers;
    }
}
