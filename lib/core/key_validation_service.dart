
// import 'dart:convert';

// import 'package:message/core/services/api.dart';
// import 'package:message/core/utils/rsa_helper.dart';

// class KeyValidationService{
//     static Future<bool> validateKey() async{

//       Map<String, dynamic> body = {
//         "payload": "hello_message"
//       };

//       final response = await Api.post("/health/key-validator", body);  // ✅ Fixed typo: heath -> health
//         Map<String, dynamic> data = jsonDecode(response.body);

//       if(response.statusCode == 200){
//         String cipherText = data["cipherText"];
//         String decrypted = await RsaHelper().decryptBase64(cipherText);
//         if(decrypted == "hello_message"){
//           return true;
//         }
//       }

//       return false;
//     }
// }