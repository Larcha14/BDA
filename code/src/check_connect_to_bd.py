import psycopg2
from psycopg2 import Error

try:
    print("Подключение к PostgreSQL...")
    conn = psycopg2.connect("""
        host=localhost
        port=5432
        dbname=bd_abd_lab_1
        user=server
        password='password'
        target_session_attrs=read-write
    """)

    cursor = conn.cursor()
    cursor.execute('SELECT version()')

    print(cursor.fetchone())

    

except (Exception, Error) as error:
    print("Ошибка при работе с PostgreSQL", error)

finally:
    if conn:
        cursor.close()
        conn.close()
        print("Соединение с PostgreSQL закрыто")