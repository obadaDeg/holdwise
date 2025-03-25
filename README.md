# HoldWise - Smart Posture Assistant

HoldWise is a mobile application designed to help users maintain proper posture while using digital devices. Using sensor data and AI-driven analysis, the app provides real-time posture feedback, detailed analytics, and personalized recommendations.

## 📱 Features

### Core Functionality
- **Real-time Posture Monitoring**: Uses device sensors to track posture and provide instant feedback
- **Posture Violation Detection**: Alerts users when poor posture is detected
- **Analytics Dashboard**: Visualizes posture data with interactive charts and graphs
- **Streak & Badges System**: Gamifies the experience to encourage consistent good posture
- **Customizable Thresholds**: Users can adjust sensitivity based on their needs

### User Roles
- **Patient**: Regular users who receive posture monitoring and advice
- **Specialist**: Healthcare professionals who can monitor patient data and provide advice
- **Admin**: System administrators with access to analytics and user management

### Additional Features
- **Chat System**: Communication between patients and specialists
- **Educational Content**: Articles and advice for maintaining good posture
- **Subscription Plans**: Free and premium tiers with advanced features
- **Multi-platform Support**: Works on Android and iOS devices
- **Dark/Light Mode**: Customizable UI themes

## 🛠️ Technical Architecture

### Frontend
- Built with **Flutter** for cross-platform compatibility
- **BLoC pattern** for state management with Cubits
- Responsive design that adapts to different screen sizes
- Custom UI components with Material Design influences

### Data Management
- **Firebase** integration for authentication and data storage
- Real-time data syncing between users and specialists
- Local data caching for offline functionality
- Secure storage of sensitive information

### Sensor Integration
- Uses device accelerometer and gyroscope for posture detection
- Background service for continuous monitoring
- Battery-efficient algorithms to minimize power consumption
- Push notifications for posture alerts

## 🎨 Design System

The application features a consistent design system with:
- Color palettes: Primary (purple), Secondary (green), Tertiary (pink) with various shades
- Typography scale with responsive sizing
- Consistent component styling
- Dark and light theme variants

## 📊 Analytics & Reporting

HoldWise provides comprehensive analytics including:
- Posture score tracking over time
- Violation patterns across different time periods (day/week/month)
- Activity breakdown by type
- Heatmaps showing posture issues throughout the day

## 🔐 Authentication & Privacy

- Firebase Authentication integration
- Role-based access control
- Secure storage of user health data
- Options for data sharing with healthcare providers

## 💰 Monetization

The app follows a freemium model:
- **Free tier**: Basic posture monitoring and alerts
- **Premium subscription**: Advanced analytics, personalized advice, and AI insights
- Flexible pricing with monthly ($4.99) and annual ($49.99) options
- Multiple payment methods supported

## ⚙️ Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase account and project setup
- Android Studio or VS Code with Flutter plugins

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/holdwise.git
```

2. Install dependencies
```bash
cd holdwise
flutter pub get
```

3. Configure Firebase
   - Create a Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the google-services.json and GoogleService-Info.plist files
   - Enable Authentication and Firestore

4. Run the app
```bash
flutter run
```

## 📋 Project Structure

```
lib/
├── app/                  # App-wide configuration and setup
│   ├── config/           # App constants, themes, colors
│   ├── cubits/           # App-wide state management
│   ├── routes/           # Navigation and routing
│   └── utils/            # Helper functions
├── common/               # Shared components and utilities
│   ├── services/         # Shared services
│   └── widgets/          # Reusable widgets
├── features/             # Feature modules
│   ├── auth/             # Authentication
│   ├── camera_screen/    # Posture detection camera
│   ├── chat/             # Communication system
│   ├── dashboard/        # Main dashboard
│   ├── explore_screen/   # Educational content
│   ├── records/          # User records and analytics
│   ├── sensors/          # Sensor data handling
│   └── subscription/     # Premium subscriptions
└── main.dart             # Application entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- Obada Daghlas - Project Lead & Developer

