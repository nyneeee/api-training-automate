from robot.api.deco import keyword

@keyword("Compare Values Should Be Equal")
def compare_values_should_be_equal(response_1, response_2):
    if response_1 == response_2:
        return True,"Success data response is ​match."
    else:
        diff = {key: (response_1[key], response_2[key]) for key in response_1 if response_1[key] != response_2.get(key)}
        diff_str = ", ".join([f"{key}: ({response_1[key]} != {response_2[key]})" for key in diff])
        return False,f"Values are not equal. Differences: {{{diff_str}}}"