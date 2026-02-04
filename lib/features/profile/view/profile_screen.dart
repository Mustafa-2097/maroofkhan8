import 'package:flutter/material.dart';
import 'package:maroofkhan8/features/profile/view/widgets/profile_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "PROFILE",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              /// User Image
              CircleAvatar(
                radius: 50,
                backgroundColor: isDark ? Color(0xFF494358) : Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              /// Name + Username
              Text(
                "Maroof Khan",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "maroof@example.com",
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              /// Status box (Plan)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Your Plan Status", style: Theme.of(context).textTheme.titleMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Upgrade",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 20, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text("Basic Plan", style: Theme.of(context).textTheme.bodyLarge),
                        const Spacer(),
                        Text("Expires: 12/2024", style: Theme.of(context).textTheme.labelMedium),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Personal Info List
              const ProfileList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}