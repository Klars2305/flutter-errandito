# Map and live location implementation

Implemented in this copy:

- Added OpenStreetMap packages in `pubspec.yaml`:
  - `flutter_map`
  - `latlong2`
  - `geolocator`
  - `geocoding`
- Added Android location permissions in `android/app/src/main/AndroidManifest.xml`.
- Added iOS location usage text in `ios/Runner/Info.plist`.
- Updated `lib/booking_details.dart`:
  - Gets the requester's current GPS location.
  - Converts coordinates into a readable place name using reverse geocoding.
  - Shows the place name in the UI instead of latitude/longitude numbers.
  - Shows a real OpenStreetMap preview.
  - Saves `serviceAddress`, `serviceLat`, and `serviceLng` when posting an errand.
- Updated `lib/services/errand_service.dart`:
  - Added `updateRunnerLocation()` to write `runnerLat`, `runnerLng`, and `runnerLocationUpdatedAt` to Firestore.
- Updated `lib/live_tracking_page.dart`:
  - Reads `serviceLat`, `serviceLng`, `runnerLat`, and `runnerLng` from Firestore.
  - Shows a live OpenStreetMap card with service and runner markers.
  - Shows the readable service place name, not coordinates.
- Updated `lib/gig_finder_page.dart`:
  - When a runner accepts an errand, the runner's current location is saved once immediately.
  - The errand ID is passed to the runner task page.
- Updated `lib/execution_status_page.dart`:
  - Starts a live Geolocator stream when opened with an errand ID.
  - Updates runner location in Firestore every time the runner moves by about 10 meters.

After unzipping, run:

```bash
flutter pub get
flutter run
```

Note: public OpenStreetMap tiles are okay for testing/MVP. For production with many users, use a dedicated tile provider.
