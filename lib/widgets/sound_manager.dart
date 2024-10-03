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
      double volume = 2.0;

      soundPlayer?.play(AssetSource(asset));
      if(asset == Sounds.match) {
        volume = 4.0;
      } else {
        volume = 2.0;
      }
      soundPlayer?.setVolume(volume);
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