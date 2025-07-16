# Restaurant Yönetim Sistemi

Bu proje, bir restoranın günlük operasyonlarını yönetmek için geliştirilmiş modern bir web uygulamasıdır. Flutter ile geliştirilmiş frontend ve Node.js/Express.js ile geliştirilmiş backend içerir.

## Özellikler



## Teknik Gereksinimler

### Backend
- Node.js (v14 veya üzeri)
- MongoDB (v4.4 veya üzeri)
- npm veya yarn

### Frontend
- Flutter SDK (v3.0 veya üzeri)
- Chrome (web uygulaması için)


## Kurulum

### macOS Kurulumu

#### Backend Kurulumu (macOS)

1. Homebrew ile gerekli araçları yükleyin:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon için:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Apple Intel için:
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"

brew install node

brew tap mongodb/brew
brew install mongodb-community@6.0

brew services start mongodb-community@6.0
```

2. Projeyi indirin ve backend klasörüne gidin:
```bash
cd backend
```

3. Bağımlılıkları yükleyin:
```bash
npm install
```

4. Seed'i yükleyin:
```bash
node seed.js
```

5. Sunucuyu başlatın (Her seferinde gerekli):
```bash
npm start
```

Backend sunucusu http://localhost:3000 adresinde çalışacaktır.

#### Frontend Kurulumu (macOS)

1. Flutter SDK'yı yükleyin:
```bash
brew install flutter
```

2. Flutter'ı doğrulayın:
```bash
flutter doctor
```

3. Proje dizinine gidin:
```bash
cd ../
```

4. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

5. Web uygulamasını başlatın (Her seferinde gerekli):
```bash
flutter run -d chrome
```

### Windows Kurulumu

#### Backend Kurulumu (Windows)

1. **Node.js Kurulumu:**
   - [Node.js resmi sitesinden](https://nodejs.org/) LTS sürümünü indirin
   - İndirilen .msi dosyasını çalıştırın ve kurulum sihirbazını takip edin
   - Kurulum tamamlandıktan sonra komut istemcisini yeniden başlatın
   - Kurulumu doğrulamak için: `node --version` ve `npm --version`

2. **MongoDB Kurulumu:**
   - [MongoDB Community Server](https://www.mongodb.com/try/download/community) sayfasından Windows için olan sürümü indirin
   - İndirilen .msi dosyasını çalıştırın
   - "Complete" kurulum seçeneğini seçin
   - "Install MongoDB as a Service" seçeneğini işaretli bırakın
   - Kurulum tamamlandıktan sonra MongoDB servisi otomatik olarak başlayacaktır

3. **MongoDB Servisini Kontrol Edin:**
   - Windows + R tuşlarına basın ve "services.msc" yazın
   - "MongoDB" servisini bulun ve "Running" durumunda olduğunu kontrol edin
   - Eğer çalışmıyorsa, sağ tıklayıp "Start" seçeneğini seçin

4. **Projeyi indirin ve backend klasörüne gidin:**
```cmd
cd backend
```

5. **Bağımlılıkları yükleyin:**
```cmd
npm install
```

6. **Seed'i yükleyin:**
```cmd
node seed.js
```

7. **Sunucuyu başlatın (Her seferinde gerekli):**
```cmd
npm start
```

Backend sunucusu http://localhost:3000 adresinde çalışacaktır.

#### Frontend Kurulumu (Windows)

1. **Flutter SDK Kurulumu:**
   - [Flutter resmi sitesinden](https://flutter.dev/docs/get-started/install/windows) Windows için olan SDK'yı indirin
   - İndirilen zip dosyasını C:\src\ klasörüne çıkartın (örnek: C:\src\flutter)
   - Sistem ortam değişkenlerine Flutter'ı ekleyin:
     - Windows + R tuşlarına basın ve "sysdm.cpl" yazın
     - "Advanced" sekmesine tıklayın
     - "Environment Variables" butonuna tıklayın
     - "System variables" bölümünde "Path" değişkenini seçin ve "Edit" butonuna tıklayın
     - "New" butonuna tıklayın ve "C:\src\flutter\bin" yolunu ekleyin
     - Tüm pencereleri "OK" ile kapatın

2. **Flutter'ı doğrulayın:**
   - Komut istemcisini yönetici olarak açın
   - Aşağıdaki komutu çalıştırın:
```cmd
flutter doctor
```

3. **Eksik bağımlılıkları yükleyin:**
   - `flutter doctor` komutunun çıktısında gösterilen eksik bağımlılıkları yükleyin
   - Android Studio kurulumu gerekebilir (web geliştirme için opsiyonel)

4. **Proje dizinine gidin:**
```cmd
cd ../
```

5. **Bağımlılıkları yükleyin:**
```cmd
flutter pub get
```

6. **Web uygulamasını başlatın (Her seferinde gerekli):**
```cmd
flutter run -d chrome
```

### Linux Kurulumu

#### Backend Kurulumu (Linux)

1. **Node.js Kurulumu:**
```bash
# Ubuntu/Debian için:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# CentOS/RHEL/Fedora için:
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo yum install -y nodejs
```

2. **MongoDB Kurulumu:**
```bash
# Ubuntu/Debian için:
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# CentOS/RHEL/Fedora için:
sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo << EOF
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
EOF
sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

