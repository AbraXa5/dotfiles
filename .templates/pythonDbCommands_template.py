#!/usr/bin/env python

import re
import requests
import sys
import json
import urllib3
import mysql.connector

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def sqlCommand(command):
    host = ""
    database = ""
    username = ""
    password = ""

    # SQL command to execute
    sql_command = f"{command}"

    try:
        conn = mysql.connector.connect(
            host=host,
            database=database,
            user=username,
            password=password
        )
    except mysql.connector.Error as err:
        print("Error connecting to MariaDB: {err}")
        exit()

    try:
        cursor = conn.cursor()
        cursor.execute(sql_command)
        conn.commit()
        print("SQL command executed successfully")
        result = True
    except mysql.connector.Error as err:
        print("Error executing SQL command: {err}")
        conn.rollback()
        result = False

    cursor.close()
    conn.close()

    return result