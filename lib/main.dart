// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'climate_analysis.dart';
import 'my_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language');
  runApp(MyApp(initialLanguage: languageCode ?? ''));
}

class MyApp extends StatelessWidget {
  final String initialLanguage;
  MyApp({required this.initialLanguage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'app_title'.tr,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      translations: MyTranslations(),
      locale: initialLanguage.isNotEmpty ? Locale(initialLanguage) : Locale('en'),
      fallbackLocale: Locale('en'),
      home: initialLanguage.isNotEmpty ? HomeScreen() : LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select_language'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('select_language'.tr,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLanguageCard('en', 'English'),
                  SizedBox(width: 10),
                  _buildLanguageCard('hi', 'हिन्दी'),
                  SizedBox(width: 10),
                  _buildLanguageCard('te', 'తెలుగు'),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.setString('language', _selectedLanguage);
                  Get.updateLocale(Locale(_selectedLanguage));
                  Get.offAll(HomeScreen());
                },
                child: Text('continue'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String langCode, String languageName) {
    bool isSelected = _selectedLanguage == langCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = langCode;
        });
      },
      child: Card(
        color: isSelected ? Colors.greenAccent : Colors.white,
        elevation: 4,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Text(
            languageName,
            style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.black : Colors.grey[800]),
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = Get.locale?.languageCode ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_language'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('select_language'.tr,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLanguageCard('en', 'English'),
                  SizedBox(width: 10),
                  _buildLanguageCard('hi', 'हिन्दी'),
                  SizedBox(width: 10),
                  _buildLanguageCard('te', 'తెలుగు'),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.setString('language', _selectedLanguage);
                  Get.updateLocale(Locale(_selectedLanguage));
                  Navigator.pop(context);
                },
                child: Text('continue'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLanguageCard(String langCode, String languageName) {
    bool isSelected = _selectedLanguage == langCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = langCode;
        });
      },
      child: Card(
        color: isSelected ? Colors.greenAccent : Colors.white,
        elevation: 4,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Text(
            languageName,
            style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.black : Colors.grey[800]),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // Helper method to build a card-based quick access button.
  Widget _buildMenuButton(
      BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(title.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          // Settings icon to open language settings
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('quick_access'.tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuButton(context, 'weather_forecast', Icons.cloud,
                      Colors.blue, WeatherForecastScreen()),
                  _buildMenuButton(context, 'crop_advisory', Icons.agriculture,
                      Colors.orange, CropAdvisoryScreen()),
                  _buildMenuButton(context, 'soil_health', Icons.grass,
                      Colors.brown, SoilHealthScreen()),
                  _buildMenuButton(context, 'market_prices', Icons.attach_money,
                      Colors.green, MarketPricesScreen()),
                  _buildMenuButton(context, 'emergency_alerts', Icons.warning,
                      Colors.red, EmergencyAlertsScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------
// Weather Forecast Screen
// ------------------------
class WeatherForecastScreen extends StatefulWidget {
  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}
class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  LocationData? _currentPosition;
  GoogleMapController? _mapController;
  final Location _location = Location();
  bool _loading = false;
  Map<String, dynamic>? _analysisData;
  bool _analysisLoading = false;
  List<String> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadSavedLocations();
  }

  Future<void> _getLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return;
      }
      LocationData locationData = await _location.getLocation();
      setState(() {
        _currentPosition = locationData;
        _loading = false;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    } catch (e) {
      print(e);
      setState(() => _loading = false);
    }
  }

  void _openInMapApp() async {
    if (_currentPosition == null) return;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _getClimateAnalysis() async {
    if (_currentPosition == null) return;
    setState(() {
      _analysisLoading = true;
    });
    try {
      final analysis = await fetchFullClimateAnalysis(
          _currentPosition!.latitude!, _currentPosition!.longitude!);
      print("Fetched Analysis Data: $analysis");
      setState(() {
        _analysisData = analysis;
        _analysisLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _analysisLoading = false;
      });
    }
  }

  Future<void> _saveLocation() async {
    if (_currentPosition == null) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> savedLocations = prefs.getStringList('saved_locations') ?? [];
    String coordinates =
        "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    bool alreadySaved = savedLocations.any((loc) {
      return loc.split('|')[0] == coordinates;
    });
    if (!alreadySaved) {
      String locationString =
          "$coordinates|${DateTime.now().toIso8601String()}";
      savedLocations.add(locationString);
      await prefs.setStringList('saved_locations', savedLocations);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Location saved!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Location already saved.")));
    }
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocations = prefs.getStringList('saved_locations') ?? [];
    });
  }

  void _goToSavedLocation(String locationString) {
    final parts = locationString.split('|');
    final coords = parts[0].split(',');
    final double lat = double.tryParse(coords[0]) ?? 0;
    final double lon = double.tryParse(coords[1]) ?? 0;
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
    }
    setState(() {
      _currentPosition = LocationData.fromMap({
        "latitude": lat,
        "longitude": lon,
      });
    });
  }

  Future<void> _deleteSavedLocation(String locationString) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedLocations =
        prefs.getStringList('saved_locations') ?? [];
    savedLocations.remove(locationString);
    await prefs.setStringList('saved_locations', savedLocations);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Location deleted.")));
    _loadSavedLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('weather_forecast'.tr),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 15,
              ),
              markers: _currentPosition != null
                  ? {
                Marker(
                  markerId: MarkerId('current'),
                  position: LatLng(
                    _currentPosition!.latitude!,
                    _currentPosition!.longitude!,
                  ),
                ),
              }
                  : {},
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_currentPosition != null) ...[
                    Text(
                      'Latitude: ${_currentPosition!.latitude!.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Longitude: ${_currentPosition!.longitude!.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _openInMapApp,
                          child: Text('open_maps'.tr),
                        ),
                        ElevatedButton(
                          onPressed: _getLocation,
                          child: Text('get_location'.tr),
                        ),
                        ElevatedButton(
                          onPressed: _saveLocation,
                          child: Text('save_location'.tr),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _analysisLoading ? null : _getClimateAnalysis,
                      child: _analysisLoading
                          ? CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white))
                          : Text('get_analysis'.tr),
                    ),
                    SizedBox(height: 10),
                    if (_analysisData != null) ...[
                      Text("Current Weather:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        "Temperature: ${_analysisData!['currentWeather']['temperature'].toStringAsFixed(1)}°C",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Rainfall: ${_analysisData!['currentWeather']['rainfall'].toStringAsFixed(1)} mm",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Humidity: ${_analysisData!['currentWeather']['humidity']}%",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Wind Speed: ${_analysisData!['currentWeather']['windSpeed'].toStringAsFixed(1)} m/s",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text("7-Day Forecast:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(_analysisData!['forecastSummary'],
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("Custom Alerts:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ..._analysisData!['customAlerts']
                          .map<Widget>((alert) =>
                          Text(alert, style: TextStyle(fontSize: 16)))
                          .toList(),
                    ],
                  ] else if (_loading) ...[
                    CircularProgressIndicator(),
                  ] else ...[
                    Text('Press the button to get location'),
                  ],
                  if (_savedLocations.isNotEmpty) ...[
                    Divider(),
                    Text("Saved Locations:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Column(
                      children: _savedLocations.map((loc) {
                        final parts = loc.split('|');
                        final coordinate = parts[0];
                        final timestamp =
                        parts.length > 1 ? parts[1] : '';
                        return ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(coordinate),
                          subtitle: Text("Saved on: $timestamp"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteSavedLocation(loc);
                            },
                          ),
                          onTap: () {
                            _goToSavedLocation(loc);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}

// ------------------------
// Crop Advisory Screen (Updated)
// ------------------------
class CropAdvisoryScreen extends StatefulWidget {
  @override
  _CropAdvisoryScreenState createState() => _CropAdvisoryScreenState();
}

class _CropAdvisoryScreenState extends State<CropAdvisoryScreen> {
  String? selectedCrop;
  Map<String, String>? recommendations;

  // Dummy data for crop advisory.
  final Map<String, Map<String, String>> cropData = {
    "Wheat": {
      "plantingTime": "October to November",
      "harvestingTime": "April to May",
      "fertilizer": "Use Nitrogen-rich fertilizers for optimal growth.",
      "pesticide": "Apply insecticides if aphids or rust appear.",
      "irrigation": "Irrigate weekly during dry spells.",
      "pestAlerts": "Watch out for aphids and rust disease.",
    },
    "Rice": {
      "plantingTime": "June to July",
      "harvestingTime": "October to November",
      "fertilizer": "Balanced NPK fertilizers recommended.",
      "pesticide": "Use fungicides for blast disease prevention.",
      "irrigation": "Maintain flooded conditions until mid-growth.",
      "pestAlerts": "Monitor for stem borers and plan accordingly.",
    },
    "Maize": {
      "plantingTime": "April to May",
      "harvestingTime": "September to October",
      "fertilizer": "Apply phosphorus and potassium to boost yield.",
      "pesticide": "Use insecticides to control corn borer.",
      "irrigation": "Irrigate every 10 days during critical growth periods.",
      "pestAlerts": "Keep an eye on fall armyworm activity.",
    },
  };

  void _getRecommendations() {
    if (selectedCrop != null && cropData.containsKey(selectedCrop)) {
      setState(() {
        recommendations = cropData[selectedCrop];
      });
    } else {
      setState(() {
        recommendations = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crop_advisory'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: Text("Select a Crop"),
                value: selectedCrop,
                isExpanded: true,
                items: cropData.keys.map((String crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCrop = value;
                    recommendations = null;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getRecommendations,
                child: Text("Get Recommendations"),
              ),
              SizedBox(height: 16),
              if (recommendations != null) ...[
                Text("Best Planting Time: ${recommendations!['plantingTime']}",
                    style: TextStyle(fontSize: 16)),
                Text("Best Harvesting Time: ${recommendations!['harvestingTime']}",
                    style: TextStyle(fontSize: 16)),
                Text("Fertilizer Recommendation: ${recommendations!['fertilizer']}",
                    style: TextStyle(fontSize: 16)),
                Text("Pesticide Recommendation: ${recommendations!['pesticide']}",
                    style: TextStyle(fontSize: 16)),
                Text("Irrigation Schedule: ${recommendations!['irrigation']}",
                    style: TextStyle(fontSize: 16)),
                Text("Pest & Disease Alerts: ${recommendations!['pestAlerts']}",
                    style: TextStyle(fontSize: 16)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------
// Soil Health Screen (Placeholder)
// ------------------------
class SoilHealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('soil_health'.tr)),
      body: Center(child: Text('Soil Health Screen')),
    );
  }
}

// ------------------------
// Market Prices Screen (Placeholder)
// ------------------------
class MarketPricesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('market_prices'.tr)),
      body: Center(child: Text('Market Prices Screen')),
    );
  }
}

// ------------------------
// Emergency Alerts Screen (Placeholder)
// ------------------------
class EmergencyAlertsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('emergency_alerts'.tr)),
      body: Center(child: Text('Emergency Alerts Screen')),
    );
  }
}
