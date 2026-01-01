package com.example.spotify_clone // Kendi paket adını buraya yaz abi

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServiceActivity

// Artik v2 embedding hatasi almamak icin direkt boyle kullaniyoruz
class MainActivity: AudioServiceActivity() {
    // Burasi artik boş kalabilir, AudioServiceActivity v2 uyumludur.
}
