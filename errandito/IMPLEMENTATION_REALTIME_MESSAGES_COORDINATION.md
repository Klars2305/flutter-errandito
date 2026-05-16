# Realtime Messages + Runner Coordination

This build replaces the fake/static messages list with Firestore-backed realtime conversation lists.

## Requester

`lib/messages_page.dart` now listens to:

```text
errands where participants array contains current user uid
```

It displays the runner name, service type, last message, status, and unread badge.

## Runner

`lib/coordination_page.dart` now listens to the same Firestore conversation stream but displays the requester name and requester role.

## Shared chat

Both pages open:

```dart
Navigator.pushNamed(
  context,
  '/execution-messaging',
  arguments: errandId,
);
```

The shared chat page writes to:

```text
errands/{errandId}/messages/{messageId}
```

and updates the parent errand:

```text
lastMessage
lastMessageAt
unreadBy
participants
```

## Important Firestore fields

Each errand document should include:

```text
participants: [requesterUid, runnerUid]
lastMessage: "latest chat text"
lastMessageAt: timestamp
unreadBy: {
  requesterUid: true/false,
  runnerUid: true/false
}
```

The code now sets these during posting, booking, accepting, and sending messages.

## Firestore rules reminder

Rules for `errands/{errandId}` do not automatically apply to `errands/{errandId}/messages/{messageId}`.
You must include a nested messages rule. See `FIREBASE_RULES_FOR_FUNCTIONAL_FLOW.txt` for temporary testing rules.
