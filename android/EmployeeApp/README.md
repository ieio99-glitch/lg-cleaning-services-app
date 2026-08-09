# Employee Android app

## Target stack

- Kotlin
- Jetpack Compose
- Android Architecture Components
- Secure cloud API for assignments, status updates, and photo uploads
- Android navigation intent for directions
- Firebase Cloud Messaging for notifications

## First modules

- Employee authentication
- My Jobs list filtered to the signed-in employee
- Job detail, status update, and navigation
- Camera capture and before/after upload
- Panic alert with three-second hold and current location

## Important implementation rules

- Query and cache only jobs assigned to the signed-in employee.
- Client phone numbers must not provide calling or texting controls in this app.
- If before/after photos are required, prompt before a job can be completed.
- Panic alerts must provide Call 911 and Call Owner actions and avoid exposing unrelated client information.
