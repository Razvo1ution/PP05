from PyQt5.QtWidgets import QMainWindow, QWidget, QVBoxLayout, QLabel, QLineEdit, QPushButton, QMessageBox
from controllers.auth_controller import AuthController
from ui.change_password_window import ChangePasswordWindow
from ui.admin_panel import AdminPanel
from ui.user_window import UserWindow

class LoginWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Hotel - Авторизация")
        self.setMinimumSize(300, 200)
        self.auth_controller = AuthController()

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)

        self.login_label = QLabel("Логин:")
        self.login_input = QLineEdit()
        self.login_input.setPlaceholderText("Введите логин")
        layout.addWidget(self.login_label)
        layout.addWidget(self.login_input)

        self.password_label = QLabel("Пароль:")
        self.password_input = QLineEdit()
        self.password_input.setEchoMode(QLineEdit.Password)
        self.password_input.setPlaceholderText("Введите пароль")
        layout.addWidget(self.password_label)
        layout.addWidget(self.password_input)

        self.login_button = QPushButton("Войти")
        self.login_button.clicked.connect(self.handle_login)
        layout.addWidget(self.login_button)

        self.login_input.setFocus()

    def handle_login(self):
        login = self.login_input.text().strip()
        password = self.password_input.text().strip()

        if not login or not password:
            QMessageBox.warning(self, "Предупреждение", "Поля 'Логин' и 'Пароль' обязательны для заполнения.")
            return

        result = self.auth_controller.authenticate(login, password)
        print(f"Результат авторизации: {result}")
        if result["status"] == "success":
            QMessageBox.information(self, "Успех", "Вы успешно авторизовались!")
            print("Сообщение об успехе показано")
            if result["first_login"]:
                print("Открываем окно смены пароля")
                self.show_change_password_window()
            elif result["role"] == "admin":
                print("Открываем панель администратора")
                self.show_admin_panel()
            else:
                print("Открываем окно пользователя")
                self.show_user_window()
            print("Окно открыто, закрываем текущее")
        elif result["status"] == "blocked":
            QMessageBox.critical(self, "Ошибка", "Вы заблокированы. Обратитесь к администратору.")
        else:
            QMessageBox.critical(self, "Ошибка", "Вы ввели неверный логин или пароль. Пожалуйста, проверьте ещё раз введенные данные.")

    def show_change_password_window(self):
        user_id = self.auth_controller.db.execute_query(
            "SELECT id FROM users WHERE username = %s",
            (self.login_input.text().strip(),),
            fetch_one=True
        )[0]
        print(f"Создаем ChangePasswordWindow для user_id={user_id}")
        self.change_password_window = ChangePasswordWindow(user_id)
        self.change_password_window.show()
        self.close()

    def show_admin_panel(self):
        print("Создаем AdminPanel")
        self.admin_panel = AdminPanel()
        self.admin_panel.show()
        self.close()

    def show_user_window(self):
        print("Создаем UserWindow")
        self.user_window = UserWindow()
        self.user_window.show()
        self.close()