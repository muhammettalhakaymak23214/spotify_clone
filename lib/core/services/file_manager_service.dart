import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileManagerService {
  final Dio _dio = Dio();

  Future<String?> downloadFile(String url, String fileName) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              "İndirilen: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );

      debugPrint("Dosya indirildi: $savePath");
      return savePath;
    } catch (e) {
      debugPrint("Dosya indirilemedi: $e");
      return null;
    }
  }

  Future<List<String>> listFiles() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> files = dir.listSync();

      return files
          .whereType<File>()
          .map((file) => file.path.split('/').last)
          .toList();
    } catch (e) {
      debugPrint("Dosyalar listelenemedi: $e");
      return [];
    }
  }


  Future<bool> deleteFile(String? fileName) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String? path = "${dir.path}/$fileName";
      File file = File(fileName ?? "");

      if (await file.exists()) {
        await file.delete();
        debugPrint("Dosya silindi: $fileName");
        return true;
      } else {
        debugPrint("Dosya bulunamadı: $fileName");
        return true;
      }
    } catch (e) {
      debugPrint("Dosya silinemedi: $e");
      return false;
    }
  }


  Future<bool> fileExists(String fileName) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/$fileName";
    return File(path).exists();
  }

  Future<void> clearAllFiles() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> files = dir.listSync();

      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }

      debugPrint("Tüm dosyalar silindi!");
    } catch (e) {
      debugPrint("Dosyalar temizlenemedi: $e");
    }
  }
}
