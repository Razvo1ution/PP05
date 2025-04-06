from PyQt5.QtWidgets import QDialog, QVBoxLayout, QLabel, QLineEdit, QPushButton, QMessageBox
from db.database import Database

class ChangePasswordWindow(QDialog):
    def __init__(self, user_id):
        super().__init__()
        self.setWindowTitle("Hotel - Смена пароля")
        self.setMinimumSize(300, 250)
        self.user_id = user_id
        self.db = Database()

        layout = QVBoxLayout()

        self.current_password_input = QLineEdit()
        self.current_password_input.setEchoMode(QLineEdit.Password)
        self.current_password_input.setPlaceholderText("Введите текущий пароль")
        layout.addWidget(QLabel("Текущий пароль:"))
        layout.addWidget(self.current_password_input)

        self.new_password_input = QLineEdit()
        self.new_password_input.setEchoMode(QLineEdit.Password)
        self.new_password_input.setPlaceholderText("Введите новый пароль")
        layout.addWidget(QLabel("Новый пароль:"))
        layout.addWidget(self.new_password_input)

        self.confirm_password_input = QLineEdit()
        self.confirm_password_input.setEchoMode(QLineEdit.Password)
        self.confirm_password_input.setPlaceholderText("Подтвердите новый пароль")
        layout.addWidget(QLabel("Подтверждение пароля:"))
        layout.addWidget(self.confirm_password_input)

        self.change_button = QPushButton("Изменить пароль")
        self.change_button.clicked.connect(self.handle_change_password)
        layout.addWidget(self.change_button)

        self.setLayout(layout)

    def handle_change_password(self):
        current = self.current_password_input.text().strip()
        new = self.new_password_input.text().strip()
        confirm = self.confirm_password_input.text().strip()

        if not all([current, new, confirm]):
            QMessageBox.warning(self, "Предупреждение", "Все поля обязательны для заполнения.")
            return

        user = self.db.execute_query("SELECT password_hash FROM users WHERE id = %s", (self.user_id,), fetch_one=True)
        if current != user[0]:  # Сравниваем напрямую
            QMessageBox.critical(self, "Ошибка", "Неверный текущий пароль.")
            return

        if new != confirm:
            QMessageBox.critical(self, "Ошибка", "Новый пароль и подтверждение не совпадают.")
            return

        self.db.execute_query("UPDATE users SET password_hash = %s WHERE id = %s", (new, self.user_id))
        QMessageBox.information(self, "Успех", "Пароль успешно изменен!")
        self.accept()