import 'package:audioplayers/audioplayers.dart';
import 'package:wingscape_puzzle/utils/sounds.dart';

class SoundManager {
  AudioPlayer? musicPlayer;
  AudioPlayer? soundPlayer;
  bool isSoundOn;
  bool isMusicOn;

  SoundManager({required this.isSoundOn, required this.isMusicOn}) {
    musicPlayer = AudioPlayer();
    soundPlayer = AudioPlayer();
    musicPlayer?.setReleaseMode(ReleaseMode.loop);
    toggleMusic(isMusicOn);
  }

  void playSound(String asset) {
    if (isSoundOn) {
      soundPlayer?.play(AssetSource(asset));
      soundPlayer?.setVolume(1.0);
    }
  }

  void toggleMusic(bool play) {
    isMusicOn = play;
    if (play) {
      musicPlayer?.setVolume(1.0);
      musicPlayer?.play(AssetSource(Sounds.background));
    } else {
      musicPlayer?.stop();
    }
  }
}