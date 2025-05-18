// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildProfileHeader(),
//             _buildProfileDetails(),
//             _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Container(
//       height: 250,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.blue.shade700, Colors.blue.shade400],
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircleAvatar(
//             radius: 50,
//             backgroundImage: AssetImage('assets/profile_placeholder.png'),
//             child: Icon(Icons.person, size: 50, color: Colors.white),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Ibrahim',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'ontor2000@gmail.com',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileDetails() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildDetailItem(Icons.person_outline, 'Username', 'ibrahim_ontor'),
//           const Divider(),
//           _buildDetailItem(Icons.phone, 'Phone', '+1 234 567 890'),
//           const Divider(),
//           _buildDetailItem(Icons.location_on, 'Location', 'Dhaka, Bangladesh'),
//           const Divider(),
//           _buildDetailItem(Icons.cake, 'Birthday', 'January 1, 1990'),
//           const Divider(),
//           _buildDetailItem(Icons.info, 'Bio', 'Flutter Developer | Tech Enthusiast'),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(IconData icon, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 'Edit Profile',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text('Share Profile'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:examprep/Auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profile = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _profileData = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileItem('Name', _profileData?['name']),
                  _buildProfileItem('Email', _profileData?['email']),
                  _buildProfileItem('Mobile', _profileData?['mobile']),
                  _buildProfileItem('Department', _profileData?['dept']),
                  _buildProfileItem('Year', _profileData?['year']?.toString()),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to edit profile page
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'Not provided',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}