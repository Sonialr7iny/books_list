// lib/services/secure_book_storage.dart
import 'dart:convert';
import 'dart:typed_data'; // For Uint8List
import 'package:encrypt/encrypt.dart' as encrypt_package;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practicing_app/models/books/book_model.dart'; // Adjust path if needed
import 'package:flutter/foundation.dart'; // For kDebugMode

// --- Key Management (Choose ONE strategy) ---

// STRATEGY 1: Hardcoded Key (Simpler for Demo, LESS SECURE)
// IMPORTANT: This is for demonstration. In production, use FlutterSecureStorage.
const String _hardcodedKeyString = "YourSecure32CharKeyForBookList1"; // MUST BE 32 characters for AES-256
final encrypt_package.Key _demoKey = encrypt_package.Key.fromUtf8(_hardcodedKeyString);
final encrypt_package.IV _demoIV = encrypt_package.IV.fromLength(16); // For AES, IV is 16 bytes

/*
// STRATEGY 2: Key from FlutterSecureStorage (More Secure - RECOMMENDED)
// You would also need to add flutter_secure_storage: ^9.0.0 to pubspec.yaml
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:math';

class EncryptionKeyManager {
  static const _secureStorageKeyForEncryptionKey = 'app_encryption_key_v2';
  static final _storage = FlutterSecureStorage();
  static encrypt_package.Key? _internalKey;
  static encrypt_package.IV? _internalIV;

  static Future<void> _initKeys() async {
    if (_internalKey != null && _internalIV != null) return;

    String? base64Key = await _storage.read(key: _secureStorageKeyForEncryptionKey);
    Uint8List keyBytes;

    if (base64Key == null) {
      keyBytes = Uint8List.fromList(List<int>.generate(32, (_) => Random.secure().nextInt(256)));
      await _storage.write(key: _secureStorageKeyForEncryptionKey, value: base64Encode(keyBytes));
       if (kDebugMode) {
        print("Generated and stored new encryption key.");
      }
    } else {
      keyBytes = base64Decode(base64Key);
       if (kDebugMode) {
        print("Loaded existing encryption key from secure storage.");
      }
    }
    _internalKey = encrypt_package.Key(keyBytes);
    // For simplicity with SharedPreferences, we might use a fixed IV derived from part of the key
    // or a known constant. A better approach is to generate a new IV for each encryption
    // and store it with the ciphertext. For this example, let's use a fixed one.
    _internalIV = encrypt_package.IV.fromLength(16); // Example: first 16 bytes of a hash of the key, or a constant.
  }

  static Future<encrypt_package.Key> getKey() async {
    await _initKeys();
    return _internalKey!;
  }

  static Future<encrypt_package.IV> getIV() async {
    await _initKeys();
    return _internalIV!;
  }
}
*/

class SecureBookStorage {
  static const _prefsKey = 'encrypted_book_data_v1';
  static encrypt_package.Encrypter? _encrypter; // Make it static and nullable

  // Initialize the encrypter (call this once)
  static Future<void> _initializeEncrypter() async {
    if (_encrypter != null) return;

    // --- CHOOSE KEY STRATEGY ---
    // Using Strategy 1 (Hardcoded) for this direct integration example
    final key = _demoKey;
    final iv = _demoIV;

    // If using Strategy 2 (FlutterSecureStorage)
    // final key = await EncryptionKeyManager.getKey();
    // final iv = await EncryptionKeyManager.getIV();

    _encrypter = encrypt_package.Encrypter(encrypt_package.AES(key, mode: encrypt_package.AESMode.cbc, padding: 'PKCS7'));
  }

  static Future<String> _encryptData(String plainText) async {
    await _initializeEncrypter();
    final encrypted = _encrypter!.encrypt(plainText, iv: _demoIV /* or await EncryptionKeyManager.getIV() */);
    return encrypted.base64;
  }

  static Future<String> _decryptData(String base64EncryptedText) async {
    await _initializeEncrypter();
    try {
      final encrypted = encrypt_package.Encrypted.fromBase64(base64EncryptedText);
      final decrypted = _encrypter!.decrypt(encrypted, iv: _demoIV /* or await EncryptionKeyManager.getIV() */);
      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print("Decryption error: $e. The data might be corrupted or the key/IV changed.");
      }
      throw Exception("Failed to decrypt data: $e");
    }
  }

  static Future<void> saveBooks(List<BookModel_> books) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      List<Map<String, dynamic>> bookListAsMap = books.map((book) => book.toJson()).toList();
      String jsonString = jsonEncode(bookListAsMap);
      String encryptedJsonString = await _encryptData(jsonString);
      await prefs.setString(_prefsKey, encryptedJsonString);
      if (kDebugMode) {
        print("SecureBookStorage: Books saved and encrypted successfully.");
        // print("Encrypted data: $encryptedJsonString"); // For debugging only
      }
    } catch (e) {
      if (kDebugMode) {
        print("SecureBookStorage: Error saving books - $e");
      }
    }
  }

  static Future<List<BookModel_>> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? encryptedJsonString = prefs.getString(_prefsKey);

    if (encryptedJsonString == null || encryptedJsonString.isEmpty) {
      if (kDebugMode) {
        print("SecureBookStorage: No encrypted books found or data is empty.");
      }
      return [];
    }

    try {
      String jsonString = await _decryptData(encryptedJsonString);
      List<dynamic> bookListAsDynamic = jsonDecode(jsonString);
      List<Map<String, dynamic>> bookListAsMap = List<Map<String, dynamic>>.from(bookListAsDynamic.map((item) => item as Map<String, dynamic>));
      List<BookModel_> books = bookListAsMap.map((map) => BookModel_.fromJson(map)).toList();
      if (kDebugMode) {
        print("SecureBookStorage: Books loaded and decrypted successfully. Count: ${books.length}");
      }
      return books;
    } catch (e) {
      if (kDebugMode) {
        print("SecureBookStorage: Error loading/decrypting books - $e. Returning empty list.");
        // It's possible the data is corrupted or from an older version with a different key/format
        // You might want to clear it to prevent repeated errors:
        // await prefs.remove(_prefsKey);
        // print("SecureBookStorage: Removed potentially corrupted data.");
      }
      return [];
    }
  }

  // Optional: Method to clear stored books if needed
  static Future<void> clearStoredBooks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    if (kDebugMode) {
      print("SecureBookStorage: Cleared stored book data.");
    }
  }
}