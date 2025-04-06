from db.database import Database
from datetime import datetime, timedelta

class AuthController:
    def __init__(self):
        self.db = Database()
        self.login_attempts = {}

    def authenticate(self, username, password):
        print(f"Проверка логина: {username}")
        query = """
            SELECT id, password_hash, role, is_blocked, last_login 
            FROM users 
            WHERE username = %s
        """
        print("Перед выполнением запроса к БД")
        try:
            user = self.db.execute_query(query, (username,), fetch_one=True)
            print(f"Результат запроса: {user}")
        except Exception as e:
            print(f"Ошибка в запросе к БД: {e}")
            return {"status": "error"}

        if not user:
            self.track_failed_attempt(username)
            print(f"Логин {username} не найден")
            return {"status": "error"}

        user_id, stored_password, role, is_blocked, last_login = user
        print(f"Данные пользователя: id={user_id}, role={role}, is_blocked={is_blocked}")

        if is_blocked:
            return {"status": "blocked"}
        if last_login and (datetime.now() - last_login) > timedelta(days=30):
            self.block_user(user_id)
            return {"status": "blocked"}

        if password != stored_password:  # Сравниваем напрямую
            self.track_failed_attempt(username)
            if self.login_attempts.get(username, 0) >= 3:
                self.block_user(user_id)
                return {"status": "blocked"}
            return {"status": "error"}

        self.login_attempts[username] = 0
        self.db.execute_query("UPDATE users SET last_login = %s WHERE id = %s", (datetime.now(), user_id))
        print(f"Успешная авторизация для {username}")

        first_login = last_login is None
        return {"status": "success", "role": role, "first_login": first_login}

    def track_failed_attempt(self, username):
        self.login_attempts[username] = self.login_attempts.get(username, 0) + 1

    def block_user(self, user_id):
        self.db.execute_query("UPDATE users SET is_blocked = TRUE WHERE id = %s", (user_id,))