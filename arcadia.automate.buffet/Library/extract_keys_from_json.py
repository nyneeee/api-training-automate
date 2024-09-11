import json

def extract_keys_from_json(json_data):
    """
    This function is used for retrieving all keys from JSON and returning a list of all keys.
     :param json_data: JSON in text format.
     :return: List of all keys.
    """
    # แปลง JSON เป็น Python dictionary
    data = json.loads(json_data)
    all_keys = []
    def recursive_extract_keys(d, parent_key=""):
        for key, value in d.items():
            new_key = f"{parent_key}.{key}" if parent_key else key
            if isinstance(value, dict):
                recursive_extract_keys(value, new_key)
            elif isinstance(value, list) and value:
                for item in value:
                    if isinstance(item, dict):
                        recursive_extract_keys(item, new_key)
            else:
                all_keys.append(new_key)
    recursive_extract_keys(data)
    return all_keys
