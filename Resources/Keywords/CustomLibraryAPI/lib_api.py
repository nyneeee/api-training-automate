import jsonschema
import urllib3
from robot.api.deco import keyword
from urllib3.exceptions import InsecureRequestWarning

urllib3.disable_warnings(InsecureRequestWarning)

@keyword("Validate Json Schema And Return Error")
def validate_json_schema_is_correct(json_object, schema) -> None:
    """Validate json object by json schema and log keys that do not match the schema.
    Arguments:
        - json_object: json as a dictionary object.
        - schema: schema as a dictionary object.

    Fail if json object does not match the schema.

    Examples:
    | Simple | Validate Json By Schema  |  {"foo": "bar"}  |  {"$schema": "https://schema", "type": "object"} |
    """
    try:
        jsonschema.validate(json_object, schema)
    except jsonschema.ValidationError as e:
        error_message = f"Invalid : {e.validator} , Json does not match the schema: {e.schema}. Invalid Key: {e.json_path}"
        raise AssertionError(error_message)
    except jsonschema.SchemaError as e:
        fail(f"Json schema error: {e.message}")