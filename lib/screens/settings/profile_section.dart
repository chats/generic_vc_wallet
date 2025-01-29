import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String? profileImage;
  final String? walletName;
  final String? fullName;
  final VoidCallback onEditProfile;

  const ProfileSection({
    this.profileImage,
    this.walletName,
    this.fullName,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _getProfileImage(),
              ),
              const SizedBox(height: 16),
              Text(
                walletName ?? 'ยังไม่ได้ลงทะเบียน',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (fullName != null) ...[
                const SizedBox(height: 4),
                Text(
                  fullName!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('แก้ไขโปรไฟล์'),
                  onPressed: onEditProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return NetworkImage(profileImage!);
    }
    
    // ใช้ชื่อในการเลือกรูป default (ถ้ามีคำว่า man หรือ boy ใช้รูปผู้ชาย)
    //final isMan = fullName?.toLowerCase().contains('man') ?? false || 
    //              fullName!.toLowerCase().contains('boy');
    //
    //return AssetImage(
    //  isMan ? 'assets/images/avatar-man-500.png' : 'assets/images/avatar-woman-500.png'
    //);
    return AssetImage('assets/images/avatar-man-500.png');
  }
}