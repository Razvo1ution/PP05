from PyQt5.QtWidgets import QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit, QPushButton, \
    QTableWidget, QTableWidgetItem, QMessageBox
from controllers.user_controller import UserController


class AdminPanel(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Hotel - Панель администратора")
        self.setMinimumSize(600, 400)
        self.user_controller = UserController()

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        main_layout = QVBoxLayout(central_widget)

        add_user_layout = QHBoxLayout()
        self.username_input = QLineEdit()
        self.username_input.setPlaceholderText("Введите логин нового пользователя")
        add_user_layout.addWidget(QLabel("Новый пользователь:"))
        add_user_layout.addWidget(self.username_input)
        self.add_user_button = QPushButton("Добавить пользователя")
        self.add_user_button.clicked.connect(self.add_user)
        add_user_layout.addWidget(self.add_user_button)
        main_layout.addLayout(add_user_layout)

        manage_layout = QHBoxLayout()
        self.manage_username_input = QLineEdit()
        self.manage_username_input.setPlaceholderText("Введите логин пользователя")  # Уточнили подсказку
        manage_layout.addWidget(QLabel("Управление пользователем:"))
        manage_layout.addWidget(self.manage_username_input)

        self.unblock_button = QPushButton("Снять блокировку")
        self.unblock_button.clicked.connect(self.unblock_user)
        manage_layout.addWidget(self.unblock_button)

        self.delete_button = QPushButton("Удалить пользователя")
        self.delete_button.clicked.connect(self.delete_user)
        manage_layout.addWidget(self.delete_button)

        main_layout.addLayout(manage_layout)

        self.user_table = QTableWidget()
        self.user_table.setColumnCount(4)
        self.user_table.setHorizontalHeaderLabels(["ID", "Логин", "Роль", "Заблокирован"])
        self.user_table.setEditTriggers(QTableWidget.NoEditTriggers)
        main_layout.addWidget(self.user_table)

        button_layout = QHBoxLayout()
        self.refresh_button = QPushButton("Обновить список")
        self.refresh_button.clicked.connect(self.load_users)
        button_layout.addWidget(self.refresh_button)

        self.logout_button = QPushButton("Выйти")
        self.logout_button.clicked.connect(self.logout)
        button_layout.addWidget(self.logout_button)

        main_layout.addLayout(button_layout)

        self.load_users()

    def load_users(self):
        query = "SELECT id, username, role, is_blocked FROM users"
        users = self.user_controller.db.execute_query(query)

        self.user_table.setRowCount(len(users))
        for row, user in enumerate(users):
            user_id, username, role, is_blocked = user
            self.user_table.setItem(row, 0, QTableWidgetItem(str(user_id)))
            self.user_table.setItem(row, 1, QTableWidgetItem(username))
            self.user_table.setItem(row, 2, QTableWidgetItem(role))
            self.user_table.setItem(row, 3, QTableWidgetItem("Да" if is_blocked else "Нет"))

        self.user_table.resizeColumnsToContents()
        print("Таблица пользователей обновлена")

    def add_user(self):
        username = self.username_input.text().strip()
        if not username:
            QMessageBox.warning(self, "Предупреждение", "Введите логин пользователя.")
            return

        result = self.user_controller.add_user(username)
        if result["status"] == "exists":
            QMessageBox.critical(self, "Ошибка", "Пользователь с таким логином уже существует.")
        else:
            QMessageBox.information(self, "Успех", f"Пользователь {username} добавлен с временным паролем 'Temp1234'.")
            self.username_input.clear()
            self.load_users()

    def unblock_user(self):
        username = self.manage_username_input.text().strip()
        if not username:
            QMessageBox.warning(self, "Предупреждение", "Введите логин пользователя.")
            return

        result = self.user_controller.unblock_user(username)
        if result["status"] == "success":
            QMessageBox.information(self, "Успех", f"Блокировка с пользователя {username} снята.")
            self.manage_username_input.clear()
            self.load_users()
        else:
            QMessageBox.critical(self, "Ошибка", "Пользователь не найден.")

    def delete_user(self):
        username = self.manage_username_input.text().strip()
        if not username:
            QMessageBox.warning(self, "Предупреждение", "Введите логин пользователя.")
            return

        reply = QMessageBox.question(self, "Подтверждение",
                                     f"Вы уверены, что хотите удалить пользователя {username}?",
                                     QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if reply == QMessageBox.Yes:
            try:
                result = self.user_controller.delete_user(username)
                if result["status"] == "success":
                    QMessageBox.information(self, "Успех", f"Пользователь {username} удален.")
                    self.manage_username_input.clear()
                    self.load_users()
                else:
                    QMessageBox.critical(self, "Ошибка", "Пользователь с таким логином не найден.")
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", f"Произошла ошибка при удалении: {e}")
                print(f"Ошибка при удалении: {e}")  # Отладка

    def logout(self):
        from ui.login_window import LoginWindow
        self.login_window = LoginWindow()
        self.login_window.show()
        self.close()