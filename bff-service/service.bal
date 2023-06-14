import ballerina/http;
import ballerinax/health.fhir.r4;

configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string v2tofhirAPIUrl = ?;
configurable string ccdatofhirAPIUrl = ?;
configurable string patientfhirAPIUrl = ?;
configurable string encounterfhirAPIUrl = ?;
configurable string practitionerfhirAPIUrl = ?;
configurable string organizationfhirAPIUrl = ?;
configurable string observationfhirAPIUrl = ?;

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

final http:Client encounterfhirClient = check new (encounterfhirAPIUrl, config);

final http:Client practitionerfhirClient = check new (practitionerfhirAPIUrl, config);

final http:Client organizationfhirClient = check new (organizationfhirAPIUrl, config);

final http:Client observationfhirClient = check new (observationfhirAPIUrl, config);

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
                queryString = string `${queryString}${key}=${v}&`;
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the patientfhir service
        json result = check patientfhirClient->get("/fhir/r4/Patient" + queryString);
        return result;
    }

    resource function get fhir/r4/patient/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the patientfhir service
        json result = check patientfhirClient->get("/fhir/r4/Patient/" + id);
        return result;
    }

    resource function post fhir/r4/encounter(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        json jsonPayload = check request.getJsonPayload();

        json result = check encounterfhirClient->post("/fhir/r4/Encounter", jsonPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
        return result;
    }

    resource function get fhir/r4/encounter(http:RequestContext ctx, http:Request request) returns json|error {

        map<string[]> queryParams = request.getQueryParams();
        string queryString = "";
        foreach var [key, value] in queryParams.entries() {
            foreach var v in value {
                queryString = string `${queryString}${key}=${v}&`;
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the encounterfhir service
        json result = check encounterfhirClient->get("/fhir/r4/Encounter" + queryString);
        return result;
    }

    resource function get fhir/r4/encounter/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the encounterfhir service
        json result = check encounterfhirClient->get("/fhir/r4/Encounter/" + id);
        return result;
    }

    resource function post fhir/r4/practitioner(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        json jsonPayload = check request.getJsonPayload();

        json result = check practitionerfhirClient->post("/fhir/r4/Practitioner", jsonPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
        return result;
    }

    resource function get fhir/r4/practitioner(http:RequestContext ctx, http:Request request) returns json|error {

        map<string[]> queryParams = request.getQueryParams();
        string queryString = "";
        foreach var [key, value] in queryParams.entries() {
            foreach var v in value {
                queryString = string `${queryString}${key}=${v}&`;
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the practitionerfhir service
        json result = check practitionerfhirClient->get("/fhir/r4/Practitioner" + queryString);
        return result;
    }

    resource function get fhir/r4/practitioner/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the practitionerfhir service
        json result = check practitionerfhirClient->get("/fhir/r4/Practitioner/" + id);
        return result;
    }

    resource function post fhir/r4/organization(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        json jsonPayload = check request.getJsonPayload();

        json result = check organizationfhirClient->post("/fhir/r4/Organization", jsonPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
        return result;
    }

    resource function get fhir/r4/organization(http:RequestContext ctx, http:Request request) returns json|error {

        map<string[]> queryParams = request.getQueryParams();
        string queryString = "";
        foreach var [key, value] in queryParams.entries() {
            foreach var v in value {
                queryString = string `${queryString}${key}=${v}&`;
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the organizationfhir service
        json result = check organizationfhirClient->get("/fhir/r4/Organization" + queryString);
        return result;
    }

    resource function get fhir/r4/organization/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the organizationfhir service
        json result = check organizationfhirClient->get("/fhir/r4/Organization/" + id);
        return result;
    }

    resource function post fhir/r4/observation(http:RequestContext ctx, http:Request request) returns json|error {

        // Get the payload from the request
        json jsonPayload = check request.getJsonPayload();

        json result = check observationfhirClient->post("/fhir/r4/Observation", jsonPayload, mediaType = r4:FHIR_MIME_TYPE_JSON);
        return result;
    }

    resource function get fhir/r4/observation(http:RequestContext ctx, http:Request request) returns json|error {

        map<string[]> queryParams = request.getQueryParams();
        string queryString = "";
        foreach var [key, value] in queryParams.entries() {
            foreach var v in value {
                queryString = string `${queryString}${key}=${v}&`;
            }
        }

        //remove last & if query string is not empty
        if (queryString != "") {
            queryString = "?" + queryString.substring(0, queryString.length() - 1);
        }

        // Invoke the observationfhir service
        json result = check observationfhirClient->get("/fhir/r4/Observation" + queryString);
        return result;
    }

    resource function get fhir/r4/observation/[string id](http:RequestContext ctx, http:Request request) returns json|error {

        // Invoke the observationfhir service
        json result = check observationfhirClient->get("/fhir/r4/Observation/" + id);
        return result;
    }
}
