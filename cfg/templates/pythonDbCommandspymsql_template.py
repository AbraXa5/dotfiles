import pymysql

host = ""
database = ""
username = ""
password = ""

sql_command = ""


def execute_sql_query(sql_command):
    # db connection database
    db = pymysql.connect(host=host, user=username, password=password, database=database)

    # Create a cursor object
    cursor = db.cursor()

    try:
        # Execute the SQL query
        cursor.execute(sql_command)
        # Fetch all the rows
        rows = cursor.fetchall()
        # Commit the changes
        db.commit()
        # Close the cursor and database connections
        cursor.close()
        db.close()
        # Return the result
        return rows

    except:
        # Rollback the changes and close the cursor and database connections
        db.rollback()
        cursor.close()
        db.close()
        # Raise an exception
        raise Exception("Error executing SQL query")
