# Vaultify 🔐

A beautiful and secure password manager app built with Flutter.

## Features

- 🔐 Secure password storage
- 👤 User authentication (signup/login)
- 🔄 Password management (add, edit, delete)
- 🎨 Beautiful and modern UI
- 🔒 Token-based authentication
- 📱 Cross-platform support

## Setup Instructions

### Backend Server Setup

This app requires a backend server to handle authentication and password storage. You need to:

1. **Set up the backend server:**
   - Clone or create a Node.js/Express backend server
   - The server should run on port 3000
   - Required endpoints:
     - `POST /signup` - User registration
     - `POST /login` - User login
     - `GET /passwords` - Get all passwords
     - `POST /passwords` - Add new password
     - `PUT /passwords/:id` - Update password
     - `DELETE /passwords/:id` - Delete password

2. **For Android Emulator:**
   - Run the backend server on `http://10.0.2.2:3000`
   - Use `10.0.2.2` as the IP address (localhost for Android emulator)

3. **For Physical Device:**
   - Run the backend server on your PC
   - Find your PC's IP address (e.g., `192.168.1.xxx`)
   - Update `baseUrl` in `lib/utils/constants.dart`

### Frontend Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Test API Connection:**
   - The app will show detailed error messages if the backend is not accessible
   - Check the console logs for connection status and API responses

## Configuration

### API Base URL
- **File:** `lib/utils/constants.dart`
- **Current:** `http://10.0.2.2:3000` (for emulator)
- **For physical device:** Change to your PC's IP address

### Troubleshooting

**Signup/Login not working:**
1. Ensure backend server is running on port 3000
2. Check if the API endpoints match the expected format
3. Verify network connectivity
4. Check console logs for detailed error messages

**Common Issues:**
- **Timeout:** Backend server not responding
- **Connection refused:** Backend server not running
- **Wrong IP:** Update baseUrl for physical devices

## Project Structure

```
lib/
├── controllers/        # GetX controllers
├── models/            # Data models
├── services/          # API services
├── views/             # UI screens
│   ├── auth/          # Login, signup, splash screens
│   ├── home/          # Main password management screen
│   └── widgets/       # Reusable UI components
├── routes/            # Navigation routes
└── utils/             # Constants and helpers
```

## Dependencies

- **get:** ^4.6.6 - State management and navigation
- **get_storage:** ^2.1.1 - Local storage
- **http:** ^1.2.2 - HTTP requests
- **google_fonts:** ^6.2.1 - Custom fonts

## Support

If you encounter issues:
1. Check backend server is running
2. Verify API endpoints
3. Check console logs for error details
4. Ensure correct IP address configuration