3. **Projeyi indirin ve backend klasörüne gidin:**
```bash
cd backend
```

4. **Bağımlılıkları yükleyin:**
```bash
npm install
```

5. **Seed'i yükleyin:**
```bash
node seed.js
```

6. **Sunucuyu başlatın (Her seferinde gerekli):**
```bash
npm start
```

#### Frontend Kurulumu (Linux)

1. **Flutter SDK Kurulumu:**
```bash
# Flutter SDK'yı indirin:
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz

# Arşivi çıkartın:
tar xf flutter_linux_3.16.5-stable.tar.xz

# Flutter'ı PATH'e ekleyin:
export PATH="$PATH:`pwd`/flutter/bin"
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.bashrc

# Flutter'ı doğrulayın:
flutter doctor
```

2. **Proje dizinine gidin:**
```bash
cd ../
```

3. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

4. **Web uygulamasını başlatın (Her seferinde gerekli):**
```bash
flutter run -d chrome
```

### Android Kurulumu

#### Backend Kurulumu (Android için)

Android cihazlarda uygulamayı çalıştırmak için backend'in aynı ağda erişilebilir olması gerekir. Backend kurulumu için yukarıdaki işletim sistemi kurulumlarını takip edin.

#### Frontend Kurulumu (Android)

1. **Android Studio Kurulumu:**
   - [Android Studio resmi sitesinden](https://developer.android.com/studio) en son sürümü indirin
   - İndirilen dosyayı çalıştırın ve kurulum sihirbazını takip edin
   - Kurulum sırasında "Android SDK", "Android SDK Platform-Tools" ve "Android Virtual Device" seçeneklerini işaretli bırakın
   - Kurulum tamamlandıktan sonra Android Studio'yu açın

2. **Android SDK Kurulumu:**
   - Android Studio'da "Tools" > "SDK Manager" seçeneğine tıklayın
   - "SDK Platforms" sekmesinde en az bir Android sürümü seçin (Android 6.0/API 23 veya üzeri önerilir)
   - "SDK Tools" sekmesinde aşağıdaki bileşenlerin yüklü olduğundan emin olun:
     - Android SDK Build-Tools
     - Android SDK Command-line Tools
     - Android Emulator
     - Android SDK Platform-Tools
   - "Apply" butonuna tıklayın ve kurulumu tamamlayın

3. **Flutter SDK Kurulumu:**
   - [Flutter resmi sitesinden](https://flutter.dev/docs/get-started/install) işletim sisteminize uygun SDK'yı indirin
   - İndirilen arşivi uygun bir klasöre çıkartın (örnek: C:\src\flutter veya ~/flutter)
   - Flutter'ı sistem PATH'ine ekleyin:
     - **Windows:** Sistem ortam değişkenlerine Flutter bin klasörünü ekleyin
     - **macOS/Linux:** Terminal'de `export PATH="$PATH:/path/to/flutter/bin"` komutunu çalıştırın

4. **Flutter'ı Doğrulayın:**
```bash
flutter doctor
```

5. **Android Lisanslarını Kabul Edin:**
```bash
flutter doctor --android-licenses
```

6. **Android Emülatör Kurulumu:**
   - Android Studio'da "Tools" > "AVD Manager" seçeneğine tıklayın
   - "Create Virtual Device" butonuna tıklayın
   - Bir cihaz seçin (örnek: Pixel 4)
   - Bir sistem imajı seçin (API 30 veya üzeri önerilir)
   - Emülatörü oluşturun ve başlatın

7. **Proje Dizinine Gidin:**
```bash
cd /path/to/your/project
```

8. **Bağımlılıkları Yükleyin:**
```bash
flutter pub get
```

9. **Android Uygulamasını Çalıştırın:**

   **Emülatörde çalıştırmak için:**
   ```bash
   flutter run
   ```

   **Fiziksel cihazda çalıştırmak için:**
   - Android cihazınızda "Geliştirici Seçenekleri"ni etkinleştirin:
     - Ayarlar > Telefon Hakkında > Yapım Numarası'na 7 kez tıklayın
   - "USB Hata Ayıklama" seçeneğini etkinleştirin
   - Cihazı USB ile bilgisayara bağlayın
   - Cihazı tanımayı onaylayın
   ```bash
   flutter devices  # Bağlı cihazları listele
   flutter run -d [device-id]  # Belirli cihazda çalıştır
   ```

10. **Ağ Yapılandırması:**
    - Backend sunucusunun aynı ağda çalıştığından emin olun
    - Android uygulamasının backend'e erişebilmesi için IP adresini güncelleyin
    - `lib/config/api_config.dart` dosyasında backend URL'sini güncelleyin:
    ```dart
    static const String baseUrl = 'http://192.168.1.100:3000';  // Backend IP adresi
    ```

#### Android Uygulaması Özellikleri

- **Responsive Tasarım:** Farklı ekran boyutlarına uyumlu
- **Offline Desteği:** Temel işlevler için offline çalışma
- **Push Bildirimleri:** Sipariş durumu güncellemeleri
- **Kamera Entegrasyonu:** QR kod okuma ve fotoğraf çekme
- **Yerel Depolama:** Offline veri saklama

#### Android Gereksinimleri

- **Minimum Android Sürümü:** Android 6.0 (API 23)
- **Önerilen Android Sürümü:** Android 10 (API 29) veya üzeri
- **RAM:** En az 2GB
- **Depolama:** En az 100MB boş alan
- **İnternet:** Backend sunucusuna erişim için

#### Sorun Giderme

**Flutter Doctor Hataları:**
```bash
flutter doctor -v  # Detaylı bilgi için
```

**Android Studio Sorunları:**
- Android Studio'yu yeniden başlatın
- SDK Manager'dan eksik bileşenleri yükleyin
- Gradle cache'ini temizleyin: `flutter clean`

**Emülatör Sorunları:**
- BIOS'ta Virtualization Technology'yi etkinleştirin
- Hyper-V (Windows) veya KVM (Linux) kurulumunu kontrol edin
- Emülatörü yeniden oluşturun

**Ağ Bağlantı Sorunları:**
- Firewall ayarlarını kontrol edin
- Backend sunucusunun IP adresini doğrulayın
- Aynı ağda olduğunuzdan emin olun

## API Endpoints

### Masalar
- `GET /api/tables` - Tüm masaları listele
- `POST /api/tables` - Yeni masa ekle
- `PATCH /api/tables/:id/status` - Masa durumunu güncelle
- `DELETE /api/tables/:id` - Masa sil

### Menü
- `GET /api/menu` - Tüm menü öğelerini listele
- `POST /api/menu` - Yeni menü öğesi ekle
- `PUT /api/menu/:id` - Menü öğesini güncelle
- `DELETE /api/menu/:id` - Menü öğesini sil

### Siparişler
- `GET /api/orders` - Tüm siparişleri listele
- `POST /api/orders` - Yeni sipariş oluştur
- `PATCH /api/orders/:id/status` - Sipariş durumunu güncelle
- `PATCH /api/orders/:id/payment` - Sipariş ödemesini güncelle
- `GET /api/orders/kitchen` - Mutfak siparişlerini getir
- `GET /api/orders/reports/summary` - Özet raporları getir

## Veritabanı Şeması

### Table (Masa)
- `number`: Masa numarası
- `status`: Masa durumu (available, occupied, reserved)
- `capacity`: Masa kapasitesi

### MenuItem (Menü Öğesi)
- `name`: Ürün adı
- `description`: Ürün açıklaması
- `price`: Fiyat
- `category`: Kategori
- `isAvailable`: Mevcut durumu

### Order (Sipariş)
- `tableId`: Masa referansı
- `items`: Sipariş kalemleri
- `totalAmount`: Toplam tutar
- `status`: Sipariş durumu
- `isPaid`: Ödeme durumu
- `paymentMethod`: Ödeme yöntemi
- `createdAt`: Oluşturulma tarihi

## Projenin Kullanımı

Bu proje, restoran yönetimi için geliştirilmiş bir web uygulamasıdır. Projeyi kullanmak için:

1. Backend ve Frontend servislerinin aynı anda çalışır durumda olması gerekir
2. MongoDB veritabanının çalışır durumda olması gerekir
3. Tarayıcınızda Chrome kullanmanız önerilir

### Önemli Notlar

- Backend sunucusu varsayılan olarak 3000 portunda çalışır
- Frontend uygulaması varsayılan olarak 8080 portunda çalışır
- Veritabanı bağlantısı için MongoDB'nin yerel kurulumu yeterlidir
- Tüm API istekleri `http://localhost:3000` adresine yapılır



