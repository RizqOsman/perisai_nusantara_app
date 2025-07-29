#!/usr/bin/env python3
"""
Script untuk mengupdate URL di frontend Flutter agar menggunakan backend lokal
"""

import os
import re

def update_flutter_urls():
    """Update URLs in Flutter files to use local backend"""
    
    # Files to update
    files_to_update = [
        "../lib/auth/loginmodel.dart",
        "../lib/page/bukutamu.dart", 
        "../lib/page/bukupaket.dart",
        "../lib/page/home.dart",
        "../lib/page/accidentreport.dart",
        "../lib/services/laporanservice.dart",
        "../lib/services/activityservice.dart",
        "../lib/services/bukutamuservice.dart",
        "../lib/services/bukupaketservice.dart",
        "../lib/services/emergencycontactservice.dart"
    ]
    
    # URL mappings
    url_mappings = {
        r'http://192\.168\.1\.12:5000': 'http://172.15.1.21:8000',
        r'https://hris\.tpm-facility\.com': 'http://172.15.1.21:8000',
        r'https://637db38316c1b892ebd275c5\.mockapi\.io/databook/kontak_darurat': 'http://172.15.1.21:8000/emergency-contact'
    }
    
    print("🔄 Updating Flutter URLs to use local backend...")
    
    for file_path in files_to_update:
        if os.path.exists(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                original_content = content
                
                # Apply URL mappings
                for old_url, new_url in url_mappings.items():
                    content = re.sub(old_url, new_url, content)
                
                # Write back if changed
                if content != original_content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"✅ Updated: {file_path}")
                else:
                    print(f"ℹ️  No changes needed: {file_path}")
                    
            except Exception as e:
                print(f"❌ Error updating {file_path}: {e}")
        else:
            print(f"⚠️  File not found: {file_path}")
    
    print("\n🎉 URL update completed!")
    print("📝 Note: You may need to restart your Flutter app for changes to take effect.")

if __name__ == "__main__":
    update_flutter_urls() 