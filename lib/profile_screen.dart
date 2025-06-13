import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 21, 101, 192),
      ),
      backgroundColor: Colors.white, // Menjadikan background putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50, // Ukuran lingkaran avatar
              backgroundImage: AssetImage('assets/Profile.png'), // Ganti dengan path gambar di assets
            ),
            const SizedBox(height: 20),
            const Text(
              "Abyan Dwiartha Surya",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna hitam
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ini profile",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Warna hitam
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}