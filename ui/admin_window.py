from PyQt5.QtWidgets import QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, QTableWidget, QTableWidgetItem, QMessageBox, QComboBox
from PyQt5.QtCore import Qt
from db.database import db
from utils.password_utils import hash_password

class AdminWindow(QMainWindow):
    def __init__(self, user):
        super().__init__()
        self.user = user  # Данные текущего администратора
        self.setWindowTitle("HotelApp - Панель администратора")
        self.setMinimumSize(600, 400)
        self.resize(800, 600)  # Масштабируемое окно

        # Основной layout
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout = QVBoxLayout(self.central_widget)

        # Таблица пользователей
        self.user_table = QTableWidget()
        self.user_table.setColumnCount(4)
        self.user_table.setHorizontalHeaderLabels(["ID", "Логин", "Роль", "Заблокирован"])
        self.user_table.horizontalHeader().setStretchLastSection(True)  # Растягиваем последнюю колонку
        self.layout.addWidget(self.user_table)

        # Форма добавления/редактирования пользователя
        self.form_layout = QHBoxLayout()
        self.username_input = QLineEdit()
        self.username_input.setPlaceholderText("Логин")
        self.form_layout.addWidget(QLabel("Логин:"))
        self.form_layout.addWidget(self.username_input)

        self.password_input = QLineEdit()
        self.password_input.setPlaceholderText("Пароль")
        self.password_input.setEchoMode(QLineEdit.Password)
        self.form_layout.addWidget(QLabel("Пароль:"))
        self.form_layout.addWidget(self.password_input)

        self.role_combo = QComboBox()
        self.role_combo.addItems(["user", "admin"])
        self.form_layout.addWidget(QLabel("Роль:"))
        self.form_layout.addWidget(self.role_combo)

        self.layout.addLayout(self.form_layout)

        # Кнопки управления
        self.button_layout = QHBoxLayout()
        self.add_button = QPushButton("Добавить пользователя")
        self.add_button.clicked.connect(self.add_user)
        self.button_layout.addWidget(self.add_button)

        self.update_button = QPushButton("Изменить пользователя")
        self.update_button.clicked.connect(self.update_user)
        self.button_layout.addWidget(self.update_button)

        self.unblock_button = QPushButton("Снять блокировку")
        self.unblock_button.clicked.connect(self.unblock_user)
        self.button_layout.addWidget(self.unblock_button)

        self.layout.addLayout(self.button_layout)

        # Загрузка данных
        self.load_users()

    def load_users(self):
        users = db.execute_query("SELECT id, username, role, is_blocked FROM users")
        self.user_table.setRowCount(len(users))
        for row, user in enumerate(users):
            self.user_table.setItem(row, 0, QTableWidgetItem(str(user["id"])))
            self.user_table.setItem(row, 1, QTableWidgetItem(user["username"]))
            self.user_table.setItem(row, 2, QTableWidgetItem(user["role"]))
            self.user_table.setItem(row, 3, QTableWidgetItem("Да" if user["is_blocked"] else "Нет"))

    def add_user(self):
        username = self.username_input.text().strip()
        password = self.password_input.text().strip()
        role = self.role_combo.currentText()

        if not username or not password:
            QMessageBox.warning(self, "Ошибка", "Логин и пароль обязательны для заполнения.")
            return

        # Проверка на существование пользователя
        existing_user = db.execute_query("SELECT * FROM users WHERE username = %s", (username,))
        if existing_user:
            QMessageBox.warning(self, "Ошибка", "Пользователь с таким логином уже существует.")
            return

        # Добавление пользователя
        password_hash = hash_password(password)
        db.execute_query(
            "INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)",
            (username, password_hash, role)
        )
        if role == "admin":
            user_id = db.execute_query("SELECT id FROM users WHERE username = %s", (username,))[0]["id"]
            db.execute_query("INSERT INTO admins (user_id) VALUES (%s)", (user_id,))

        QMessageBox.information(self, "Успех", "Пользователь успешно добавлен.")
        self.load_users()
        self.clear_inputs()

    def update_user(self):
        selected_row = self.user_table.currentRow()
        if selected_row == -1:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для изменения.")
            return

        user_id = int(self.user_table.item(selected_row, 0).text())
        username = self.username_input.text().strip()
        password = self.password_input.text().strip()
        role = self.role_combo.currentText()

        if not username:
            QMessageBox.warning(self, "Ошибка", "Логин обязателен для заполнения.")
            return

        query = "UPDATE users SET username = %s, role = %s"
        params = [username, role]
        if password:
            query += ", password_hash = %s"
            params.append(hash_password(password))
        query += " WHERE id = %s"
        params.append(user_id)

        db.execute_query(query, tuple(params))
        if role == "admin" and not db.execute_query("SELECT * FROM admins WHERE user_id = %s", (user_id,)):
            db.execute_query("INSERT INTO admins (user_id) VALUES (%s)", (user_id,))
        elif role == "user":
            db.execute_query("DELETE FROM admins WHERE user_id = %s", (user_id,))

        QMessageBox.information(self, "Успех", "Данные пользователя обновлены.")
        self.load_users()
        self.clear_inputs()

    def unblock_user(self):
        selected_row = self.user_table.currentRow()
        if selected_row == -1:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для разблокировки.")
            return

        user_id = int(self.user_table.item(selected_row, 0).text())
        db.execute_query("UPDATE users SET is_blocked = FALSE WHERE id = %s", (user_id,))
        QMessageBox.information(self, "Успех", "Пользователь разблокирован.")
        self.load_users()

    def clear_inputs(self):
        self.username_input.clear()
        self.password_input.clear()
        self.role_combo.setCurrentIndex(0)