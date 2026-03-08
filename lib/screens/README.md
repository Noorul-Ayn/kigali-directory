# Kigali City Services & Places Directory

A Flutter mobile application that helps Kigali residents locate and navigate to essential public services and leisure locations.

## Features

- 🔐 **Authentication** — Email/password sign up, login, and email verification via Firebase Auth
- 📋 **Directory** — Browse all listings with real-time updates from Firestore
- 🔍 **Search & Filter** — Search by name and filter by category
- ➕ **CRUD Listings** — Create, read, update, and delete service/place listings
- 🗺️ **Map View** — View listings on an interactive map (Google Maps)
- 📍 **Listing Detail** — Full info page with embedded map and directions button
- ⚙️ **Settings** — User profile display and notification preferences

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

This app uses **Provider** for state management. All Firestore interactions go through a dedicated service layer (`FirestoreService`, `AuthService`) and are exposed to the UI via `ListingsProvider` and `AuthProvider`. Direct Firestore queries inside UI widgets are not used.

## Tech Stack

- **Flutter** — UI framework
- **Firebase Authentication** — User auth
- **Cloud Firestore** — Real-time database
- **Provider** — State management
- **Google Maps Flutter** — Map integration
- **Geolocator** — Location services
- **URL Launcher** — Opening Google Maps navigation