import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generic VC Wallet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              'ข้อตกลงสิทธิการใช้งาน (License Agreement)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            
            _buildSection(
              title: 'การให้สิทธิ์การใช้งาน',
              content: 'บริษัท ABC จำกัด ("บริษัท", "ผู้ให้บริการ") ให้สิทธิ์การใช้งานที่ไม่เป็นเอกสิทธิ์ (non-exclusive), ไม่สามารถโอนสิทธิ์ (non-transferable), และเพิกถอนได้ (revocable) '+
              'แก่ผู้ใช้สำหรับการติดตั้งและใช้งานแอปพลิเคชันบนอุปกรณ์ที่ได้รับอนุญาต ภายใต้เงื่อนไขต่อไปนี้'+
              '\n\t- แอปพลิเคชันใช้เพื่อ วัตถุประสงค์ส่วนตัว หรือธุรกิจภายในองค์กรเท่านั้น'+
              '\n\t- ห้ามใช้แอปพลิเคชันเพื่อ วัตถุประสงค์เชิงพาณิชย์ที่ไม่ได้รับอนุญาตจากบริษัท'+
              '\n\t- ห้ามแก้ไข ทำซ้ำ แจกจ่าย หรือขายแอปพลิเคชันนี้โดยไม่ได้รับอนุญาตเป็นลายลักษณ์อักษรจากบริษัท',
            ),
 
            _buildSection(
              title: 'การเก็บข้อมูลส่วนบุคคล',
              content: 'แอปพลิเคชันนี้ไม่มีการเก็บบันทึกข้อมูลส่วนบุคคลของผู้ใช้งานไว้ในระบบ ข้อมูลทั้งหมดจะถูกเก็บไว้ในอุปกรณ์ของผู้ใช้งานเท่านั้น',
            ),
            
            _buildSection(
              title: 'การใช้งานกล้อง',
              content: 'แอปพลิเคชันนี้จำเป็นต้องขอสิทธิ์ในการใช้งานกล้องเพื่อการสแกน QR Code เท่านั้น',
            ),
            
            _buildSection(
              title: 'การรับรองตัวตน',
              content: 'แอปพลิเคชันนี้ไม่มีการรับรองว่าผู้ใช้งานเป็นเจ้าของข้อมูลที่แท้จริง ผู้ใช้งานต้องรับผิดชอบในการรักษาความปลอดภัยของข้อมูลด้วยตนเอง',
            ),
            
            _buildSection(
              title: 'การรักษาความปลอดภัย',
              content: 'แอปพลิเคชันมีระบบรักษาความปลอดภัยด้วย PIN Code และ Biometric Authentication ผู้ใช้งานควรเปิดใช้งานระบบรักษาความปลอดภัยเพื่อป้องกันการเข้าถึงข้อมูลโดยไม่ได้รับอนุญาต',
            ),
            
            _buildSection(
              title: 'การสำรองข้อมูล',
              content: 'ผู้ใช้งานควรสำรองข้อมูล Wallet Key ไว้ในที่ปลอดภัย หากข้อมูลสูญหายหรือถูกลบ ทางผู้ให้บริการจะไม่สามารถกู้คืนข้อมูลได้',
            ),
            
            _buildSection(
              title: 'การอัปเดตแอปพลิเคชัน',
              content: 'ผู้ให้บริการอาจมีการอัปเดตแอปพลิเคชันเพื่อเพิ่มฟีเจอร์หรือปรับปรุงความปลอดภัย ผู้ใช้งานควรอัปเดตแอปพลิเคชันเป็นเวอร์ชันล่าสุดเสมอ',
            ),
            
            SizedBox(height: 32),
            
            Text(
              'Last updated: January 28, 2025',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}