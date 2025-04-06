import psycopg2

class Database:
    def __init__(self):
        try:
            self.conn = psycopg2.connect(
                dbname="hotel",
                user="postgres",
                password="admin",
                host="localhost",
                port="5432",
                client_encoding="UTF8"
            )
            print("Подключение к базе данных успешно установлено")  # Отладка
        except Exception as e:
            raise Exception(f"Не удалось подключиться к базе данных: {e}")

    def execute_query(self, query, params=None, fetch_one=False):
        print(f"Выполняем запрос: {query} с параметрами {params}")  # Отладка
        try:
            with self.conn.cursor() as cursor:
                cursor.execute(query, params)
                print("Запрос выполнен")  # Отладка
                if fetch_one:
                    result = cursor.fetchone()
                    print(f"Результат fetch_one: {result}")  # Отладка
                    self.conn.commit()
                    return result
                elif cursor.description:
                    result = cursor.fetchall()
                    print(f"Результат fetch_all: {result}")  # Отладка
                    self.conn.commit()
                    return result
                self.conn.commit()
                print("Коммит выполнен")  # Отладка
        except Exception as e:
            print(f"Ошибка при выполнении запроса: {e}")  # Отладка
            self.conn.rollback()
            raise