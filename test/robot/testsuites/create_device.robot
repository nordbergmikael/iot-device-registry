*** Settings ***
Documentation     A test suite that tests different Device creation scenarios.
Library           RequestsLibrary
Library           String
Resource          ../resources/fiware.robot

Suite Setup       suite setup


*** Test Cases ***
Create Device
    ${model}=       Create Device Model  urn:ngsi-ld:DeviceModel:${TEST_ID_PRFX}:mymodel
    ${deviceID}=    Set Variable        urn:ngsi-ld:Device:${TEST_ID_PRFX}:mydevice
    ${device}=      Create Device       ${deviceID}  ${model}
    ${resp}=        POST On Session     diwise      /ngsi-ld/v1/entities    json=${model}
    ${resp}=        POST On Session     diwise      /ngsi-ld/v1/entities    json=${device}

    Status Should Be    201     ${resp}

Get Entities    

    ${resp}=        GET On Session      diwise      /ngsi-ld/v1/entities?type\=Device

    Status Should Be    200     ${resp}


Retrieve Entity
    ${deviceID}=    Set Variable        urn:ngsi-ld:Device:${TEST_ID_PRFX}:mydevice

    ${resp}=        GET On Session      diwise      /ngsi-ld/v1/entities/${deviceID}


*** Keywords ***
suite setup
    ${headers}=     Create Dictionary   Content-Type=application/ld+json
    Create Session    diwise    http://127.0.0.1:8686  headers=${headers}

    ${TEST_ID_PRFX}=  Generate Random String  8  [NUMBERS]abcdef
    Set Suite Variable  ${TEST_ID_PRFX}
    