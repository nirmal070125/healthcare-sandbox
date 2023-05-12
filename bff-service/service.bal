import ballerina/http;

configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string v2tofhirAPIUrl = ?;

final http:Client v2tofhirClient = check new (v2tofhirAPIUrl,
    auth = {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
    );

service / on new http:Listener(9090) {

    # + return - a json
    # TODO: Change v2tofhir/transform to transform in the v2tofhir service
    resource function post v2tofhir/transform(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        string textPayload = check request.getTextPayload();
        // Invoke the v2tofhir service
        json result = check v2tofhirClient->post("/v2tofhir/transform", textPayload);
        return result;
    }
}
