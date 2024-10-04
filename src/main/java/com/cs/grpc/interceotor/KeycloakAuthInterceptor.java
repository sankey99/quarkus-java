package com.cs.grpc.interceotor;

import io.grpc.Metadata;
import io.grpc.ServerCall;
import io.grpc.ServerCallHandler;
import io.grpc.ServerInterceptor;
import org.keycloak.authorization.client.AuthzClient;
import org.keycloak.representations.idm.authorization.AuthorizationRequest;
import org.keycloak.representations.idm.authorization.AuthorizationResponse;

/**
 * Created by Santosh Choudhary on 2024-08-12.
 */
public class KeycloakAuthInterceptor implements ServerInterceptor {

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(ServerCall<ReqT, RespT> serverCall,
                                                                 Metadata metadata, ServerCallHandler<ReqT, RespT> serverCallHandler) {

        AuthzClient authzClient = AuthzClient.create();

// create an authorization request
        AuthorizationRequest request = new AuthorizationRequest();

// add permissions to the request based on the resources and scopes you want to check access
        request.addPermission("Default Resource");


// send the entitlement request to the server in order to
// obtain an RPT with permissions for a single resource
        AuthorizationResponse response = authzClient.authorization("alice", "alice").authorize(request);
        String rpt = response.getToken();

        System.out.println("You got an RPT: " + rpt);

    }
}
