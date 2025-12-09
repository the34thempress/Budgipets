import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal() {
    _player.setReleaseMode(ReleaseMode.loop); // Loop background music
    _loadMusicPreference(); // Load saved preference on init
  }

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _musicEnabled = true; // Default to enabled

  bool get isPlaying => _isPlaying;
  bool get musicEnabled => _musicEnabled;

  // Load music preference from SharedPreferences
  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
  }

  // Save music preference to SharedPreferences
  Future<void> _saveMusicPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', enabled);
    _musicEnabled = enabled;
  }

  // Initialize music based on saved preference
  Future<void> initMusic() async {
    await _loadMusicPreference();
    if (_musicEnabled && !_isPlaying) {
      await playMusic();
    }
  }

  Future<void> playMusic() async {
    if (!_isPlaying) {
      //await _player.play(AssetSource('audio/background_music.mp3'));
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
      await _saveMusicPreference(false);
    } else {
      await playMusic();
      await _saveMusicPreference(true);
    }
  }

  // Dispose method to clean up resources
  Future<void> dispose() async {
    await _player.dispose();
  }
}