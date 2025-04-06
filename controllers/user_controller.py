from db.database import Database

class UserController:
    def __init__(self):
        self.db = Database()

    def add_user(self, username):
        exists = self.db.execute_query("SELECT id FROM users WHERE username = %s", (username,), fetch_one=True)
        if exists:
            return {"status": "exists"}

        temp_password = "Temp1234"
        self.db.execute_query(
            "INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)",
            (username, temp_password, "user")
        )
        return {"status": "success"}

    def unblock_user(self, username):
        user = self.db.execute_query("SELECT id FROM users WHERE username = %s", (username,), fetch_one=True)
        if not user:
            return {"status": "error"}

        self.db.execute_query("UPDATE users SET is_blocked = FALSE WHERE username = %s", (username,))
        return {"status": "success"}

    def delete_user(self, username):
        """Удаляет пользователя по логину."""
        print(f"Попытка удалить пользователя с логином: {username}")  # Отладка
        user = self.db.execute_query("SELECT id FROM users WHERE username = %s", (username,), fetch_one=True)
        print(f"Результат запроса: {user}")  # Отладка
        if not user:
            print(f"Пользователь с логином {username} не найден")  # Отладка
            return {"status": "error"}

        self.db.execute_query("DELETE FROM users WHERE username = %s", (username,))
        print(f"Пользователь {username} удален")  # Отладка
        return {"status": "success"}