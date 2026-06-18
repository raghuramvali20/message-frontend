import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthScreenWidgets {
  Widget buildSubmitButton(String label, bool isLoading, VoidCallback handlePress){
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : handlePress, 
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(24, 119, 242, 1),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
          : Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
          )
        ),
    );
  }

  Widget buildTextField(
    {
      required String label,
      required String message,
      required TextEditingController controller,
      required TextInputType keyboardType,
      required VoidCallback handleSubmit,
    }
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        errorText: message.isEmpty
            ? null
            : message, // Uses Flutter's built-in error
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget buildPasswordTextField({
    required String label,
    required String message,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required VoidCallback togglePassword,
    required bool isInvisible,
    required VoidCallback handleSubmit
  }){
    return TextField(
      controller: controller,
      obscureText: isInvisible,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => handleSubmit(),
       decoration: InputDecoration(
        labelText: label,
        errorText: message.isEmpty
            ? null
            : message, // Uses Flutter's built-in error
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: IconButton(onPressed: () =>  {
          togglePassword()
          }, icon: Icon(isInvisible ? Icons.visibility_off : Icons.visibility))
      ),
    );
  }
}