import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ErrandService {
  ErrandService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get errands =>
      _db.collection('errands');
  static CollectionReference<Map<String, dynamic>> get notifications =>
      _db.collection('notifications');
  static CollectionReference<Map<String, dynamic>> get users =>
      _db.collection('users');
  static CollectionReference<Map<String, dynamic>> get reviews =>
      _db.collection('reviews');

  static String? get currentUserId => _auth.currentUser?.uid;

  static String _filterForService(String serviceType) {
    final value = serviceType.toLowerCase();
    if (value.contains('food')) return 'Food';
    if (value.contains('school')) return 'School';
    if (value.contains('print')) return 'Printing';
    if (value.contains('parcel')) return 'Parcel';
    if (value.contains('laundry')) return 'Laundry';
    return 'Other';
  }

  static User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Please sign in first.');
    return user;
  }

  static Future<Map<String, dynamic>> _currentUserData() async {
    final user = _requireUser();
    final snap = await users.doc(user.uid).get();
    final data = snap.data() ?? <String, dynamic>{};
    return {
      ...data,
      'uid': user.uid,
      'email': user.email,
      'fullName':
          data['fullName'] ??
          user.displayName ??
          user.email?.split('@').first ??
          'User',
    };
  }

  static Future<String> postErrand({
    required String serviceType,
    required String serviceAddress,
    required String instructions,
    String preferredDate = 'Today',
    String timeSlot = 'Morning (8 AM - 12 PM)',
    String budget = '₱120',
    double? serviceLat,
    double? serviceLng,
  }) async {
    final user = _requireUser();
    final profile = await _currentUserData();

    final doc = await errands.add({
      'requesterId': user.uid,
      'requesterName': profile['fullName'],
      'requesterEmail': profile['email'],
      'runnerId': null,
      'runnerName': null,
      'status': 'pending_payment',
      'paymentStatus': 'unpaid',
      'visibleToRunners': false,
      'serviceType': serviceType,
      'title': serviceType,
      'category': serviceType,
      'filter': _filterForService(serviceType),
      'serviceAddress': serviceAddress,
      'serviceLat': serviceLat,
      'serviceLng': serviceLng,
      'pickup': serviceAddress,
      'dropoff': serviceAddress,
      'instructions': instructions,
      'preferredDate': preferredDate,
      'timeSlot': timeSlot,
      'budget': budget,
      'pay': budget,
      'scope': 'Panabo City',
      'participants': [user.uid],
      'lastMessage': '',
      'lastMessageAt': null,
      'unreadBy': {user.uid: false},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> openErrandsStream() {
    return errands.where('visibleToRunners', isEqualTo: true).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> requesterErrandsStream() {
    final user = _requireUser();
    return errands.where('requesterId', isEqualTo: user.uid).snapshots();
  }

  static Future<DocumentReference<Map<String, dynamic>>?>
  latestRequesterErrand({
    Set<String> allowedStatuses = const {
      'pending_payment',
      'posted',
      'paid',
      'booked',
      'booked_paid',
    },
  }) async {
    final user = _requireUser();
    final snapshot = await errands
        .where('requesterId', isEqualTo: user.uid)
        .get();
    final docs = snapshot.docs.toList()
      ..sort((a, b) {
        final ta = a.data()['createdAt'];
        final tb = b.data()['createdAt'];
        if (ta is Timestamp && tb is Timestamp) return tb.compareTo(ta);
        return 0;
      });

    for (final doc in docs) {
      final status = (doc.data()['status'] ?? '').toString();
      if (allowedStatuses.contains(status)) return doc.reference;
    }
    return null;
  }

  static Future<void> bookRunner({
    required String runnerId,
    required String runnerName,
    required String runnerRole,
  }) async {
    final requester = await _currentUserData();
    final errandRef = await latestRequesterErrand(
      allowedStatuses: {'pending_payment', 'posted', 'paid'},
    );
    if (errandRef == null) {
      throw Exception('No errand found. Please post an errand first.');
    }

    final errandSnapshot = await errandRef.get();
    final errand = errandSnapshot.data() ?? {};
    final title = (errand['serviceType'] ?? errand['title'] ?? 'Errand')
        .toString();
    final address = (errand['serviceAddress'] ?? 'Panabo City').toString();
    final paid = (errand['paymentStatus'] ?? 'unpaid') == 'paid';

    await errandRef.update({
      'runnerId': runnerId,
      'runnerName': runnerName,
      'runnerRole': runnerRole,
      'status': paid ? 'booked_paid' : 'pending_payment',
      'visibleToRunners': paid,
      'bookedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'participants': FieldValue.arrayUnion([requester['uid'], runnerId]),
      'unreadBy.${requester['uid']}': false,
      'unreadBy.$runnerId': false,
    });

    await notifications.add({
      'receiverId': runnerId,
      'receiverName': runnerName,
      'senderId': requester['uid'],
      'senderName': requester['fullName'],
      'errandId': errandRef.id,
      'type': paid ? 'booking_paid' : 'booking_pending_payment',
      'title': paid ? 'You got booked' : 'Booking pending payment',
      'body': paid
          ? '${requester['fullName']} booked and paid you for $title at $address.'
          : '${requester['fullName']} selected you for $title. Waiting for payment.',
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> payLatestRequesterErrand() async {
    final requester = await _currentUserData();
    final errandRef = await latestRequesterErrand(
      allowedStatuses: {
        'pending_payment',
        'posted',
        'booked',
        'paid',
        'booked_paid',
      },
    );
    if (errandRef == null) throw Exception('No errand found to pay.');

    final errandSnapshot = await errandRef.get();
    final errand = errandSnapshot.data() ?? {};
    final runnerId = errand['runnerId']?.toString();
    final runnerName = errand['runnerName']?.toString();
    final title = (errand['serviceType'] ?? errand['title'] ?? 'Errand')
        .toString();
    final address = (errand['serviceAddress'] ?? 'Panabo City').toString();

    await errandRef.update({
      'paymentStatus': 'paid',
      'status': runnerId == null || runnerId.isEmpty ? 'paid' : 'booked_paid',
      'visibleToRunners': true,
      'paidAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (runnerId != null && runnerId.isNotEmpty) {
      await notifications.add({
        'receiverId': runnerId,
        'receiverName': runnerName ?? 'Runner',
        'senderId': requester['uid'],
        'senderName': requester['fullName'],
        'errandId': errandRef.id,
        'type': 'booking_paid',
        'title': 'You got booked',
        'body':
            '${requester['fullName']} booked and paid you for $title at $address.',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> acceptErrand({required String errandId}) async {
    final runner = await _currentUserData();
    if ((runner['role'] ?? '') != 'runner') {
      throw Exception('Only runner accounts can accept errands.');
    }

    final errandRef = errands.doc(errandId);
    final errandSnapshot = await errandRef.get();
    final errand = errandSnapshot.data() ?? {};
    final assignedRunnerId = errand['runnerId']?.toString();
    if (assignedRunnerId != null &&
        assignedRunnerId.isNotEmpty &&
        assignedRunnerId != runner['uid']) {
      throw Exception('This errand is assigned to another runner.');
    }

    final requesterId = (errand['requesterId'] ?? '').toString();
    final requesterName = (errand['requesterName'] ?? 'Requester').toString();
    final title = (errand['serviceType'] ?? errand['title'] ?? 'Errand')
        .toString();

    await errandRef.update({
      'runnerId': runner['uid'],
      'runnerName': runner['fullName'],
      'runnerRole': runner['role'],
      'status': 'accepted',
      'visibleToRunners': false,
      'acceptedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'participants': FieldValue.arrayUnion([requesterId, runner['uid']]),
      'unreadBy.$requesterId': false,
      'unreadBy.${runner['uid']}': false,
    });

    if (requesterId.isNotEmpty) {
      await notifications.add({
        'receiverId': requesterId,
        'receiverName': requesterName,
        'senderId': runner['uid'],
        'senderName': runner['fullName'],
        'errandId': errandId,
        'type': 'accepted',
        'title': 'Runner accepted your errand',
        'body': '${runner['fullName']} accepted $title.',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> updateRunnerLocation({
    required String errandId,
    required double lat,
    required double lng,
  }) async {
    final runner = await _currentUserData();

    await errands.doc(errandId).update({
      'runnerId': runner['uid'],
      'runnerName': runner['fullName'],
      'runnerLat': lat,
      'runnerLng': lng,
      'runnerLocationUpdatedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }



  static Stream<DocumentSnapshot<Map<String, dynamic>>> errandStream(
    String errandId,
  ) {
    return errands.doc(errandId).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> activeRunnerErrandsStream() {
    final user = _requireUser();

    return errands
        .where('runnerId', isEqualTo: user.uid)
        .where(
          'status',
          whereIn: [
            'accepted',
            'in_progress',
            'on_the_way',
          ],
        )
        .snapshots();
  }

  static Future<void> updateErrandProgress({
    required String errandId,
    required String status,
  }) async {
    final updateData = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (status == 'in_progress') {
      updateData['startedAt'] = FieldValue.serverTimestamp();
    } else if (status == 'on_the_way') {
      updateData['onTheWayAt'] = FieldValue.serverTimestamp();
    } else if (status == 'completed') {
      updateData['completedAt'] = FieldValue.serverTimestamp();
      updateData['visibleToRunners'] = false;
    }

    await errands.doc(errandId).update(updateData);
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream() {
    final user = _requireUser();

    return errands
        .where('participants', arrayContains: user.uid)
        .snapshots();
  }

  static Future<void> markConversationRead(String errandId) async {
    final user = _requireUser();

    await errands.doc(errandId).set({
      'unreadBy': {user.uid: false},
    }, SetOptions(merge: true));
  }

  static CollectionReference<Map<String, dynamic>> messagesRef(
    String errandId,
  ) {
    return errands.doc(errandId).collection('messages');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(
    String errandId,
  ) {
    return messagesRef(errandId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String errandId,
    required String text,
  }) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    final userData = await _currentUserData();
    final senderId = userData['uid'].toString();
    final senderName = (userData['fullName'] ?? userData['name'] ?? 'User')
        .toString();

    final errandRef = errands.doc(errandId);
    final errandSnapshot = await errandRef.get();
    final errandData = errandSnapshot.data() ?? <String, dynamic>{};

    final requesterId = (errandData['requesterId'] ?? '').toString();
    final runnerId = (errandData['runnerId'] ?? '').toString();

    String? receiverId;
    if (senderId == requesterId && runnerId.isNotEmpty) {
      receiverId = runnerId;
    } else if (senderId == runnerId && requesterId.isNotEmpty) {
      receiverId = requesterId;
    }

    final participantIds = <String>{
      if (requesterId.isNotEmpty) requesterId,
      if (runnerId.isNotEmpty) runnerId,
      senderId,
      if (receiverId != null && receiverId.isNotEmpty) receiverId,
    }.toList();

    final messageRef = messagesRef(errandId).doc();
    final batch = _db.batch();

    batch.set(messageRef, {
      'senderId': senderId,
      'senderName': senderName,
      'text': cleanText,
      'type': 'text',
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtLocal': Timestamp.now(),
    });

    final updateData = <String, dynamic>{
      'lastMessage': cleanText,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'participants': FieldValue.arrayUnion(participantIds),
      'unreadBy.$senderId': false,
    };

    if (receiverId != null && receiverId.isNotEmpty) {
      updateData['unreadBy.$receiverId'] = true;
    }

    batch.set(errandRef, updateData, SetOptions(merge: true));

    await batch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
  currentUserNotificationsStream() {
    final user = _requireUser();
    return notifications.where('receiverId', isEqualTo: user.uid).snapshots();
  }

  static Future<void> rateUser({
    required String ratedUserId,
    required int rating,
    required String errandId,
    String comment = '',
  }) async {
    final reviewer = await _currentUserData();
    if (rating < 1 || rating > 5) throw Exception('Rating must be 1 to 5.');

    await reviews.add({
      'errandId': errandId,
      'ratedUserId': ratedUserId,
      'reviewerId': reviewer['uid'],
      'reviewerName': reviewer['fullName'],
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final reviewSnap = await reviews
        .where('ratedUserId', isEqualTo: ratedUserId)
        .get();
    double total = 0;
    for (final doc in reviewSnap.docs) {
      final value = doc.data()['rating'];
      if (value is num) total += value.toDouble();
    }
    final count = reviewSnap.docs.length;
    final average = count == 0 ? 0.0 : total / count;
    await users.doc(ratedUserId).set({
      'averageRating': double.parse(average.toStringAsFixed(2)),
      'ratingCount': count,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
