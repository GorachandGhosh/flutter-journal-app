# 📓 Flutter Journal App

A modern and secure Journal App built using Flutter and Firebase. This application allows users to create, manage, and delete personal journal entries with authentication support.

## 🚀 Features

* 🔐 User Authentication (Login & Register using Firebase)
* 📝 Add Journal Entries (Title + Content)
* 🗑️ Delete Entries
* 📱 Clean & Responsive UI
* ⚡ Real-time Data Handling

## 🛠️ Technologies Used

* Flutter (UI Framework)
* Dart (Programming Language)
* Firebase Authentication
* Cloud Firestore (Database)
* Provider (State Management)

## 📂 Project Structure

lib/
│
├── data/                # Data models and helpers
├── model/               # User model
├── providers/           # State management
├── screens/             # UI screens (Login, Register, Home)
├── service/             # Firebase services
├── widgets/             # Reusable UI components
│
├── main.dart
├── app.dart

## 🔐 Security Note

Sensitive Firebase configuration files are NOT included in this repository for security reasons.

To run this project:

1. Create your own Firebase project
2. Enable Authentication (Email & Password)
3. Add your `google-services.json`
4. Configure `firebase_options.dart`


## ▶️ How to Run the Project

flutter pub get
flutter run

## 👨‍💻 Author

**Gorachand Ghosh**
B.Tech CSD Student | Flutter Developer | AI Enthusiast

## ⭐ Support

If you like this project, please ⭐ star the repository!
