# Accepted Task Progress Implementation

This project has been updated so runner-accepted errands are shown from Firebase in `execution_status_page.dart`.

## Flow

1. Runner accepts an errand in `gig_finder_page.dart`.
2. `ErrandService.acceptErrand()` saves:
   - `runnerId`
   - `runnerName`
   - `status: accepted`
   - `visibleToRunners: false`
   - `acceptedAt`
3. The app navigates to `/execution-status` with the accepted `errandId` as the route argument.
4. `execution_status_page.dart` reads the exact errand with `ErrandService.errandStream(errandId)`.
5. The page shows the real service type, requester, budget, address, date, time, instructions, and progress status from Firebase.
6. Runner can update progress:
   - Accepted -> In Progress
   - In Progress -> On the Way
   - On the Way -> Completed
7. When Start Task is tapped, live runner location updates start.

## Files changed

- `lib/services/errand_service.dart`
- `lib/execution_status_page.dart`

## New service methods

- `errandStream(String errandId)`
- `activeRunnerErrandsStream()`
- `updateErrandProgress({required String errandId, required String status})`

## Status values

- `accepted`
- `in_progress`
- `on_the_way`
- `completed`
