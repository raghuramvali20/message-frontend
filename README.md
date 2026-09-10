# Message Frontend

Flutter client for the Message application.

## MVP baseline

This repository contains the first working MVP frontend: authentication, local token persistence, user search, chat screens, message sending, chat history, and Socket.IO integration.

Known limitations are intentionally left for the next version: complete profile/settings workflows, friends management, stronger offline handling, automated integration tests, UI polish, and a final encryption decision.

## Local setup

```powershell
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000 --dart-define=SOCKET_URL=http://10.0.2.2:3000
```

Use `10.0.2.2` for an Android emulator. For a physical device, replace it with the development machine's LAN address. For iOS Simulator, `localhost` usually points to the host machine.

The values are build-time configuration in `lib/core/config/app_environment.dart`; they are not secrets. Anything embedded in a mobile application can be extracted. Database credentials and JWT secrets must remain in the backend environment.

## Verification

```powershell
flutter analyze
flutter test
```

Before tagging a release, verify registration, login after restart, user search, opening a chat, sending and receiving messages with two accounts, chat history, and reconnect behavior.

## Repository policy

Commit Dart source, assets, `pubspec.yaml`, and `pubspec.lock`. Do not commit credentials, private certificates, generated build output, or backend `.env` files.
