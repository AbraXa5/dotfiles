#!/usr/bin/env python

import re
import sys

import requests
import urllib3

# Source: https://urllib3.readthedocs.io/en/1.26.x/advanced-usage.html#ssl-warnings
# export PYTHONWARNINGS="ignore:Unverified HTTPS request"
# Source: https://docs.python.org/3/using/cmdline.html#cmdoption-w
# python3 -Wignore ./fileName.py
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

argument = sys.argv[1]

username = ""
password = ""
url = ""
proxies = {"http": "http://127.0.0.1:8080"}
# Value for verify, if need to use a specific certificate
# certPath = ''

payload = f"""
something
{argument}
something
"""

# files = {'file': ('xxe.xml', payload, 'text/xml')}

params = {"name": "value"}

data = {"name": "value"}
try:
    session = requests.Session()

    # Auth to the URL
    # response = session.get(url, auth = (username,password))

    # GET request to the URL
    # response = session.get(url=url, params=params, proxies=proxies)

    # POST request to the URL
    response = session.post(url=url, data=data, proxies=proxies, verify=False)
    print(response.text)

except Exception as e:
    print(f"Exception raised: {e}")


# print(session.cookies)
# print(session.cookies['PHPSESSID'])
