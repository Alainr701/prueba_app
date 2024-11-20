import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String city = '';
  String temperature = '';
  String description = '';
  String icon = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final position = await _getCurrentLocation();
      final weatherData =
          await getWeather(position.latitude, position.longitude);
      print("object");
      print(weatherData);
      setState(() {
        city = weatherData['name'];
        temperature = '${weatherData['main']['temp']}°C';
        description = weatherData['weather'][0]['description'];
        icon = weatherData['weather'][0]['icon'];
      });
      print(city);
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    const url =
        'http://api.openweathermap.org/data/2.5/forecast?lat=-16.501843&lon=-68.119454&appid=da58336de57fd43ca37a598521c622e6';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están denegados permanentemente.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: Curva(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.blue[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        city,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        temperature,
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    tiempoClima('Monday', '23°', Icons.wb_sunny_outlined),
                    tiempoClima('Tuesday', '18°', Icons.cloud_outlined),
                    tiempoClima('Wednesday', '20°', Icons.wb_sunny_outlined),
                    tiempoClima('Thursday', '15°', Icons.ac_unit_outlined),
                    tiempoClima('Friday', '25°', Icons.wb_sunny_outlined),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              right: 60,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                child: Icon(
                  Icons.add,
                  color: Colors.blue[800],
                  size: 30,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.call_missed_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget tiempoClima(String day, String temperature, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
        ),
        Row(
          children: [
            Text(
              temperature,
            ),
            const SizedBox(width: 10),
            Icon(icon)
          ],
        ),
      ],
    ),
  );
}

class Curva extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 25,
      size.width / 2,
      size.height - 50,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 75,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
