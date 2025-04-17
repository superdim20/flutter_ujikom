import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  final box = GetStorage(); // Inisialisasi GetStorage

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final access_token = box.read('access_token');
      if (access_token == null) {
        throw Exception('access_token not found. Please log in.');
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading profile: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Tambahkan navigasi ke edit profile jika diperlukan
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      SizedBox(height: 24),
                      _buildUserInfoCard(),
                      SizedBox(height: 24),
                      _buildAccountDetails(),
                      SizedBox(height: 24),
                      _buildActionsSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 16),
        Text(
          userData?['name'] ?? 'No Name',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          userData?['email'] ?? 'No Email',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Chip(
          label: Text(
            userData?['isAdmin'] == 1 ? 'Admin' : 'User',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: userData?['isAdmin'] == 1 ? Colors.red : Colors.blue,
        ),
      ],
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email'),
              subtitle: Text(userData?['email'] ?? 'Not provided'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.verified_user, color: Colors.green),
              title: Text('Email Verified'),
              subtitle: Text(
                userData?['email_verified_at'] != null
                    ? 'Verified on ${_formatDate(userData!['email_verified_at'])}'
                    : 'Not verified',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildDetailItem('Member Since', _formatDate(userData?['created_at'])),
            SizedBox(height: 8),
            _buildDetailItem('Last Updated', _formatDate(userData?['updated_at'])),
            SizedBox(height: 8),
            _buildDetailItem('User ID', userData?['id'].toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.settings, color: Colors.blue),
          title: Text('Settings'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigasi ke settings
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Logout'),
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              box.remove('access_token'); // Hapus access_token saat logout
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login'); // Ganti rute ke login
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
