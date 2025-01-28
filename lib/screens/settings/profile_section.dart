import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String? profileImage;
  final String? walletName;
  final VoidCallback onEditProfile;

  const ProfileSection({
    this.profileImage,
    this.walletName,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: profileImage != null ? NetworkImage(profileImage!) : null,
              child: profileImage == null ? Icon(Icons.person, size: 40) : null,
            ),
            const SizedBox(height: 16),
            Text(
              walletName ?? 'ยังไม่ได้ลงทะเบียน',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text('แก้ไขโปรไฟล์'),
              onPressed: onEditProfile,
            ),
          ],
        ),
      ),
    );
  }
}