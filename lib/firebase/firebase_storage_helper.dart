import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> upload<T>(
    String uploadPath,
    String uploadName,
    T data,
  ) async {
    if (data is File) {
      return await _uploadFile(uploadPath, uploadName, data);
    }
    return "";
  }

  Future<String> _uploadFile(
    String uploadPath,
    String uploadName,
    File uploadFile,
  ) async {
    Reference storageReference =
        _firebaseStorage.ref().child(uploadPath).child(uploadName);
    UploadTask uploadTask = storageReference.putFile(uploadFile);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }
}
