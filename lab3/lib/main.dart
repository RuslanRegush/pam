import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DoctorFinderApp());
}

class DoctorFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Finder',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  List<Map<String, dynamic>> banners = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> nearbyCenters = [];
  List<Map<String, dynamic>> doctors = [];

  String selectedLocation = '';
  List<Map<String, dynamic>> filteredDoctors = [];
  String searchQuery = '';
  String selectedClinic = 'Health Center 1, USA';
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/json/v1.json');
    final data = json.decode(response);

    setState(() {
      banners = List<Map<String, dynamic>>.from(data['banners']);
      categories = List<Map<String, dynamic>>.from(data['categories']);
      nearbyCenters = List<Map<String, dynamic>>.from(data['nearby_centers']);
      doctors = List<Map<String, dynamic>>.from(data['doctors']);
    });

    _filterDoctors();
  }

  void _filterDoctors() {
    setState(() {
      filteredDoctors = doctors;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _filterDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildLocationAndSearch(),
          _buildImageSlider(),
          _buildCategories(),
          _buildNearbyClinics(),
          _buildDoctorsList(),
        ],
      ),
    );
  }

  Widget _buildLocationAndSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildLocationSelector(),
          SizedBox(height: 16),
          _buildSearchByName(),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: selectedLocation),
            decoration: InputDecoration(
              hintText: 'Select location...',
              prefixIcon: Icon(Icons.location_on),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            readOnly: true,
            onTap: () {
              _showLocationDialog();
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
            _showLocationDialog();
          },
        ),
      ],
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Location"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: nearbyCenters.map((clinic) {
                return ListTile(
                  title: Text(clinic['title']!),
                  subtitle: Text(clinic['location_name']!),
                  onTap: () {
                    setState(() {
                      selectedLocation = clinic['location_name']!;
                      selectedClinic = clinic['title']!;
                      _filterDoctors();
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchByName() {
    return TextField(
      onChanged: _updateSearchQuery,
      decoration: InputDecoration(
        hintText: 'Search doctor...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  _toggleCategory(category['title']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedCategories.contains(category['title'])
                        ? Colors.blueAccent
                        : Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(category['icon']!),
                      ),
                      SizedBox(height: 5),
                      Text(
                        category['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
      _filterDoctors();
    });
  }

  Widget _buildImageSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(banners[index]['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _currentPage == index ? 30 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyClinics() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nearby Medical Centers",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: nearbyCenters.map((clinic) {
              return ListTile(
                leading: Image.network(clinic['image']!),
                title: Text(clinic['title']!),
                subtitle: Text(
                    '${clinic['location_name']} • Rating: ${clinic['review_rate']}'),
                trailing: Text('${clinic['distance_km']} km'),
                onTap: () {
                  setState(() {
                    selectedLocation = clinic['location_name']!;
                    selectedClinic = clinic['title']!;
                    _filterDoctors();
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Doctors", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          filteredDoctors.isEmpty
              ? Text("No doctors found")
              : Column(
                  children: filteredDoctors.map((doctor) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: doctor['image'] != null
                            ? NetworkImage(doctor['image']!)
                            : AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                      ),
                      title: Text(doctor['full_name']!),
                      subtitle: Text(doctor['type_of_doctor']!),
                      onTap: () {
                        // You can add functionality to navigate to the doctor's details page
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
