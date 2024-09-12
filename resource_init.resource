*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary 
Library     String
Library     Collections   
Library     OperatingSystem
Library     ./Resources/Keywords/CustomLibraryAPI/lib_api.py

Variables   ./Config/configs_header.yml
Variables   ./Config/configs_domain.yml
Variables   ./Config/configs_testdata.yml
Variables   ./Config/configs_timeout.yml

Resource    ./Resources/Variables/commomVariables.resource
Resource    ./Resources/Keywords/commomKeyword.resource
Resource    ./Resources/Keywords/exampleKeyword.resource