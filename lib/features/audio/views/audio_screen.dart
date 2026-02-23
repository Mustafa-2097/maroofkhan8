import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Top Divider + Title
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    indent: 24,
                    endIndent: 8,
                    color: Colors.orange,
                  ),
                ),
                const Text(
                  "Audio",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1,
                    indent: 8,
                    endIndent: 24,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const AudioCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  const AudioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const AudioListScreen()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                "https://i.pravatar.cc/150?img=3", // replace with your asset
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// Title + Subtitle
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Power of Tawakkul",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Shaykh’s Lecture",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// Duration + Menu
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "18:22",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AudioListScreen extends StatelessWidget {
  const AudioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio List'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section with Audio Image and Player Controls
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                // Sheikh's Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/sheikh_image.jpg',  // Make sure to add this image in the assets folder
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                // Audio Title, Time Slider, and Buttons
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trust in Allah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Sheikh\'s Lecture',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('02:23', style: TextStyle(color: Colors.grey)),
                          Expanded(
                            child: Slider(
                              value: 2.23,
                              min: 0.0,
                              max: 10.0,
                              onChanged: (value) {},
                              activeColor: Colors.orange,
                              inactiveColor: Colors.grey[300],
                            ),
                          ),
                          Text('10:25', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Listen Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: Text('Listen'),
                          ),
                          // Download Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: Text('Download (Premium)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Audio List Section
          Expanded(
            child: ListView(
              children: [
                AudioItem(text: 'The heart becomes alive through the remembrance of Allah'),
                AudioItem(text: 'Silence with reflection is better than speech without wisdom'),
                AudioItem(text: 'Patience opens doors that force can never unlock'),
                AudioItem(text: 'Patience opens doors that force can never unlock'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AudioItem extends StatelessWidget {
  final String text;
  const AudioItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Sheikh\'s Malfuzat',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Icon(Icons.play_arrow, color: Colors.blue),
        onTap: () {
          // Handle on tap to play audio
        },
      ),
    );
  }
}