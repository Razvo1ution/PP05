from PyQt5.QtWidgets import QMainWindow, QWidget, QVBoxLayout, QLabel, QPushButton, QMessageBox

class UserWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Hotel - Панель пользователя")
        self.setMinimumSize(400, 300)

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)

        layout.addWidget(QLabel("Добро пожаловать, пользователь!"))
        layout.addWidget(QLabel("Здесь будет функционал для пользователя."))

        self.logout_button = QPushButton("Выйти")
        self.logout_button.clicked.connect(self.logout)
        layout.addWidget(self.logout_button)

    def logout(self):
        """Закрывает текущее окно и открывает окно авторизации."""
        from ui.login_window import LoginWindow  # Отложенный импорт
        self.login_window = LoginWindow()
        self.login_window.show()
        self.close()