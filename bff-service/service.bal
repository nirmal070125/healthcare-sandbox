import ballerina/http;
import ballerinax/health.fhir.r4;

configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string v2tofhirAPIUrl = ?;
configurable string ccdatofhirAPIUrl = ?;
configurable string patientfhirAPIUrl = ?;

http:ClientConfiguration config = {
    auth: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret
    }
};

final http:Client v2tofhirClient = check new (v2tofhirAPIUrl, config);

final http:Client ccdatofhirClient = check new (ccdatofhirAPIUrl, config);

final http:Client patientfhirClient = check new (patientfhirAPIUrl, config);

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

    resource function post fhir/r4/patient(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        json jsonPayload = check request.getJsonPayload();

        json result = check patientfhirClient->post("/fhir/r4/Patient", jsonPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
        return result;
    }

    resource function get fhir/r4/patient(http:RequestContext ctx, http:Request request) returns json|error {

        map<string[]> queryParams = request.getQueryParams();
        string queryString = "";
        foreach var [key, value] in queryParams.entries() {
            foreach var v in value {
                queryString = queryString + key + "=" + v + "&";
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the ccdatofhir service
        json result = check patientfhirClient->get("/fhir/r4/Patient" + queryString);
        return result;
    }

    resource function get fhir/r4/patient/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the ccdatofhir service
        json result = check patientfhirClient->get("/fhir/r4/Patient/" + id);
        return result;
    }
}
