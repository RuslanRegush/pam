import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DoctorSearchScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class DoctorSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile button click
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        'Seattle, USA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_none),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search doctor...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Categories
              Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCategoryItem('Dentistry', Icons.medical_services),
                  _buildCategoryItem('Cardiology', Icons.favorite),
                  _buildCategoryItem('Pulmonology', Icons.air),
                  _buildCategoryItem('General', Icons.local_hospital),
                  _buildCategoryItem('Neurology', Icons.psychology),
                  _buildCategoryItem('Gastroenterology', Icons.restaurant_menu),
                  _buildCategoryItem('Laboratory', Icons.science),
                  _buildCategoryItem('Vaccination', Icons.vaccines),
                ],
              ),
              SizedBox(height: 16),
              // Nearby Medical Centers
              Text('Nearby Medical Centers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMedicalCenterCard('Sunrise Health Clinic', '5.0', '2.5 km'),
                    _buildMedicalCenterCard('Golden Cardiology', '4.9', '2.5 km'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Doctor List
              Text('532 found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              _buildDoctorCard('Dr. David Patel', 'Cardiologist', '5.0', '1.872 Reviews'),
              _buildDoctorCard('Dr. Jessica Turner', 'Gynecologist', '4.9', '1.987 Reviews'),
              _buildDoctorCard('Dr. Michael Johnson', 'Orthopedic Surgeon', '4.7', '2.523 Reviews'),
              _buildDoctorCard('Dr. Emily Walker', 'Pediatrics', '5.0', '405 Reviews'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          child: Icon(icon, size: 24),
        ),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMedicalCenterCard(String name, String rating, String distance) {
    return Card(
      child: Container(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset('assets/clinic_image.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('$rating ★', style: TextStyle(color: Colors.orange)),
                  Text('$distance away', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(String name, String specialty, String rating, String reviews) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/doctor_image.png'),
        ),
        title: Text(name),
        subtitle: Text(specialty),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$rating ★', style: TextStyle(color: Colors.orange)),
            Text('$reviews'),
          ],
        ),
      ),
    );
  }
}
