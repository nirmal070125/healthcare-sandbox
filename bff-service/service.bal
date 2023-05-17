import ballerina/http;

configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string v2tofhirAPIUrl = ?;
configurable string ccdatofhirAPIUrl = ?;

http:ClientConfiguration config = {
    auth: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
};

final http:Client v2tofhirClient = check new (v2tofhirAPIUrl, config);

final http:Client ccdatofhirClient = check new (ccdatofhirAPIUrl, config);

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

    # + return - a json
    resource function post ccdatofhir/transform(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        string textPayload = check request.getTextPayload();
        // Invoke the ccdatofhir service
        json result = check ccdatofhirClient->post("/ccdatofhir/transform", textPayload);
        return result;
    }
}
