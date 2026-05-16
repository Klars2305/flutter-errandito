# Live Messaging Implementation

This project now uses a Firestore subcollection for each errand chat:

```text
errands/{errandId}/messages/{messageId}
```

## Files changed

- `lib/services/errand_service.dart`
  - Added `currentUserId`
  - Added `messagesRef(errandId)`
  - Added `messagesStream(errandId)`
  - Added `sendMessage(errandId, text)` using a Firestore batch

- `lib/execution_messaging_page.dart`
  - Replaced static sample page with live Firestore chat
  - Receives `errandId` from route arguments
  - Shows realtime messages using `StreamBuilder`
  - Sends messages into `errands/{errandId}/messages`
  - Updates `lastMessage` and `lastMessageAt` on the parent errand
  - Disables sending after status is `completed`

- `lib/execution_status_page.dart`
  - Runner chat button now opens `/execution-messaging` with the accepted `errandId`

- `lib/live_tracking_page.dart`
  - Requester `Message Runner` button now opens `/execution-messaging` with the active `errandId`

## Flow

```text
Runner accepts task
↓
Firestore saves runnerId and status = accepted
↓
Runner opens Execution Status
↓
Runner taps Open Chat
↓
App opens /execution-messaging with errandId
↓
Chat page listens to errands/{errandId}/messages
↓
Requester opens Message Runner from Live Tracking
↓
Requester opens the same errand chat
↓
Messages update live for both users
```

## Firestore fields added to parent errand

```text
lastMessage
lastMessageAt
updatedAt
```

## Message document shape

```js
{
  senderId: "uid",
  senderName: "Full Name",
  text: "Message text",
  type: "text",
  createdAt: timestamp,
  createdAtLocal: timestamp
}
```

## Recommended Firestore rules

Only the requester and assigned runner should read/create messages.

```js
match /errands/{errandId} {
  allow read: if request.auth != null &&
    (resource.data.requesterId == request.auth.uid ||
     resource.data.runnerId == request.auth.uid);

  allow update: if request.auth != null &&
    (resource.data.requesterId == request.auth.uid ||
     resource.data.runnerId == request.auth.uid);

  match /messages/{messageId} {
    allow read: if request.auth != null &&
      (get(/databases/$(database)/documents/errands/$(errandId)).data.requesterId == request.auth.uid ||
       get(/databases/$(database)/documents/errands/$(errandId)).data.runnerId == request.auth.uid);

    allow create: if request.auth != null &&
      (get(/databases/$(database)/documents/errands/$(errandId)).data.requesterId == request.auth.uid ||
       get(/databases/$(database)/documents/errands/$(errandId)).data.runnerId == request.auth.uid) &&
      request.resource.data.senderId == request.auth.uid &&
      request.resource.data.text is string &&
      request.resource.data.text.size() > 0 &&
      request.resource.data.text.size() <= 1000;

    allow update, delete: if false;
  }
}
```
