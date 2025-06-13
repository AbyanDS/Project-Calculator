import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Color.fromARGB(255, 21, 101, 192),
      ),
      backgroundColor: Colors.white, // Background putih untuk seluruh halaman
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No history available.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white, // Background putih untuk setiap item
                  child: ListTile(
                    title: Text(
                      history[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Teks hitam
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}