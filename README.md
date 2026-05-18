# NoteKeeper

NoteKeeper is a Flutter note-taking app built with GetX. It includes onboarding, user authentication, remote note storage, search, note statistics, and full note create/edit/delete flows.

## Repository

[Halima-mandeq/NoteKeeper](https://github.com/Halima-mandeq/NoteKeeper.git)

## Features

- Onboarding screens for first-time users
- Email and password login
- Account creation
- Persistent user session with GetStorage
- Notes dashboard with total, pinned, and unpinned counts
- Search notes by title, content, or tag
- Create notes with title, content, tags, and pinned status
- Edit existing notes
- Delete notes with confirmation
- Logout with yes/no confirmation
- Pull-to-refresh and refresh button
- Toast feedback for successful actions and errors

## Tech Stack

- Flutter
- Dart
- GetX for routing and state management
- GetStorage for local session storage
- HTTP package for REST API requests
- Fluttertoast for user feedback

## API

The app connects to this backend:

```text
https://notes-backend-bootcamp.vercel.app/api/v1/
```

The base URL is configured in:

```text
lib/app/utils/api_constants.dart
```

### Auth Endpoints

- `POST auth/users/signup` - create a user account
- `POST auth/users/login` - login and receive a token

### Notes Endpoints

- `GET notes` - get all notes for the logged-in user
- `GET notes/stats` - get note statistics
- `POST notes` - create a note
- `PATCH notes/<note-id>` - update a note
- `DELETE notes/<note-id>` - delete a note

Protected note requests use the saved JWT token as a bearer token.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK `>=3.9.0 <4.0.0`
- Android Studio, VS Code, or another Flutter-ready editor
- Android emulator, iOS simulator, or physical device

### Install Dependencies

```bash
flutter pub get
```

### Run The App

```bash
flutter run
```

### Analyze The Project

```bash
flutter analyze
```

## Project Structure

```text
lib/
|-- main.dart
`-- app/
    |-- components/
    |-- modules/
    |   |-- home/
    |   |-- onboarding/
    |   `-- user/
    |-- routes/
    `-- utils/
```

Important files:

- `lib/main.dart` - app bootstrap and initial route setup
- `lib/app/routes/app_pages.dart` - GetX route definitions
- `lib/app/modules/onboarding/` - onboarding flow
- `lib/app/modules/user/` - login, signup, session storage, and logout
- `lib/app/modules/home/` - notes dashboard, CRUD logic, statistics, and API provider
- `lib/app/components/notes_card.dart` - note card UI with edit and delete actions
- `lib/app/utils/api_constants.dart` - API URL, storage keys, shared helpers, and date formatting

## Notes Workflow

1. Create an account or log in.
2. View note statistics at the top of the home screen.
3. Tap the add button to create a note.
4. Use the search field to filter notes.
5. Use `Edit` on a note card to update the note.
6. Use `Delete` on a note card to remove it after confirmation.
7. Tap logout and choose `Yes` to end the session.

## Postman Collection

A Postman collection for user requests is included here:

```text
docs/postman/NoteKeeper-Users.postman_collection.json
```

Import it into Postman, run `Login User`, then use the saved token for protected requests.

## Future Improvements

- Add offline note caching
- Add a dedicated note details screen
- Add dark mode support
- Add automated widget tests for note creation, editing, and deletion
