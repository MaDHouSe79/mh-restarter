var audioPlayer = null;
window.addEventListener('message', function (event) {
    if (event.data.file != null) {
        if (audioPlayer != null) { 
            audioPlayer.stop();
            audioPlayer = null;
        }
        if (audioPlayer == null) { 
            audioPlayer = new Howl({ src: ["./assets/sounds/" + event.data.file] });
        }
    }
    if (event.data.type == "play") {
        if (audioPlayer != null) {
            audioPlayer.stop();
            audioPlayer.volume(event.data.volume);
            audioPlayer.play();
        }
    } else if (event.data.type == "stop") {
        if (audioPlayer != null) { audioPlayer.stop(); }
    } else if (event.data.type == "setVolume") {
        if (audioPlayer != null) { audioPlayer.volume(event.data.volume); }
    }
});