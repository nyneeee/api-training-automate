*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary 
Library     String
Library     Collections   
Library     OperatingSystem

Variables   ./Config/configs_header.yml
Variables   ./Config/configs_url.yml

Resource    ./Resources/Variables/commomVariables.resource
Resource    ./Resources/Keywords/commomKeyword.resource
Resource    ./Resources/Keywords/exampleKeyword.resource