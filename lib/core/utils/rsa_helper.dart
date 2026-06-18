// import 'dart:convert';
// import 'package:basic_utils/basic_utils.dart';
// import 'package:pointycastle/export.dart';
// import 'package:pointycastle/asymmetric/api.dart' as pc;
// import 'package:message/core/storage_services/secure_storage_service.dart';

// class RsaHelper {
//   final StorageService _store = StorageService();
//   pc.RSAPrivateKey? _privateKey;
//   pc.RSAPublicKey? _publicKey;

//   /// Generate keys at login/register and store them
//   Future<String> generateAndStoreKeys() async {
//     final pair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
//     _privateKey = pair.privateKey as pc.RSAPrivateKey;
//     _publicKey = pair.publicKey as pc.RSAPublicKey;

//     final privatePem = CryptoUtils.encodeRSAPrivateKeyToPem(_privateKey!);
//     final publicPem = CryptoUtils.encodeRSAPublicKeyToPem(_publicKey!);

//     await _store.savePrivateKey(privatePem);
//     await _store.savePublicKey(publicPem);

//     return publicPem; // send this to backend
//   }

//   /// Load keys from secure storage
//   Future<void> loadKeys() async {
//     final privatePem = await _store.loadPrivateKey();
//     final publicPem = await _store.loadPublicKey();

//     if (privatePem == null || publicPem == null) {
//       throw StateError("Keys not found in storage. Generate at login/register.");
//     }

//     _privateKey = CryptoUtils.rsaPrivateKeyFromPem(privatePem);
//     _publicKey = CryptoUtils.rsaPublicKeyFromPem(publicPem);
//   }

//   /// Decrypt using private key from storage
//   Future<String> decryptBase64(String base64Cipher) async {
//     if (_privateKey == null) {
//       await loadKeys(); // ensure keys are loaded
//     }

//     final cipher = OAEPEncoding.withSHA256(RSAEngine())
//       ..init(false, PrivateKeyParameter<pc.RSAPrivateKey>(_privateKey!));

//     final encryptedBytes = base64.decode(base64Cipher);
//     final decryptedBytes = cipher.process(encryptedBytes);

//     print(utf8.decode(decryptedBytes));
//     return utf8.decode(decryptedBytes);
//   }
// }
