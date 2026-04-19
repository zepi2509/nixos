{ ... }:

# Audio system configuration using PipeWire
# PipeWire provides low-latency, modular audio/video handling
# Superior to PulseAudio for modern systems and professional use

{
  # RealtimeKit - allows audio processes to use realtime priority
  # Essential for low-latency, glitch-free audio with PipeWire
  security.rtkit.enable = true;

  services.pipewire = {
    # Enable PipeWire audio server
    enable = true;

    # ALSA compatibility - allows legacy ALSA applications to work
    # alsa.support32Bit enables 32-bit application support (Steam, etc.)
    alsa.enable = true;
    alsa.support32Bit = true;

    # PulseAudio compatibility layer - legacy applications
    pulse.enable = true;

    # JACK audio support - professional audio workstations
    # Useful for music production and audio processing
    jack.enable = true;
  };
}
