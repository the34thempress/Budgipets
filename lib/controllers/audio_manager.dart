import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal() {
    _player.setReleaseMode(ReleaseMode.loop); // Loop background music
  }

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playMusic() async {
    if (!_isPlaying) {
      await _player.play(AssetSource('audio/background_music.mp3'));
      _isPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> toggleMusic() async {
    if (_isPlaying) {
      await stopMusic();
    } else {
      await playMusic();
    }
  }
}
