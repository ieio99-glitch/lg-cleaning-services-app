# L&G Cleaning Services Apps

Private operations software for L&G Cleaning Services.

## Applications

- `ios/OwnerApp`: Native iPhone owner app, built with Swift and SwiftUI.
- `android/EmployeeApp`: Native Android employee app, built with Kotlin and Jetpack Compose.
- `docs/`: Product requirements, security rules, and implementation decisions.

## Product scope

The owner app manages clients, protected property access details, appointments, employee assignments, customer communication, review requests, before/after photos, and emergency alerts. The employee app shows only assigned jobs, supports navigation, start/complete status, required before/after photos, and a panic alert.

## Security baseline

- Property access information is encrypted and never shown in ordinary notifications.
- Only the owner can communicate with clients.
- Employees see only their assigned jobs and only access details explicitly allowed for an assignment.
- The panic feature supplements—not replaces—the phone's emergency calling features.

## Build order

1. Secure accounts, roles, clients, and appointments.
2. Employee assignment, status changes, and private photo upload.
3. Owner-approved ETA texts and Google review requests.
4. Emergency alerts, notification hardening, testing, and beta release.
