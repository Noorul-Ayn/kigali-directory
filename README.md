# Kigali City Services & Places Directory

A Flutter mobile application that helps Kigali residents locate and navigate to essential public services and leisure locations.

## Features

- 🔐 **Authentication** — Email/password sign up, login, and email verification via Firebase Auth
- 📋 **Directory** — Browse all listings with real-time updates from Firestore
- 🔍 **Search & Filter** — Search by name and filter by category
- ➕ **CRUD Listings** — Create, read, update, and delete service/place listings
- 🗺️ **Map View** — View listings on an interactive Google Map with markers
- 📍 **Listing Detail** — Full info page with embedded map and Get Directions button
- ⚙️ **Settings** — User profile display and notification preferences

## Tech Stack

- **Flutter** — UI framework
- **Firebase Authentication** — User auth with email verification
- **Cloud Firestore** — Real-time NoSQL database
- **Provider** — State management
- **Google Maps Flutter** — Map integration
- **Geolocator** — Location services
- **URL Launcher** — Opening Google Maps navigation

## Setup Instructions

### Prerequisites
- Flutter SDK 3.x
- Android Studio or VS Code
- Firebase account

### Steps

1. **Clone the repository**
```bash
   git clone https://github.com/Noorul-Ayn/kigali-directory.git
   cd kigali-directory
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Firebase Setup**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Email/Password Authentication
   - Create a Firestore database in europe-west1
   - Register your Android app and download `google-services.json`
   - Place `google-services.json` in `android/app/`
   - Run `flutterfire configure` to generate `lib/firebase_options.dart`

4. **Google Maps Setup**
   - Enable Maps SDK for Android in Google Cloud Console
   - Create an API key and add it to `android/app/src/main/AndroidManifest.xml`:
```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
```

5. **Run the app**
```bash
   flutter run
```

## Firestore Database Structure

### Collection: `users`
| Field | Type | Description |
|-------|------|-------------|
| uid | String | User's unique ID |
| email | String | User's email address |
| displayName | String | User's full name |
| createdAt | Timestamp | Account creation date |

### Collection: `listings`
| Field | Type | Description |
|-------|------|-------------|
| name | String | Place or service name |
| category | String | Category type |
| address | String | Physical address |
| contactNumber | String | Phone number |
| description | String | Details about the place |
| latitude | Double | GPS latitude |
| longitude | Double | GPS longitude |
| createdBy | String | UID of creator |
| timestamp | Timestamp | Creation date |

## State Management

This app uses **Provider** for state management. All Firestore interactions go through a dedicated service layer (`FirestoreService`, `AuthService`) and are exposed to the UI via `ListingsProvider` and `AuthProvider`. No direct Firestore queries exist inside UI widgets.

## Folder Structure
```
lib/
├── models/          # Data models (UserModel, ListingModel)
├── services/        # Firebase service layer (AuthService, FirestoreService)
├── providers/       # State management (AuthProvider, ListingsProvider)
├── screens/         # UI screens
│   └── auth/        # Login, Signup, VerifyEmail screens
└── widgets/         # Reusable widgets (ListingCard)
```

## Security Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```
