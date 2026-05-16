// booking_details.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import 'services/errand_service.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color green = Color(0xFF004035);
  static const Color borderColor = Color(0xFFC0C7CE);
  static const Color lightPanel = Color(0xFFF2F3F7);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  static const Color background = BookingDetailsPage.background;
  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;
  static const Color darkText = BookingDetailsPage.darkText;
  static const Color bodyText = BookingDetailsPage.bodyText;
  static const Color borderColor = BookingDetailsPage.borderColor;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final List<_ServiceChoice> _serviceChoices = const [
    _ServiceChoice(
      'Food Delivery',
      Icons.fastfood_rounded,
      'Food pickup or meal delivery.',
    ),
    _ServiceChoice(
      'School Errand',
      Icons.school_rounded,
      'School documents, supplies, or campus errands.',
    ),
    _ServiceChoice(
      'Printing Service',
      Icons.print_rounded,
      'Print, photocopy, or document pickup.',
    ),
    _ServiceChoice(
      'Parcel Pickup',
      Icons.inventory_2_rounded,
      'Pickup or deliver parcels around Panabo.',
    ),
    _ServiceChoice(
      'Laundry Pickup',
      Icons.local_laundry_service_rounded,
      'Laundry pickup and drop-off errands.',
    ),
  ];

  String _selectedServiceType = 'Food Delivery';
  DateTime? _preferredDate;
  String _selectedTimeSlot = 'Morning (8 AM - 12 PM)';
  bool _isPosting = false;

  double? _serviceLat;
  double? _serviceLng;
  Timer? _mapReverseGeocodeDebounce;

  final List<String> _timeSlots = const [
    'Morning (8 AM - 12 PM)',
    'Afternoon (1 PM - 5 PM)',
    'Evening (6 PM - 9 PM)',
  ];

  @override
  void dispose() {
    _mapReverseGeocodeDebounce?.cancel();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  String get _preferredDateText {
    if (_preferredDate == null) return 'Choose date';
    final d = _preferredDate!;
    return '${d.month.toString().padLeft(2, '0')} / ${d.day.toString().padLeft(2, '0')} / ${d.year}';
  }

  Future<void> _pickPreferredDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: navy,
              onPrimary: Colors.white,
              onSurface: darkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _preferredDate = picked);
    }
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  Future<void> _postErrandAndContinue() async {
    final String address = _addressController.text.trim();
    final String instructions = _instructionsController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the service location first.'),
        ),
      );
      return;
    }

    if (_preferredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose your preferred date.')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final String errandId = await ErrandService.postErrand(
        serviceType: _selectedServiceType,
        serviceAddress: address,
        instructions: instructions,
        preferredDate: _preferredDateText,
        timeSlot: _selectedTimeSlot,
        budget: '₱120',
        serviceLat: _serviceLat,
        serviceLng: _serviceLng,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errand posted successfully. ID: $errandId')),
      );

      Navigator.pushNamed(context, '/select-helper');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to post errand: $e')));
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  Future<String> _placeNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'addressdetails': '1',
      });

      final headers = <String, String>{
        'Accept': 'application/json',
        if (!kIsWeb) 'User-Agent': 'Errandito Flutter App',
      };

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final address = decoded['address'];

        if (address is Map<String, dynamic>) {
          final parts = [
            address['road'],
            address['neighbourhood'],
            address['suburb'],
            address['village'],
            address['town'],
            address['city'],
            address['municipality'],
            address['county'],
            address['state'],
          ];

          final readable = parts
              .where(
                (part) => part != null && part.toString().trim().isNotEmpty,
              )
              .map((part) => part.toString().trim())
              .toSet()
              .join(', ');

          if (readable.isNotEmpty) return readable;
        }

        final displayName = decoded['display_name']?.toString().trim();

        if (displayName != null && displayName.isNotEmpty) {
          return displayName
              .split(',')
              .take(4)
              .map((part) => part.trim())
              .join(', ');
        }
      }
    } catch (_) {}

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final parts = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
        ];

        final readable = parts
            .where((part) => part != null && part.trim().isNotEmpty)
            .map((part) => part!.trim())
            .toSet()
            .join(', ');

        if (readable.isNotEmpty) return readable;
      }
    } catch (_) {}

    return 'Selected location near Panabo City';
  }

  Future<void> _useCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please turn on location services.')),
      );

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );

      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission is permanently denied. Enable it in settings.',
          ),
        ),
      );

      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    if (!mounted) return;

    setState(() {
      _serviceLat = position.latitude;
      _serviceLng = position.longitude;
      _addressController.text = 'Finding place name...';
    });

    final placeName = await _placeNameFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (!mounted) return;

    setState(() {
      _serviceLat = position.latitude;
      _serviceLng = position.longitude;
      _addressController.text = placeName;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Current location selected.')));
  }

  void _onMapLocationChanged(LatLng point) {
    _mapReverseGeocodeDebounce?.cancel();

    _mapReverseGeocodeDebounce = Timer(
      const Duration(milliseconds: 700),
      () async {
        if (!mounted) return;

        setState(() {
          _serviceLat = point.latitude;
          _serviceLng = point.longitude;
          _addressController.text = 'Finding selected place...';
        });

        final placeName = await _placeNameFromCoordinates(
          point.latitude,
          point.longitude,
        );

        if (!mounted) return;

        setState(() {
          _serviceLat = point.latitude;
          _serviceLng = point.longitude;
          _addressController.text = placeName;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isNarrow = width <= 390;
    final bool twoColumns = width >= 420;
    final double horizontalPadding = isNarrow ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                124,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BookingTopBar(onBackTap: _goBack),
                      const SizedBox(height: 16),
                      const _BookingHeroCard(),
                      const SizedBox(height: 18),
                      const _SectionTitle(
                        icon: Icons.widgets_rounded,
                        title: 'Choose Errand Type',
                      ),
                      const SizedBox(height: 12),
                      _ServiceTypePicker(
                        services: _serviceChoices,
                        selected: _selectedServiceType,
                        onChanged: (value) {
                          setState(() => _selectedServiceType = value);
                        },
                      ),
                      const SizedBox(height: 18),
                      _SelectedServiceCard(
                        service: _serviceChoices.firstWhere(
                          (item) => item.title == _selectedServiceType,
                          orElse: () => _serviceChoices.first,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _SectionTitle(
                        icon: Icons.location_on_rounded,
                        title: 'Service Location',
                      ),
                      const SizedBox(height: 12),
                      _LocationField(
                        controller: _addressController,
                        onUseCurrentLocation: _useCurrentLocation,
                      ),
                      const SizedBox(height: 12),
                      _MapPreviewCard(
                        addressController: _addressController,
                        serviceLat: _serviceLat,
                        serviceLng: _serviceLng,
                        onTap: _useCurrentLocation,
                        onLocationChanged: _onMapLocationChanged,
                      ),
                      const SizedBox(height: 18),
                      if (twoColumns)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DateBlock(
                                value: _preferredDateText,
                                onTap: _pickPreferredDate,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TimeBlock(
                                value: _selectedTimeSlot,
                                slots: _timeSlots,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedTimeSlot = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            DateBlock(
                              value: _preferredDateText,
                              onTap: _pickPreferredDate,
                            ),
                            const SizedBox(height: 14),
                            TimeBlock(
                              value: _selectedTimeSlot,
                              slots: _timeSlots,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedTimeSlot = value);
                                }
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 18),
                      const _SectionTitle(
                        icon: Icons.notes_rounded,
                        title: 'Specific Instructions',
                      ),
                      const SizedBox(height: 12),
                      _InstructionBox(controller: _instructionsController),
                      const SizedBox(height: 16),
                      const _TrustNotice(),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomActionBar(
                horizontalPadding: horizontalPadding,
                isPosting: _isPosting,
                onContinue: _isPosting ? null : _postErrandAndContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceChoice {
  final String title;
  final IconData icon;
  final String description;

  const _ServiceChoice(this.title, this.icon, this.description);
}

class _BookingTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const _BookingTopBar({required this.onBackTap});

  static const Color navy = BookingDetailsPage.navy;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _IconCircle(icon: Icons.arrow_back_rounded, onTap: onBackTap),
            const SizedBox(width: 12),
            const Text(
              'Book a Service',
              style: TextStyle(
                color: navy,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _IconCircle(icon: Icons.notifications_rounded, onTap: () {}),
            const SizedBox(width: 10),
            _IconCircle(icon: Icons.person_rounded, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _BookingHeroCard extends StatelessWidget {
  const _BookingHeroCard();

  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, teal],
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set up your errand',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Choose the errand type, set the date and time, then book a real runner account.',
            style: TextStyle(
              color: Color(0xFFE5F4F7),
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTypePicker extends StatelessWidget {
  final List<_ServiceChoice> services;
  final String selected;
  final ValueChanged<String> onChanged;

  const _ServiceTypePicker({
    required this.services,
    required this.selected,
    required this.onChanged,
  });

  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;
  static const Color bodyText = BookingDetailsPage.bodyText;
  static const Color borderColor = BookingDetailsPage.borderColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: services.map((service) {
        final bool active = service.title == selected;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onChanged(service.title),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: MediaQuery.of(context).size.width >= 420 ? 130 : null,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: active ? navy : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: active ? navy : borderColor),
                boxShadow: [
                  BoxShadow(
                    color: navy.withOpacity(active ? 0.14 : 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    service.icon,
                    color: active ? Colors.white : teal,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active ? Colors.white : bodyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SelectedServiceCard extends StatelessWidget {
  final _ServiceChoice service;

  const _SelectedServiceCard({required this.service});

  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;
  static const Color bodyText = BookingDetailsPage.bodyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 64,
            decoration: BoxDecoration(
              color: teal,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(service.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  service.description,
                  style: const TextStyle(
                    color: bodyText,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onUseCurrentLocation;

  const _LocationField({
    required this.controller,
    required this.onUseCurrentLocation,
  });

  static const Color navy = BookingDetailsPage.navy;
  static const Color borderColor = BookingDetailsPage.borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter delivery address or landmark in Panabo...',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.place_outlined, color: navy),
        suffixIcon: IconButton(
          tooltip: 'Use my current location',
          onPressed: onUseCurrentLocation,
          icon: const Icon(Icons.my_location_rounded, color: Color(0xFF94A3B8)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: navy, width: 1.4),
        ),
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  final TextEditingController addressController;
  final double? serviceLat;
  final double? serviceLng;
  final VoidCallback onTap;
  final ValueChanged<LatLng> onLocationChanged;

  const _MapPreviewCard({
    required this.addressController,
    required this.serviceLat,
    required this.serviceLng,
    required this.onTap,
    required this.onLocationChanged,
  });

  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;
  static const Color bodyText = BookingDetailsPage.bodyText;

  static const LatLng panaboCenter = LatLng(7.3081, 125.6841);

  @override
  Widget build(BuildContext context) {
    final String address = addressController.text.trim().isEmpty
        ? 'Drag the map to choose your service location'
        : addressController.text.trim();

    final LatLng mapCenter = serviceLat != null && serviceLng != null
        ? LatLng(serviceLat!, serviceLng!)
        : panaboCenter;

    return Container(
      height: 360,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF1),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          FlutterMap(
            key: ValueKey('${mapCenter.latitude},${mapCenter.longitude}'),
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags:
                    InteractiveFlag.drag |
                    InteractiveFlag.flingAnimation |
                    InteractiveFlag.pinchMove |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom |
                    InteractiveFlag.scrollWheelZoom,
              ),
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) {
                  onLocationChanged(camera.center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.errandito',
              ),
            ],
          ),
          const Center(
            child: IgnorePointer(
              child: Icon(Icons.location_on_rounded, color: navy, size: 54),
            ),
          ),
          Positioned(
            left: 14,
            top: 14,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_with_rounded, color: navy, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Drag map to choose location',
                      style: TextStyle(
                        color: navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: navy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.96),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.place_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected service location',
                          style: TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: bodyText,
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionBox extends StatelessWidget {
  final TextEditingController controller;

  const _InstructionBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 5,
      maxLines: 8,
      decoration: InputDecoration(
        hintText:
            'Add details for the runner, pickup notes, item list, or delivery instructions...',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          height: 1.5,
        ),
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _TrustNotice extends StatelessWidget {
  const _TrustNotice();

  static const Color green = BookingDetailsPage.green;
  static const Color bodyText = BookingDetailsPage.bodyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD8DADD).withOpacity(0.30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: green, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Only real runner accounts are shown after posting your errand.',
              style: TextStyle(
                color: bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final double horizontalPadding;
  final bool isPosting;
  final VoidCallback? onContinue;

  const _BottomActionBar({
    required this.horizontalPadding,
    required this.isPosting,
    required this.onContinue,
  });

  static const Color navy = BookingDetailsPage.navy;
  static const Color teal = BookingDetailsPage.teal;
  static const Color darkText = BookingDetailsPage.darkText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        14,
        horizontalPadding,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        boxShadow: [
          BoxShadow(
            color: darkText.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [navy, teal],
                ),
                boxShadow: [
                  BoxShadow(
                    color: navy.withOpacity(0.20),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onContinue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPosting)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        if (isPosting) const SizedBox(width: 12),
                        Text(
                          isPosting
                              ? 'Posting Errand...'
                              : 'Post Errand & Choose Runner',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.45,
                          ),
                        ),
                        if (!isPosting) const SizedBox(width: 10),
                        if (!isPosting)
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircle({required this.icon, required this.onTap});

  @override
  State<_IconCircle> createState() => _IconCircleState();
}

class _IconCircleState extends State<_IconCircle> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: _hovering
            ? BookingDetailsPage.navy.withOpacity(0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(widget.icon, color: BookingDetailsPage.navy, size: 21),
          ),
        ),
      ),
    );
  }
}

class DateBlock extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const DateBlock({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _InputCard(
      icon: Icons.calendar_month_rounded,
      title: 'Preferred Date',
      value: value,
      trailing: Icons.edit_calendar_outlined,
      onTap: onTap,
    );
  }
}

class TimeBlock extends StatelessWidget {
  final String value;
  final List<String> slots;
  final ValueChanged<String?> onChanged;

  const TimeBlock({
    super.key,
    required this.value,
    required this.slots,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          icon: Icons.access_time_filled_rounded,
          title: 'Time Slot',
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: BookingDetailsPage.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: BookingDetailsPage.navy,
              ),
              isExpanded: true,
              borderRadius: BorderRadius.circular(16),
              items: slots.map((slot) {
                return DropdownMenuItem(value: slot, child: Text(slot));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final IconData trailing;
  final VoidCallback? onTap;

  const _InputCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.trailing,
    this.onTap,
  });

  static const Color navy = BookingDetailsPage.navy;
  static const Color darkText = BookingDetailsPage.darkText;
  static const Color borderColor = BookingDetailsPage.borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: icon, title: title),
        const SizedBox(height: 10),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(trailing, color: navy, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  static const Color navy = BookingDetailsPage.navy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: navy, size: 20),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
