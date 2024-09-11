import jwt
import base64
import urllib


def JWT_Decode(jwtEncoded):
    encoded = jwtEncoded
    decoded = jwt.decode(encoded, options={"verify_signature": False})
    return decoded

def URL_Encode(urlDecoded):
    decoded = urlDecoded
    encoded = urllib.parse.quote(decoded, safe='')
    return encoded

def Base64_Encode(data):
    byte_string = bytes(data, 'utf-8')
    decoded = base64.b64encode(byte_string)
    return decoded

def Base64_Decode(data_encode):
    encoded = base64.b64decode(data_encode).decode('utf-8')
    return encoded
