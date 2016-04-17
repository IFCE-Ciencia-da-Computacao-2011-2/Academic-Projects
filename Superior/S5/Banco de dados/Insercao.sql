 INSERT INTO efeito.empresa (id_empresa, nome, site) 
      VALUES 
             (1, 'ZamAudio', 'http://www.zamaudio.com'),
             (2, 'x42', 'http://gareus.org/'),
             (3, 'Robin', 'http://gareus.org/'),
             (4, 'NickBailey', 'http://nickbailey.co.nr'),
             (5, 'TAP', 'http://moddevices.com'),
             (6, 'MOD', 'http://moddevices.com'),
             (7, 'SHIRO', 'https://github.com/ninodewit/SHIRO-Plugins'),
             (8, 'Shiro', 'https://github.com/ninodewit/SHIRO-Plugins'),
             (9, 'Rakarrack', 'http://rakarrack.sourceforge.net'),
             (10, 'MDA', 'http://moddevices.com'),
             (11, 'Invada', 'http://www.invadarecords.com/Downloads.php?ID=00000264'),
             (12, 'Guitarix', 'http://guitarix.sourceforge.net'),
             (13, 'mayank', 'http://www.e7mac.com/experiments/'),
             (14, 'Freaked', 'https://github.com/pjotrompet'),
             (15, 'FOMP', 'http://drobilla.net'),
             (16, 'FluidGM', 'https://github.com/falkTX/FluidPlug'),
             (17, 'FluidSynth', 'https://github.com/falkTX/FluidPlug'),
             (18, 'OpenAV', ''),
             (19, 'DISTRHO', 'https://github.com/DISTRHO/ndc-Plugs'),
             (20, 'CAPS', 'http://moddevices.com'),
             (21, 'Calf', 'http://calf-studio-gear.org'),
             (22, 'BLOP', ''),
             (23, 'Dowell', 'https://amsynth.github.io'),
             (24, 'Antanas', 'http://www.hippie.lt'),
             (25, 'ZynAddSubFX', 'http://zynaddsubfx.sourceforge.net');

 INSERT INTO efeito.categoria (id_categoria, nome) 
      VALUES 
             (1, 'Utility'),
             (2, 'Mixer'),
             (3, 'Filter'),
             (4, 'Spatial'),
             (5, 'Generator'),
             (6, 'Instrument'),
             (7, 'Modulator'),
             (8, 'Simulator'),
             (9, 'Distortion'),
             (10, 'Reverb'),
             (11, 'Delay'),
             (12, 'Spectral'),
             (13, 'Pitch Shifter'),
             (14, 'Dynamics'),
             (15, 'Limiter'),
             (16, 'Equaliser'),
             (17, 'Parametric'),
             (18, 'Multiband'),
             (19, 'Compressor'),
             (20, 'Chorus'),
             (21, 'Phaser'),
             (22, 'Expander'),
             (23, 'Flanger'),
             (24, 'Oscillator'),
             (25, 'Lowpass'),
             (26, 'Highpass'),
             (27, 'Analyser'),
             (28, 'Amplifier'),
             (29, 'Waveshaper'),
             (30, 'Gate');

 INSERT INTO efeito.efeito (id_efeito, nome, descricao, identificador, id_empresa, id_tecnologia) 
      VALUES 
           (1, 'ZaMultiCompX2', 'Flagship of zam-plugins:
Stereo version of ZaMultiComp, with individual threshold controls for each band and real-time visualisation of comp curves.
', 'urn:zamaudio:ZaMultiCompX2', 1, 1),
           (2, 'ZaMultiComp', 'Mono multiband compressor, with 3 adjustable bands.
', 'urn:zamaudio:ZaMultiComp', 1, 1),
           (3, 'ZamTube', 'Wicked distortion effect.
Wave digital filter physical model of a triode tube amplifier stage, with modelled tone stacks from real guitar amplifiers (thanks D. Yeh et al).
', 'urn:zamaudio:ZamTube', 1, 1),
           (4, 'ZamHeadX2', 'HRTF acoustic filtering plugin for directional sound.
', 'urn:zamaudio:ZamHeadX2', 1, 1),
           (5, 'ZamGEQ31', '31 band graphic equaliser, good for eq of live spaces, removing unwanted noise from a track etc.
', 'urn:zamaudio:ZamGEQ31', 1, 1),
           (6, 'ZamGateX2', 'Gate plugin for ducking low gain sounds, stereo version.
', 'urn:zamaudio:ZamGateX2', 1, 1),
           (7, 'ZamGate', 'Gate plugin for ducking low gain sounds.
', 'urn:zamaudio:ZamGate', 1, 1),
           (8, 'ZamEQ2', 'Two band parametric equaliser with high and low shelving circuits.
', 'urn:zamaudio:ZamEQ2', 1, 1),
           (9, 'ZamDelay', 'A delay with bpm and dividing options
', 'urn:zamaudio:ZamDelay', 1, 1),
           (10, 'ZamCompX2', 'Stereo version of ZamComp with knee slew control.
', 'urn:zamaudio:ZamCompX2', 1, 1),
           (11, 'ZamComp', 'A powerful mono compressor strip. Adds real beef to a kick or snare drum with the right settings.
', 'urn:zamaudio:ZamComp', 1, 1),
           (12, 'ZaMaximX2', ' ... ', 'urn:zamaudio:ZaMaximX2', 1, 1),
           (13, 'ZamAutoSat', 'An automatic saturation plugin, has been known to provide smooth levelling to live mic channels.
You can apply this plugin generously without affecting the tone.
', 'urn:zamaudio:ZamAutoSat', 1, 1),
           (14, 'Stereo X-Fade', 'A stereo crossfade plugin', 'http://gareus.org/oss/lv2/xfade', 2, 1),
           (15, 'No Delay Line', 'Artificial Latency - nodelay is a simple audio delay-line that can report its delay as latency. The effect should be transparent when used with a LV2 host that implements latency compensation.', 'http://gareus.org/oss/lv2/nodelay', 3, 1),
           (16, 'MIDI Velocity Adjust', 'Change the velocity of note events with separate controls for Note-on and Note-off. The input range 1 - 127 is mapped to the range between Min and Max. If Min is greater than Max, the range is reversed. The offsets value is added to the velocity event after mapping the Min/Max range.', 'http://gareus.org/oss/lv2/midifilter#velocityscale', 2, 1),
           (17, 'MIDI Velocity-Range Filter', 'Filter MIDI note-on events according to velocity. Note-on events outside the allowed range are discarded. If a Note-off is received for a note that was previously filtered, it is also not passed though. If the allowed range changes, note-off events are sent to currently active notes that end up outside the valid range.', 'http://gareus.org/oss/lv2/midifilter#velocityrange', 2, 1),
           (18, 'MIDI Sostenuto', 'This filter delays note-off messages by a given time, emulating a piano sostenuto pedal. When the pedal is released, note-off messages that are queued will be sent immediately. The delay-time can be changed dynamically, changes do affects note-off messages that are still queued.', 'http://gareus.org/oss/lv2/midifilter#sostenuto', 2, 1),
           (19, 'Scale CC Value', 'Modify the value (data-byte) of a MIDI control change message.', 'http://gareus.org/oss/lv2/midifilter#scalecc', 2, 1),
           (20, 'MIDI Velocity Randomization', 'Randomize Velocity of MIDI notes (both note on and note off).', 'http://gareus.org/oss/lv2/midifilter#randvelocity', 2, 1),
           (21, 'MIDI Quantization', 'Live event quantization. This filter aligns incoming MIDI events to a fixed time-grid. Since the effect operates on a live-stream it will introduce latency: Events will be delayed until the next ''tick''. If the plugin-host provides BBT information, the events are aligned to the host''s clock otherwise the effect runs on its own time.', 'http://gareus.org/oss/lv2/midifilter#quantize', 2, 1),
           (22, 'MIDI Thru', 'MIDI All pass. This plugin has no effect and is intended as example.', 'http://gareus.org/oss/lv2/midifilter#passthru', 2, 1),
           (23, 'MIDI N-Tap Delay', 'This effect repeats notes N times. Where N is either a fixed number or unlimited as long as a given key is pressed. BPM and delay-time variable and allow tempo-ramps. On every repeat the given velocity-adjustment is added or subtracted, the result is clamped between 1 and 127.', 'http://gareus.org/oss/lv2/midifilter#ntapdelay', 2, 1),
           (24, 'MIDI Note Toggle', 'Toggle Notes: play a note to turn it on, play it again to turn it off.', 'http://gareus.org/oss/lv2/midifilter#notetoggle', 2, 1),
           (25, 'Note2CC', 'Convert MIDI note-on messages to control change messages.', 'http://gareus.org/oss/lv2/midifilter#notetocc', 2, 1),
           (26, 'MIDI Duplicate Blocker', 'MIDI Duplicate Blocker. Filter out overlapping note on/off and duplicate messages.', 'http://gareus.org/oss/lv2/midifilter#nodup', 2, 1),
           (27, 'MIDI Remove Active Sensing', 'Filter to block all active sensing events. Active sensing messages are optional MIDI messages and intended to be sent repeatedly to tell a receiver that a connection is alive, however they can clutter up the MIDI channel or be inadvertently recorded when dumping raw MIDI data to disk.', 'http://gareus.org/oss/lv2/midifilter#noactivesensing', 2, 1),
           (28, 'MIDI Monophonic Legato', 'Hold a note until the next note arrives. -- Play the same note again to switch it off.', 'http://gareus.org/oss/lv2/midifilter#monolegato', 2, 1),
           (29, 'MIDI Chromatic Transpose', 'Chromatic transpose of midi notes and key-pressure. If an inversion point is set, the scale is mirrored around this point before transposing. Notes that end up outside the valid range 0..127 are discarded.', 'http://gareus.org/oss/lv2/midifilter#miditranspose', 2, 1),
           (30, 'MIDI Strum', 'A midi arpeggio effect intended to simulate strumming a stringed instrument (e.g. guitar). A chord is ''collected'' and the single notes of the chord are played back spread out over time. The ''Note Collect Timeout'' allows for the effect to be played live with midi-keyboard, it compensates for a human not pressing keys at the same point in time. If the effect is used with a sequencer that can send chords with all note-on at the exactly time, it should be set to zero.', 'http://gareus.org/oss/lv2/midifilter#midistrum', 2, 1),
           (31, 'MIDI Channel Unisono', 'Duplicate MIDI events from one channel to another.', 'http://gareus.org/oss/lv2/midifilter#mididup', 2, 1),
           (32, 'MIDI Delayline', 'MIDI delay line. Delay all MIDI events by a given time which is give as BPM and beats. If the delay includes a random factor, this effect takes care of always keeping note on/off events sequential regardless of the randomization.', 'http://gareus.org/oss/lv2/midifilter#mididelay', 2, 1),
           (33, 'MIDI Chord', 'Harmonizer - make chords from single (fundamental) note in a given musical scale. The scale as well as intervals can be automated freely (currently held chords will change). Note-ons are latched, for multiple/combined chords only single note-on/off will be triggered for the duration of the combined chords. If a off-scale note is given, it will be passed through - no chord is allocated. Note: Combine this effect with the ''MIDI Enforce Scale'' filter to weed them out.', 'http://gareus.org/oss/lv2/midifilter#midichord', 2, 1),
           (34, 'MIDI Keys Transpose', 'Flexible 12-tone map. Allow to map a note within an octave to another note in the same octave-range +- 12 semitones. Alternatively notes can also be masked (disabled). If two keys are mapped to the same note, the corresponding note on/events are latched: only the first note on and last note off will be sent. The settings can be changed dynamically: Note-on/off events will be sent accordingly.', 'http://gareus.org/oss/lv2/midifilter#mapkeyscale', 2, 1),
           (35, 'MapCC', 'Change one control message into another -- combine with scalecc to modify/scale the actual value.', 'http://gareus.org/oss/lv2/midifilter#mapcc', 2, 1),
           (36, 'MIDI Keysplit', 'Change midi-channel number depending on note. The plugin keeps track of transposed midi-notes in case and sends note-off events accordingly if the range is changed even if a note is active. However the split-point and channel-assignments for each manual should only be changed when no notes are currently played. ', 'http://gareus.org/oss/lv2/midifilter#keysplit', 2, 1),
           (37, 'MIDI Key-Range Filter', 'This filter allows to define a range of allowed midi notes. Notes-on/off events outside the allowed range are discarded. If the range changes, note-off events are sent to currently active notes that end up outside the valid range.', 'http://gareus.org/oss/lv2/midifilter#keyrange', 2, 1),
           (38, 'MIDI Event Filter', 'Notch style message filter. Suppress specific messages. For flexible note-on/off range see also ''keyrange'' and ''velocityrange''.', 'http://gareus.org/oss/lv2/midifilter#eventblocker', 2, 1),
           (39, 'MIDI Enforce Scale', 'Filter note-on/off events depending on musical scale. If the key is changed note-off events of are sent for all active off-key notes.', 'http://gareus.org/oss/lv2/midifilter#enforcescale', 2, 1),
           (40, 'MIDI Channel Map', 'Rewrite midi-channel number. This filter only affects midi-data which is channel relevant (ie note-on/off, control and program changes, key and channel pressure and pitchbend). MIDI-SYSEX and Realtime message are always passed thru unmodified.', 'http://gareus.org/oss/lv2/midifilter#channelmap', 2, 1),
           (41, 'MIDI Channel Filter', 'Simple MIDI channel filter. Only data for selected channels may pass. This filter only affects midi-data which is channel relevant (ie note-on/off, control and program changes, key and channel pressure and pitchbend). MIDI-SYSEX and Realtime message are always passed on. This plugin is intended for live-use, button-control. See also ''MIDI Channel Map'' filter.', 'http://gareus.org/oss/lv2/midifilter#channelfilter', 2, 1),
           (42, 'CC2Note', 'Convert MIDI control change messages to note-on/off messages. Note off is queued 10msec later.', 'http://gareus.org/oss/lv2/midifilter#cctonote', 2, 1),
           (43, 'LV2 Convolution Stereo', 'Zero latency Mono to Stereo Signal Convolution Processor; 2 chan IR', 'http://gareus.org/oss/lv2/convoLV2#Stereo', 3, 1),
           (44, 'LV2 Convolution Mono=>Stereo', 'Zero latency True Stereo Signal Convolution Processor; 2 signals, 4 chan IR (L -> L, R -> R, L -> R, R -> L)', 'http://gareus.org/oss/lv2/convoLV2#MonoToStereo', 3, 1),
           (45, 'LV2 Convolution Mono', 'Zero latency Mono Signal Convolution Processor', 'http://gareus.org/oss/lv2/convoLV2#Mono', 3, 1),
           (46, 'Stereo Balance Control', 'balance.lv2 facilitates adjusting stereo-microphone recordings (X-Y, A-B, ORTF). But it also generally useful as ''Input Channel Conditioner''.	It allows for attenuating the signal on one of the channels as well as delaying the signals (move away from the microphone). To round off the feature-set channels can be swapped or the signal can be downmixed to mono after the delay.
	It features a Phase-Correlation meter as well as peak programme meters according to IEC 60268-18 (5ms integration, 20dB/1.5 sec fall-off) for input and output signals.
	The meters can be configure on the right side of the GUI, tilt it using the ''a'' key.', 'http://gareus.org/oss/lv2/balance', 3, 1),
           (47, 'Triceratops', 'A Big Synth', 'http://nickbailey.co.nr/triceratops', 4, 1),
           (48, 'TAP Vibrato', 'This plugin modulates the pitch of its input signal with a low-frequency sinusoidal signal. It is useful for guitar and synth tracks, and it can also come handy if a strange effect is needed.

source: http://tap-plugins.sourceforge.net/ladspa/vibrato.html
', 'http://moddevices.com/plugins/tap/vibrato', 5, 1),
           (49, 'TAP Tubewarmth', 'TAP TubeWarmth adds the character of vacuum tube amplification to your audio tracks by emulating the sonically desirable nonlinear characteristics of triodes. In addition, this plugin also supports emulating analog tape saturation.

source: http://tap-plugins.sourceforge.net/ladspa/tubewarmth.html
', 'http://moddevices.com/plugins/tap/tubewarmth', 5, 1),
           (50, 'TAP Tremolo', 'The tremolo effect is probably one of the most ancient effects, originated in the earliest days of the history of studio recording. It lost some of its popularity over time (and with the emerge of more exciting digital effects), but you still hear this effect on newer recordings from time to time.

source: http://tap-plugins.sourceforge.net/ladspa/tremolo.html
', 'http://moddevices.com/plugins/tap/tremolo', 5, 1),
           (51, 'TAP Sigmoid Booster', 'This plugin applies a time-invariant nonlinear amplitude transfer function to the signal. Depending on the signal and the plugin settings, various related effects (compression, soft limiting, emulation of tape saturation, mild distortion) can be achieved.

source: http://tap-plugins.sourceforge.net/ladspa/sigmoid.html
', 'http://moddevices.com/plugins/tap/sigmoid', 5, 1),
           (52, 'TAP Rotary Speaker', 'This plugin simulates the sound of rotating speakers. Two pairs of rotating speakers are simulated, each pair fixed on a vertical axis, with their horns spreading the sound in opposite directions. The two pairs of speakers are rotating with different revolutions (frequencies). The incoming sound is split into a low and a high part (with a low-pass and a high-pass filter, using a crossover frequency of 1 kHz). The low part is fed into the "Rotor" pair of speakers, and the high part into the "Horn" pair. A pair of horizontally aligned microphones is used to pick up the resulting sound. The distance of the microphones (the width of the stereo image of the effect) is adjustable.

source: http://tap-plugins.sourceforge.net/ladspa/rotspeak.html
', 'http://moddevices.com/plugins/tap/rotspeak', 5, 1),
           (53, 'TAP Reverberator', 'TAP Reverberator is unique among reverberators freely available on the Linux platform. It supports creating no less than 43 reverberation effects, but its design permits this to be extended even further by the user, without doing any actual programming. Please take a look at TAP Reverb Editor, a separate JACK application for more information about this.

The design is based on the comb/allpass filter model. Comb filters create early reflections and allpass filters add to this by creating a dense reverberation effect. The output of the set of comb and allpass filters (also called the reverberator chamber) is processed further by sending it through a bandpass filter. The resulting band-limited reverberation is very similar to the natural reverberation that occurs in acoustic rooms. To achieve an even more natural-sounding effect, all comb filters have high-frequency compensation in their feedback loop. This is to model that the reflection ratio of acoustic surfaces is the function of frequency: higher frequencies are attenuated more, and thus decay time of higher frequency components is significantly shorter.

To enhance the reverberation sound even further, a special option called Enhanced Stereo is provided. When turned on (which is the default), it results in an added spatial spread of the reverb sound. This feature is most noticeable when applying the plugin to mono tracks: the sound of these tracks will "open up" in space.

source: http://tap-plugins.sourceforge.net/ladspa/reverb.html
', 'http://moddevices.com/plugins/tap/reverb', 5, 1),
           (54, 'TAP Reflector', 'This plugin creates a psychedelic reverse audio effect. Overlapping time intervals of incoming samples are treated as blocks called ''fragments''. Each fragment is reversed in time, and faded in and out while played back to the output, hence creating a nearly constant signal level with the mixture resembling a normal reverse-played track -- with the difference that the audio actually progresses forward, only pieces of it are reversed.

source: http://tap-plugins.sourceforge.net/ladspa/reflector.html
', 'http://moddevices.com/plugins/tap/reflector', 5, 1),
           (55, 'TAP Pitch Shifter', 'This plugin gives you the opportunity to change the pitch of individual tracks or full mixes, in the range of plus/minus one octave. Audio length (tempo) is not affected by this plugin, since audio is completely resampled. Besides being a special effect for creating foxy guitar tracks, it may come handy if your (otherwise very attractive) singer or chorus-girl was a bit indisposed at the time of recording: with the power of Ardour automation, you are given a chance to correct smaller pitch errors.

source: http://tap-plugins.sourceforge.net/ladspa/pitch.html
', 'http://moddevices.com/plugins/tap/pitch', 5, 1),
           (56, 'TAP Pink/Fractal Noise', 'This plugin came to life as a secondary product of the development of TAP Fractal Doubler. It adds pink noise to the incoming signal using a one-dimensional random fractal line generated by the Midpoint Displacement Method, which is a computationally cheap method suitable for generating random fractals.

source: http://tap-plugins.sourceforge.net/ladspa/pinknoise.html
', 'http://moddevices.com/plugins/tap/pinknoise', 5, 1),
           (57, 'TAP Scaling Limiter', 'You want to maximize the loudness of your master tracks. Your drummer has the habit of playing with varying velocity. You want to squeeze high transient spikes down into the bulk of the audio. You want a limiter with transparent sound, but without distortion. This is for you, then. The unique design of this innocent looking plugin results in the ability to achieve signal level limiting without audible artifacts.

Most limiters operate on the same basis as compressors: they monitor the signal level, and when it gets above a threshold level they reduce the gain on a momentary basis, resulting in an unpleasant "pumping" effect. Or even worse, they chop the signal at the top. This plugin actually scales each half-cycle individually down to a smaller level so the peak is placed exactly at the limit level. This operation (from zero-cross to zero-cross) results in an instantaneous blending of peaks and transient spikes down into the bulk of the audio.

source: http://tap-plugins.sourceforge.net/ladspa/limiter.html
', 'http://moddevices.com/plugins/tap/limiter', 5, 1),
           (58, 'TAP Equalizer', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://moddevices.com/plugins/tap/eq', 5, 1),
           (59, 'TAP Equalizer/BW', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://moddevices.com/plugins/tap/eqbw', 5, 1),
           (60, 'TAP Stereo Echo', 'This plugin supports conventional mono and stereo delays, ping-pong delays and the Haas effect (also known as Cross Delay Stereo). A relatively simple yet quite effective plugin.

source: http://tap-plugins.sourceforge.net/ladspa/echo.html
', 'http://moddevices.com/plugins/tap/echo', 5, 1),
           (61, 'TAP Stereo Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://moddevices.com/plugins/tap/dynamics-st', 5, 1),
           (62, 'TAP Mono Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://moddevices.com/plugins/tap/dynamics', 5, 1),
           (63, 'TAP Fractal Doubler', 'Originally developed to do vocal doubling, this plugin is suitable for doubling tracks with vocals, acoustic/electric guitars, bass and just about any other instrument on them. The effect is created by applying small changes to the pitch and timing of the incoming signal. These changes are created by one-dimensional random fractal lines producing pink noise.

source: http://tap-plugins.sourceforge.net/ladspa/doubler.html
', 'http://moddevices.com/plugins/tap/doubler', 5, 1),
           (64, 'TAP DeEsser', 'TAP DeEsser is a plugin for attenuating higher pitched frequencies in vocals such as those found in ''ess'', ''shh'' and ''chh'' sounds.
Almost any vocal recording will contain ''ess'' sounds, whether a strong vocal delivery, from bad recording, speech impediments or simply many ''ess'' words spoken together.
Wind instruments and other musical instruments can also create shrill high-pitched noises. Audio engineers need to control these harsh ''ess'' sounds in most recordings.
', 'http://moddevices.com/plugins/tap/deesser', 5, 1),
           (65, 'TAP Chorus/Flanger', 'This plugin is an implementation capable of creating traditional Chorus and Flanger effects, spiced up a bit to make use of stereo processing.
It sounds best on guitar and synth tracks.
', 'http://moddevices.com/plugins/tap/chorusflanger', 5, 1),
           (66, 'TAP AutoPanner', 'The AutoPanner is a very well-known effect; its hardware incarnation originates in the age of voltage controlled synthesizers.
Its main use is to liven up synth tracks in the mix.
', 'http://moddevices.com/plugins/tap/autopan', 5, 1),
           (67, 'SooperLooper', 'Basic looping plugin
', 'http://moddevices.com/plugins/sooperlooper', 6, 1),
           (68, 'Shiroverb', 'Shiroverb is a shimmer-reverb based on the "Gigaverb"-genpatch, ported from the implementation by Juhana Sadeharju, and the "Pitch-Shift"-genpatch, both in Max MSP.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/shiroverb', 7, 1),
           (69, 'Pitchotto', 'Pitchotto is a pitch-shifter based on the "Pitch-Shift"-genpatch in Max, where Phase-shifting is used to achieve different intervals.
There are two shifted signals available, both with variable delay-lengths for arpeggio-like sounds.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/pitchotto', 8, 1),
           (70, 'Modulay', 'Modulay is a delay with variable types of modulation based on the setting of the Morph-knob.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/modulay', 7, 1),
           (71, 'Larynx', 'Larynx is a simple vibrato with a tone control.
', 'https://github.com/ninodewit/SHIRO-Plugins/plugins/larynx', 7, 1),
           (72, 'setBfree Whirl Speaker - Extended Version', 'A rotating loudspeaker emulator designed to imitate the sound and properties of the sound modification device that brought world-wide fame to the name of Don Leslie', 'http://gareus.org/oss/lv2/b_whirl#extended', 2, 1),
           (73, 'setBfree Whirl Speaker', 'A rotating loudspeaker emulator designed to imitate the sound of device that brought world-wide fame to the name of Don Leslie', 'http://gareus.org/oss/lv2/b_whirl#simple', 2, 1),
           (74, 'setBfree DSP Tonewheel Organ', 'setBfree is a MIDI-controlled, software synthesizer designed to imitate the sound and properties of the electromechanical organs and sound modification devices that brought world-wide fame to the names and products of Laurens Hammond and Don Leslie.', 'http://gareus.org/oss/lv2/b_synth', 2, 1),
           (75, 'setBfree Organ Reverb', 'A Schroeder Reverberator', 'http://gareus.org/oss/lv2/b_reverb', 2, 1),
           (76, 'setBfree Organ Overdrive', 'A mean fuzz/overdrive used for the setBfree Tonewheel Organ.', 'http://gareus.org/oss/lv2/b_overdrive', 2, 1),
           (77, 'rkr Reverb', 'Adapted from the ZynAddSubFX Reverb', 'http://rakarrack.sourceforge.net/effects.html#reve', 9, 1),
           (78, 'rkr Parametric EQ', '3 band parametric peak-filter equalizer.', 'http://rakarrack.sourceforge.net/effects.html#eqp', 9, 1),
           (79, 'rkr Distortion', 'Adapted from the ZynAddSubFX Distortion        
This is a waveshaper, and not particularly an amp or stompbox modeling effect. This must be used judiciously with EQ''s as well as the LPF and HPF settings (Low Pass Filter, High Pass Filter)

', 'http://rakarrack.sourceforge.net/effects.html#dist', 9, 1),
           (80, 'rkr StompBox:Fuzz', 'Physically-informed fuzz stompbox emulation. Based on several popular schematics, this is designed to capture the sound of an era more than emulate a specific model.', 'http://rakarrack.sourceforge.net/effects.html#StompBox_fuzz', 9, 1),
           (81, 'rkr WahWah', 'Wah effect controllable by the input volume envelope or by LFO.', 'http://rakarrack.sourceforge.net/effects.html#wha', 9, 1),
           (82, 'rkr Pan', 'LFO controlled auto-panning/stereo tremelo effect. Useful to expand your stereo image.', 'http://rakarrack.sourceforge.net/effects.html#pan', 9, 1),
           (83, 'rkr Harmonizer (no midi)', 'Pitch shifter that harmonizes with your dry signal. This works best for monophonic sounds (a single note at a time). Also allows selection of root and chord for intelligent harmonies.', 'http://rakarrack.sourceforge.net/effects.html#har_no_mid', 9, 1),
           (84, 'rkr EQ', '10 band graphical equalizer with resonance control.', 'http://rakarrack.sourceforge.net/effects.html#eql', 9, 1),
           (85, 'rkr Echo', 'Configurable echo effect with a reverse echo feature.', 'http://rakarrack.sourceforge.net/effects.html#eco', 9, 1),
           (86, 'rkr Derelict', 'A very configurable waveshaping distortion module with resonance control of the filters for extra color.', 'http://rakarrack.sourceforge.net/effects.html#dere', 9, 1),
           (87, 'rkr Musical Delay', 'Dual delay with delay times selectable by tempo and note subdivision.', 'http://rakarrack.sourceforge.net/effects.html#delm', 9, 1),
           (88, 'rkr Compressor', 'A flexible compressor with optional soft knee and makeup gain.', 'http://rakarrack.sourceforge.net/effects.html#comp', 9, 1),
           (89, 'rkr Flanger/Chorus', 'A flanger or chorus (depending on delay time) effect. Allows for fractional delays for a more intense effect.', 'http://rakarrack.sourceforge.net/effects.html#chor', 9, 1),
           (90, 'rkr Cabinet', 'Equalizer with preset curves to match the effect of various guitar cabinets.', 'http://rakarrack.sourceforge.net/effects.html#cabe', 9, 1),
           (91, 'rkr AlienWah', 'This effect features two alternating comb filters for a vocal/formant-like wah sound. It could be considered a combined flanger and phaser. It can be extreme or add very subtle shimmer', 'http://rakarrack.sourceforge.net/effects.html#awha', 9, 1),
           (92, 'rkr Analog Phaser', 'A physically-informed, highly-configurable digital model of an analog FET phaser effect.', 'http://rakarrack.sourceforge.net/effects.html#aphas', 9, 1),
           (93, 'rkr Vocoder', '32 band vocoder. This type of effect is well known for creating robot-like voices in popular music. The input is divided into frequency bands and each band''s volume is controlled by an auxiliary input''s frequency curve such that the output signal is filtered to sound like the aux signal.', 'http://rakarrack.sourceforge.net/effects.html#Vocoder', 9, 1),
           (94, 'rkr Vibe', 'The UniVibe was intended as a rotating speaker emulation. It does a poor job of that, but in its own right became a popular phase-shifter effect. This version has optional feedback to achieve some additional tones.', 'http://rakarrack.sourceforge.net/effects.html#Vibe', 9, 1),
           (95, 'rkr VaryBand', 'Multi-band tremolo effect allowing 2 LFOs to modulate volume of any combination of 4 frequency bands.', 'http://rakarrack.sourceforge.net/effects.html#VaryBand', 9, 1),
           (96, 'rkr Valve', 'Tube distortion emulation with extra distortion available.', 'http://rakarrack.sourceforge.net/effects.html#Valve', 9, 1),
           (97, 'rkr Synthfilter', 'A filter like what can be found in synthesizers. Up to 12 lowpass + 12 highpass filters with resonance. Cutoff frequency is controllable by LFO or volume envelope.', 'http://rakarrack.sourceforge.net/effects.html#Synthfilter', 9, 1),
           (98, 'rkr Sustainer', 'A very simple, no-frills soft knee compressor good for making notes sustain. Brighter than the full Rakarrack Compressor.', 'http://rakarrack.sourceforge.net/effects.html#Sustainer', 9, 1),
           (99, 'rkr StompBox', 'Physically-informed distortion stompbox emulation with 8 different distortion-character modes. Intended to allow quick dialing-in to the tone you want.', 'http://rakarrack.sourceforge.net/effects.html#StompBox', 9, 1),
           (100, 'rkr StereoHarmonizer (no midi)', 'Pitch shifter that harmonizes 2 voices with your dry signal. This works best for monophonic sounds (a single note at a time). This version has a detune for stereo chorus effects. Also allows selection of root and chord for intelligent harmonies.', 'http://rakarrack.sourceforge.net/effects.html#StereoHarm_no_mid', 9, 1),
           (101, 'rkr Shuffle', 'Creates interesting spatial effects. Converts stereo signal to Mid/Side and applys a parametric four band EQ to M or S channel. Effect based on Stereo Shuffling paper by Michael Gerzon.', 'http://rakarrack.sourceforge.net/effects.html#Shuffle', 9, 1),
           (102, 'rkr Shifter', 'Pitch shifter with easy controls for expression pedal controled whammy effects. Also has a mode for envelope based control.', 'http://rakarrack.sourceforge.net/effects.html#Shifter', 9, 1),
           (103, 'rkr Shelf Boost', 'Low-shelf filter for simple control of your tone.', 'http://rakarrack.sourceforge.net/effects.html#ShelfBoost', 9, 1),
           (104, 'rkr Sequence', '8-step modulation sequencer. Each step is user-adjustable. Signal amplitude, filter cutoff frequency, or pitch shifting modulations available.', 'http://rakarrack.sourceforge.net/effects.html#Sequence', 9, 1),
           (105, 'rkr Ring', 'A ring modulator with monophonic frequency recognition for synthesis.', 'http://rakarrack.sourceforge.net/effects.html#Ring', 9, 1),
           (106, 'rkr Reverbtron', 'Convolution-based reverb effect. IR samples can be converted to .rvb format and loaded into this effect for a less cpu-intensive convolution. Several files included.', 'http://rakarrack.sourceforge.net/effects.html#Reverbtron', 9, 1),
           (107, 'rkr OpticalTrem', 'An optical tremolo effect emulation such as often built into a guitar amplifier. This varies the signal volume through an LFO.', 'http://rakarrack.sourceforge.net/effects.html#Otrem', 9, 1),
           (108, 'rkr MuTroMojo', 'State variable filter with envelope or LFO modulation. Allows it to act like a mixable blend of highpass, lowpass or bandpass filter. Similar to a mutron III. Also useful for classic wah pedal emulation when wah parameter is controlled by an expression pedal.', 'http://rakarrack.sourceforge.net/effects.html#MuTroMojo', 9, 1),
           (109, 'rkr Infinity', 'This is the audio equivalent of a barber pole effect, with 8 filter bands continuously sweeping up or down. This has enough flexibility to create effects anywhere from subtle to insane.', 'http://rakarrack.sourceforge.net/effects.html#Infinity', 9, 1),
           (110, 'rkr Expander', 'Analog BJT modeled dynamic expander for subtler noise suppression than a gate typically offers. Can also be used for interesting evelope-triggered swell and fade effects.', 'http://rakarrack.sourceforge.net/effects.html#Expander', 9, 1),
           (111, 'rkr Exciter', 'Harmonic exciter that allows you to adjust the volume of each of 10 harmonics.', 'http://rakarrack.sourceforge.net/effects.html#Exciter', 9, 1),
           (112, 'rkr Echoverse', 'Configurable echo designed to be stable for thick, in-your-face walls of sound.', 'http://rakarrack.sourceforge.net/effects.html#Echoverse', 9, 1),
           (113, 'rkr Echotron', 'An extremely-configurable delay that allows up to 127 taps. Individual tap timing can be customized and loaded through text files. You can also have a custom filter on each tap. Several example files included.', 'http://rakarrack.sourceforge.net/effects.html#Echotron', 9, 1),
           (114, 'rkr Dual Flange', 'Two flange effects cascaded to create unique and more intense tones than available through a single flanger.', 'http://rakarrack.sourceforge.net/effects.html#Dual_Flange', 9, 1),
           (115, 'rkr DistBand', 'A multi-band distortion allowing different character distortion of different frequencies. It is a waveshaping distortion with a different waveshaper selectable for each band.', 'http://rakarrack.sourceforge.net/effects.html#DistBand', 9, 1),
           (116, 'rkr CompBand', 'Multi-band compressor with 4 frequency bands and wet/dry mix control. Each band has individual ratio and threshold controls.', 'http://rakarrack.sourceforge.net/effects.html#CompBand', 9, 1),
           (117, 'rkr Coil Crafter', 'A equalizer that makes your pickups sound like different pickups. Can switch a strat to sound like humbuckers in a strat etc.', 'http://rakarrack.sourceforge.net/effects.html#CoilCrafter', 9, 1),
           (118, 'rkr Arpie', 'A pitch shifter that changes the shifting amount in a rhythmic pattern. Adds pulse and brightness to your sound.', 'http://rakarrack.sourceforge.net/effects.html#Arpie', 9, 1),
           (119, 'ToggleSwitch', 'This toggled switch enables the output depending on the button state.
', 'http://moddevices.com/plugins/mod-devel/ToggleSwitch4', 6, 1),
           (120, 'SwitchTrigger4', 'The Switch Trigger gets one audio stream as input and chooses one of four outputs
to route the audio. The output channel can be selected by triggering the corresponding
control.

The switch trigger was designed to use the MOD on stage. By addressing each control to a
footswitch, the musician can quickly access a desired chain of effects.
', 'http://moddevices.com/plugins/mod-devel/SwitchTrigger4', 6, 1),
           (121, 'SwitchBox2', 'This switch box receives an audio input and channel it by one of it''s two outputs.

', 'http://moddevices.com/plugins/mod-devel/SwitchBox2', 6, 1),
           (122, 'LowPassFilter', 'A simple low pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies below the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://moddevices.com/plugins/mod-devel/LowPassFilter', 6, 1),
           (123, 'HighPassFilter', 'A simple high pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies above the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://moddevices.com/plugins/mod-devel/HighPassFilter', 6, 1),
           (124, 'Gain 2x2', 'Stereo version of the simple volume gain plugin without "zipping" noise while messing with the gain parameter.
', 'http://moddevices.com/plugins/mod-devel/Gain2x2', 6, 1),
           (125, 'Gain', 'Simple volume gain plugin without "zipping" noise while messing with the gain parameter.
', 'http://moddevices.com/plugins/mod-devel/Gain', 6, 1),
           (126, 'CrossOver 3', 'This plugin receives an input signal and outputs 3 filtered signals. First one is filtered with a low pass filter (LPF), the second with a band pass filter (BPF) and the third with a high pass filter (HPF), cutoff frequency used on LPF and as the lower frequency from BPF is controlled by "Freq 1" and cutoff frequency used as the higher frequency on BPF and in HPF is controlled by "Freq 2". "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1", "Gain 2" and "Gain 3" controls the gains of all outputs respectively.


', 'http://moddevices.com/plugins/mod-devel/CrossOver3', 6, 1),
           (127, 'CrossOver 2', 'This plugin receives an input signal and outputs 2 filtered signals. First one is filtered with a low pass filter (LPF) and the second, with a high pass filter (HPF), both cutoff frequencies are determined by "Freq" parameter. "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1" and "Gain 2" controls the gains of both outputs respectively.

', 'http://moddevices.com/plugins/mod-devel/CrossOver2', 6, 1),
           (128, 'BandPassFilter', 'A band pass filter, "Freq" determines its Center frequency, "Q" works on the filter bandwith and "Order" is the filter''s order
(or how fast frequencies above the higher cutoff frequency and below the lower cutoff frequency will decay).
Higher the order, faster the decay.
', 'http://moddevices.com/plugins/mod-devel/BandPassFilter', 6, 1),
           (129, 'Super Whammy', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/SuperWhammy', 6, 1),
           (130, 'Super Capo', 'It''s a pitch shifter which can rise the pitch until 24 semitones (steps).
Because it''s more limited than Super Whammy it uses less processing, but still more than Capo.
', 'http://moddevices.com/plugins/mod-devel/SuperCapo', 6, 1),
           (131, 'HarmonizerCS', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/HarmonizerCS', 6, 1),
           (132, 'Harmonizer2', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/Harmonizer2', 6, 1),
           (133, 'Harmonizer', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up.
"First" and "Last" determine the range of variation where the "Step" parameter will work.
"First" doesn''t need to be necessarily smaller than "Last".
"Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.
', 'http://moddevices.com/plugins/mod-devel/Harmonizer', 6, 1),
           (134, 'Drop', 'It''s a pitch shifter which can drop the pitch until 12 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/Drop', 6, 1),
           (135, 'Capo', 'It''s a pitch shifter which can rise the pitch until 4 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/Capo', 6, 1),
           (136, '2Voices', 'It''s a pitch shifter which can rise the pitch until 4 semitones (steps).
Despite being more limited than Super Whammy it uses less processing.
', 'http://moddevices.com/plugins/mod-devel/2Voices', 6, 1),
           (137, 'MDA Vocoder', '16-band vocoder for applying the spectrum of one sound (the modulator, usually a voice or rhythm part) to the waveform of another (the carrier, usually a synth pad or sawtooth wave).
Note that both carrier and modulator signals are taken from one input channel, which therefore must be stereo for normal operation. This is different to some other vocoder plug-ins where one of the input signals is taken from another plug-in in a different channel.', 'http://moddevices.com/plugins/mda/Vocoder', 10, 1),
           (138, 'MDA VocInput', 'This plug-in produces a voice-like signal on the right channel to be used as a carrier signal with vocoder and other vocoder plug-ins. The input signal passes through on the left channel.', 'http://moddevices.com/plugins/mda/VocInput', 10, 1),
           (139, 'MDA Transient', '', 'http://moddevices.com/plugins/mda/Transient', 10, 1),
           (140, 'MDA Tracker', 'This plug-in tracks the frequency of the input signal with an oscillator, ring modulator or filter.  The pitch tracking only works with monophonic inputs, but can create interesting effects on unpitched sounds such as drums.
This plug can be used with white or pink noise inputs to generate random pitch sequences.  Interesting evolving soundscapes can be made with a drum loop input and Tracker, RezFilter and Delay in series.', 'http://moddevices.com/plugins/mda/Tracker', 10, 1),
           (141, 'MDA ThruZero', 'Tape flanger and ADT
This plug simulates tape-flanging, where two copies of a signal cancel out completely as the tapes pass each other. It can also be used for other "modulated delay" effects such as phasing and simple chorusing.', 'http://moddevices.com/plugins/mda/ThruZero', 10, 1),
           (142, 'MDA TestTone', '', 'http://moddevices.com/plugins/mda/TestTone', 10, 1),
           (143, 'MDA TalkBox', '', 'http://moddevices.com/plugins/mda/TalkBox', 10, 1),
           (144, 'MDA SubSynth', 'More bass than you could ever need! Be aware that you may be adding low frequency content outside the range of your monitor speakers.  To avoid clipping, follow with a limiter plug-in (this can also give some giant hip-hop drum sounds!).', 'http://moddevices.com/plugins/mda/SubSynth', 10, 1),
           (145, 'MDA Stereo', '', 'http://moddevices.com/plugins/mda/Stereo', 10, 1),
           (146, 'MDA Splitter', 'This plug-in can split a signal based on frequency or level, for example for producing dynamic effects where only loud drum hits are sent to a reverb. Other functions include a simple "spectral gate" in INVERSE mode and a conventional gate and filter for separating drum sounds in NORMAL mode.', 'http://moddevices.com/plugins/mda/Splitter', 10, 1),
           (147, 'MDA Shepard', 'This plug-in actually generates "Risset tones". Discrete stepping "Shepard tones" will hopefully be included in a future version. Continuously rising/falling tone generator.', 'http://moddevices.com/plugins/mda/Shepard', 10, 1),
           (148, 'MDA RoundPan', 'Like all 3D processes the result depends on where you sit relative to the speakers, and mono compatibility is not guaranteed. This plug-in must be used in a stereo channel or bus!', 'http://moddevices.com/plugins/mda/RoundPan', 10, 1),
           (149, 'MDA RingMod', 'Simple ring modulator with sine-wave oscillator.
Can be used as a high-frequency enhancer for drum sounds (when mixed with the original), adding dissonance to pitched material, and severe tremolo (at low frequency settings).', 'http://moddevices.com/plugins/mda/RingMod', 10, 1),
           (150, 'MDA RezFilter', '', 'http://moddevices.com/plugins/mda/RezFilter', 10, 1),
           (151, 'MDA RePsycho!', ' Event-based pitch shifter
Chops audio into individual beats and shifts each beat downwards in pitch. Only allowing downwards shifts helps keep timing very tight - depending on complexity, whole rhythm sections can be shifted!

Alternative uses include a triggered flanger or sub-octave doubler (both with mix set to 50% or less) and a swing quantizer (with a high threshold so not all beats trigger).
', 'http://moddevices.com/plugins/mda/RePsycho', 10, 1),
           (152, 'MDA Piano', '', 'http://moddevices.com/plugins/mda/Piano', 10, 1),
           (153, 'MDA Overdrive', 'Possible uses include adding body to drum loops, fuzz guitar, and that ''standing outside a nightclub'' sound. This plug does not simulate valve distortion, and any attempt to process organ sounds through it will be extremely unrewarding!', 'http://moddevices.com/plugins/mda/Overdrive', 10, 1),
           (154, 'MDA MultiBand', 'As well as just "squashing everything" this plug-in can be used to "overcook" the mid-frequencies while leaving the low end unprocessed, enhancing playback over small speakers without affecting the overall sound too much.
To give more control when mastering (and to offer something different from other dynamics processors) in Mono mode this plug does not compress any stereo information, but in Stereo mode only the stereo component is processed giving control over ambience and space with a similar sound to strereo "shufflers" - but be careful with the levels!  The stereo width control works as a "mono depth" control in Stereo mode.', 'http://moddevices.com/plugins/mda/MultiBand', 10, 1),
           (155, 'MDA Loudness', 'The ear is less sensitive to low frequencies when listening at low volume. This plug-in is based on the Stevens-Davis equal loudness contours and allows the bass level to be adjusted to simulate or correct for this effect.
Example uses:

If a mix was made with a very low or very high monitoring level, the amount of bass can sound wrong at a normal monitoring level. Use Loudness to adjust the bass content.
Check how a mix would sound at a much louder level by decreasing Loudness. (although the non-linear behaviour of the ear at very high levels is not simulated by this plug-in).

Fade out without the sound becoming "tinny" by activating Link and using Loudness to adjust the level without affecting the tonal balance.', 'http://moddevices.com/plugins/mda/Loudness', 10, 1),
           (156, 'MDA Limiter', '', 'http://moddevices.com/plugins/mda/Limiter', 10, 1),
           (157, 'MDA Leslie', 'No overdrive or speaker cabinet simulation is added - you may want to combine this plug-in with Combo.  For a much thicker sound try combining two Leslie plug-ins in series!', 'http://moddevices.com/plugins/mda/Leslie', 10, 1),
           (158, 'MDA JX10', '  A polyphonic synthesizer with a lot of options to modulate the filter, with envelope and/or lfo.
  When Vibrato is set to PWM, the two oscillators are phase-locked and will produce a square wave if set to the same pitch. Pitch modulation of one oscillator then causes Pulse Width Modulation. (pitch modulation of both oscillators for vibrato is still available from the modulation wheel). Unlike other synths, in PWM mode the oscillators can still be detuned to give a wider range of PWM effects.
    ', 'http://moddevices.com/plugins/mda/JX10', 10, 1),
           (159, 'MDA Image', 'Allows the level and pan of mono and stereo components to be adjusted separately, or components to be separated for individual processing before recombining with a second Image plug-in.', 'http://moddevices.com/plugins/mda/Image', 10, 1),
           (160, 'MDA ePiano', '    It''s a virtual ePiano plugin. Based around 12 carefully sampled and mastered Rhodes Piano samples.
    ', 'http://moddevices.com/plugins/mda/EPiano', 10, 1),
           (161, 'MDA Dynamics', '', 'http://moddevices.com/plugins/mda/Dynamics', 10, 1),
           (162, 'MDA DX10', 'Sounds similar to the later Yamaha DX synths including the heavy bass but with a warmer, cleaner tone.  This plug-in is 8-voice polyphonic.', 'http://moddevices.com/plugins/mda/DX10', 10, 1),
           (163, 'MDA DubDelay', 'Delay with feedback saturation and time/pitch modulation
', 'http://moddevices.com/plugins/mda/DubDelay', 10, 1),
           (164, 'MDA Dither', 'When a waveform is rounded to the nearest 16 (or whatever)-bit value this causes distortion. Dither allows you to exchange this rough sounding signal-dependant distortion for a smooth background hiss.
Some sort of dither should always be used when reducing the word length of digital audio, such as from 24-bit to 16-bit. In many cases the background noise in a recording will act as dither, but dither will still be required on fades and on very clean recordings such as purely synthetic sources.

Noise shaping makes the background hiss of dither sound quieter, but adds more high-frequency noise than ''ordinary'' dither. This high frequency noise can be a problem if a recording is later processed in any way (including gain changes) especially if noise shaping is applied a second time.

If you are producing an absolutely final master at 16 bits or less, use noise shaped dither. In all other situations use a non-noise-shaped dither such as high-pass-triangular. When mastering for MP3 or other compressed formats be aware that noise shaping may take some of the encoder''s ''attention'' away from the real signal at high frequencies.

No gain changes should be applied after this plug-in. Make sure any master output fader is set to 0.0 dB in the host application.

Very technical note This plug-in follows Steinberg''s convention that a signal level of 1.0 corresponds to a 16-bit output of 32768. If your host application does not allow this exact gain setting the effectiveness of dither may be reduced (check for harmonic distortion of a 1 kHz sine wave using a spectrum analyser).', 'http://moddevices.com/plugins/mda/Dither', 10, 1),
           (165, 'MDA Detune', 'A low-quality stereo pitch shifter for the sort of chorus and detune effects found on multi-effects hardware.', 'http://moddevices.com/plugins/mda/Detune', 10, 1),
           (166, 'MDA Delay', '', 'http://moddevices.com/plugins/mda/Delay', 10, 1),
           (167, 'MDA Degrade', '', 'http://moddevices.com/plugins/mda/Degrade', 10, 1),
           (168, 'MDA De-ess', 'Reduce excessive sibilants (/s/ /t/ /sh/ etc.) in vocals and speech.
For stronger de-essing you may want to use two plug-ins in series, or apply processing twice.', 'http://moddevices.com/plugins/mda/DeEss', 10, 1),
           (169, 'MDA Combo', 'This plug-in can sound quite subtle but comes alive when used on guitar with the drive turned up!  Remember that distortion may not sound good on time-based effects such as delay and reverb, so put those effects after this plug, or after a separate distortion plug with Combo acting only as a speaker simulator.', 'http://moddevices.com/plugins/mda/Combo', 10, 1),
           (170, 'MDA BeatBox', 'Contains three samples (kick, snare and hat) designed to be triggered by incoming audio in three frequency ranges.  The default samples are based on the Roland CR-78.
To record your own sounds, use the Record control to monitor the plug''s input, then with the source stopped select the slot to record into, play your sound, then with the source stopped again, switch back to monitoring.  This process is easier in an ''off line'' editor such as WaveLab, rather than during a live mixdown in a DAW.', 'http://moddevices.com/plugins/mda/BeatBox', 10, 1),
           (171, 'MDA Bandisto', 'This plug is like MultiBand but uses 3 bands of clipping instead of compression.  This is unlikely to be a plug you use every day, but when you want to recreate the sound of torn bass-bins you know where to come!', 'http://moddevices.com/plugins/mda/Bandisto', 10, 1),
           (172, 'MDA Ambience', 'A plugin that simulates a room.
', 'http://moddevices.com/plugins/mda/Ambience', 10, 1),
           (173, 'DS1', 'Analog distortion emulation of the classic Boss DS-1 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Boss DS-1 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://moddevices.com/plugins/mod-devel/DS1', 6, 1),
           (174, 'Open Big Muff', 'Analog distortion emulation of the classic Electro-Harmonix Big Muff Pi (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Big Muff Pi is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://moddevices.com/plugins/mod-devel/BigMuffPi', 6, 1),
           (175, 'Invada Stereo Phaser (sum L+R in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/sum', 11, 1),
           (176, 'Invada Stereo Phaser (stereo in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/stereo', 11, 1),
           (177, 'Invada Stereo Phaser (mono in)', 'Subtle phaser with a very large LFO range
', 'http://invadarecords.com/plugins/lv2/phaser/mono', 11, 1),
           (178, 'Invada Delay Munge (sum L+R in)', 'A wet only delay with munged delays, the pitch can be modulated by a lfo.
', 'http://invadarecords.com/plugins/lv2/delay/sum', 11, 1),
           (179, 'Invada Delay Munge (mono in)', 'A wet only delay with munged delays, the pitch can be modulated by a lfo.
', 'http://invadarecords.com/plugins/lv2/delay/mono', 11, 1),
           (180, 'Invada Tube Distortion (stereo)', 'Tube distortion, with a DC offset options
', 'http://invadarecords.com/plugins/lv2/tube/stereo', 11, 1),
           (181, 'Invada Tube Distortion (mono)', 'Tube distortion, with a DC offset options
', 'http://invadarecords.com/plugins/lv2/tube/mono', 11, 1),
           (182, 'Invada Test Tones', '    A sine generator to test connections
', 'http://invadarecords.com/plugins/lv2/testtone', 11, 1),
           (183, 'Invada Input Module', '    Lets you modify the basics of a stereo signal, such as stereo width, panning and phase
', 'http://invadarecords.com/plugins/lv2/input', 11, 1),
           (184, 'Invada Low Pass Filter (stereo)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/lpf/stereo', 11, 1),
           (185, 'Invada Low Pass Filter (mono)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/lpf/mono', 11, 1),
           (186, 'Invada High Pass Filter (stereo)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/hpf/stereo', 11, 1),
           (187, 'Invada High Pass Filter (mono)', 'Simple filter whitout resonance
', 'http://invadarecords.com/plugins/lv2/filter/hpf/mono', 11, 1),
           (188, 'Invada Early Reflection Reverb (sum L+R in)', '    A Room simulator wich let you set the height, width and length of the room.
', 'http://invadarecords.com/plugins/lv2/erreverb/sum', 11, 1),
           (189, 'Invada Early Reflection Reverb (mono in)', '    A Room simulator wich let you set the height, width and length of the room.
', 'http://invadarecords.com/plugins/lv2/erreverb/mono', 11, 1),
           (190, 'Invada Compressor (stereo)', 'An easy to use high-quality compressor. 
', 'http://invadarecords.com/plugins/lv2/compressor/stereo', 11, 1),
           (191, 'Invada Compressor (mono)', 'An easy to use high-quality compressor.
', 'http://invadarecords.com/plugins/lv2/compressor/mono', 11, 1),
           (192, 'GxVoxTonebender', 'Analog distortion emulation of the classic Vox Tone Bender (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Vox Tone Bender is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_voxtb_#_voxtb_', 12, 1),
           (193, 'GxWah', '
Analog wah emulation of the classic Dunlop Crybaby (*).

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Crybaby is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gxautowah#wah', 12, 1),
           (194, 'GxTuner', '
...

', 'http://guitarix.sourceforge.net/plugins/gxtuner#tuner', 12, 1),
           (195, 'GxTubeVibrato', '
Attempt at a true vibrato
And it works well!
Sounds very sweet with tubes wrapped

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxtubevibrato#tubevibrato', 12, 1),
           (196, 'GxTubeTremelo', '
Model of a vactrol tremolo unit by "transmogrify"
c.f. http://sourceforge.net/apps/phpbb/guitarix/viewtopic.php?f=7&t=44&p=233&hilit=transmogrifox#p233
http://transmogrifox.webs.com/vactrol.m

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxtubetremelo#tubetremelo', 12, 1),
           (197, 'GxTubeDelay', '
...

', 'http://guitarix.sourceforge.net/plugins/gxtubedelay#tubedelay', 12, 1),
           (198, 'GxTubeScreamer', 'Analog distortion emulation of the classic Ibanez TS-9 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Ibanez TS-9 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxts9#ts9sim', 12, 1),
           (199, 'GxTiltTone', 'A simple Tilt Tone control (*)

(*) The Tilt control imposes a shelving function, which attenuates half of frequency band and augments the other half. In other words, it is special type of a tone control that, unlike the typical tone control that boosts or cuts just the highs or mids or lows, shifts both highs and lows at once.

*Unofficial documentation

source: http://www.tubecad.com/2013/06/blog0266.htm
', 'http://guitarix.sourceforge.net/plugins/gxtilttone#tilttone', 12, 1),
           (200, 'GxMetalHead', '
...

', 'http://guitarix.sourceforge.net/plugins/gxmetal_head#metal_head', 12, 1),
           (201, 'GxMetalAmp', '
...

', 'http://guitarix.sourceforge.net/plugins/gxmetal_amp#metal_amp', 12, 1),
           (202, 'GxEchoCat', '
A tape delay simulation plugin.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxechocat#echocat', 12, 1),
           (203, 'GxBooster', '
A 2 band boost plugin. With this plugin you can boost the high and the low frequencies independently.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gxbooster#booster', 12, 1),
           (204, 'GxAutoWah', '
Analog wah emulation of the classic Dunlop Crybaby (*), in a auto-wah version.

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Crybaby is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gxautowah#autowah', 12, 1),
           (205, 'GxZita_rev1-Stereo', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_zita_rev1_stereo#_zita_rev1_stereo', 12, 1),
           (206, 'GxTremolo', '
Model of a vactrol tremolo unit by "transmogrify"
** c.f. http://sourceforge.net/apps/phpbb/guitarix/viewtopic.php?f=7&t=44&p=233&hilit=transmogrifox#p233
** http://transmogrifox.webs.com/vactrol.m

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_tremolo#_tremolo', 12, 1),
           (207, 'Gxswitched_tremolo', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_switched_tremolo_#_switched_tremolo_', 12, 1),
           (208, 'GxSustainer', 'Combine with the GxMuff to get an Electro-Harmonix Big Muff Pi sound (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Big Muff Pi is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_susta_#_susta_', 12, 1),
           (209, 'Gx Studio Preamp Stereo', 'Based on the simple Alembic F-2B studio preamp (*)
2 sections of 12AX7 together with tonestack and volume
This is an identical circuit apart from coupling caps which you could do with filters

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Alembic F-2B is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_studiopre_st#studiopre_st', 12, 1),
           (210, 'GxAlembic', 'Based on the simple Alembic F-2B studio preamp (*)
2 sections of 12AX7 together with tonestack and volume
This is an identical circuit apart from coupling caps which you could do with filters

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Alembic F-2B is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_studiopre#studiopre', 12, 1),
           (211, 'Gxshimmizita', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_shimmizita_#_shimmizita_', 12, 1),
           (212, 'GxScreamingBird', 'Emulation of the Electro-Harmonix Screaming Bird treble booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Screaming Bird is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_scream_#_scream_', 12, 1),
           (213, 'Gxroom_simulator', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_room_simulator_#_room_simulator_', 12, 1),
           (214, 'GxReverb-Stereo', '
"A Reverb simulates the component of sound that results from reflections from surrounding walls or objects. It is in effect a room simulator. Some people think it''s just a delay effect with some filters, but it''s way more complex than that."

*Unofficial documentation

source: http://audacity.sourceforge.net/manual-1.2/effects_reverb.html

', 'http://guitarix.sourceforge.net/plugins/gx_reverb_stereo#_reverb_stereo', 12, 1),
           (215, 'GxRedeye Vibro Chump', '
A Fuzz, with a vibrato option.

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#vibrochump', 12, 1),
           (216, 'GxRedeye Chump', '
A very complete fuzz

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#chump', 12, 1),
           (217, 'GxRedeye Big Chump', '
More then the normal redeye fuzz

', 'http://guitarix.sourceforge.net/plugins/gx_redeye#bigchump', 12, 1),
           (218, 'GxRangemaster', 'Emulation of the Dallas Rangemaster treble booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dallas Rangemaster is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_rangem_#_rangem_', 12, 1),
           (219, 'GxPhaser', '
"A phaser is an electronic sound processor used to filter a signal by creating a series of peaks and troughs in the frequency spectrum. The position of the peaks and troughs is typically modulated so that they vary over time, creating a sweeping effect. For this purpose, phasers usually include a low-frequency oscillator." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Phaser_%28effect%29

', 'http://guitarix.sourceforge.net/plugins/gx_phaser#_phaser', 12, 1),
           (220, 'GxOC-2', '
A plugin that drops the original sound 1 and 2 octaves down to create an
extra fat sound

Partial emulation of the classic Boss OC-2 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Boss OC-2 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_oc_2_#_oc_2_', 12, 1),
           (221, 'GxMuff', 'Analog distortion emulation of the Electro-Harmonix Muff (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Muff is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_muff_#_muff_', 12, 1),
           (222, 'GxMole', 'Emulation of the Electro-Harmonix Mole bass booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Mole is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mole_#_mole_', 12, 1),
           (223, 'GxMultiBandReverb', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_mbreverb_#_mbreverb_', 12, 1),
           (224, 'GxMultiBandEcho', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_mbecho_#_mbecho_', 12, 1),
           (225, 'GxMultiBandDistortion', 'A distortion that makes it possible to distort every frequency band individually, with crossovers

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mbdistortion_#_mbdistortion_', 12, 1),
           (226, 'GxMultiBandDelay', 'A delay that makes it possible to delay every frequency band individually, with crossovers

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_mbdelay_#_mbdelay_', 12, 1),
           (227, 'GxMultiBandCompressor', '
"Multiband (also spelled multi-band) compressors can act differently on different frequency bands. The advantage of multiband compression over full-bandwidth (full-band, or single-band) compression is that unneeded audible gain changes or "pumping" in other frequency bands is not caused by changing signal levels in a single frequency band." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Dynamic_range_compression#Multiband_compression

', 'http://guitarix.sourceforge.net/plugins/gx_mbcompressor_#_mbcompressor_', 12, 1),
           (228, 'Gxlivelooper', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_livelooper_#_livelooper_', 12, 1),
           (229, 'GxJCM800pre ST', 'Emulation of the classic Marshall JCM800 preamp (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Marshall JCM 800 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_jcm800pre_st#_jcm800pre_st', 12, 1),
           (230, 'GxJCM800pre', 'Emulation of the classic Marshall JCM800 preamp (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Marshall JCM 800 is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://guitarix.sourceforge.net/plugins/gx_jcm800pre_#_jcm800pre_', 12, 1),
           (231, 'GxHornet', 'Analog distortion emulation of the Dunlop Fuzz Face-based Hornet (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_hornet_#_hornet_', 12, 1),
           (232, 'GxHogsFoot', 'Emulation of the Electro-Harmonix Hog''s Foot bass booster (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro-Harmonix Hog''s Foot is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_hogsfoot_#_hogsfoot_', 12, 1),
           (233, 'GxHighFrequencyBrightener', 'A High Frequency Brightener

', 'http://guitarix.sourceforge.net/plugins/gx_hfb_#_hfb_', 12, 1),
           (234, 'GxGraphicEQ', '
"In the graphic equalizer, the input signal is sent to a bank of filters. Each filter passes the portion of the signal present in its own frequency range or band. The amplitude passed by each filter is adjusted using a slide control to boost or cut frequency components passed by that filter. The vertical position of each slider thus indicates the gain applied at that frequency band, so that the knobs resemble a graph of the equalizer''s response plotted versus frequency." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Equalization_%28audio%29#Graphic_equalizer

', 'http://guitarix.sourceforge.net/plugins/gx_graphiceq_#_graphiceq_', 12, 1),
           (235, 'GxCrybabyGCB95', 'Analog wah emulation of the classic Dunlop GCB95 Crybaby (*), in a auto-wah version.

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop GCB95 Crybaby is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_gcb_95_#_gcb_95_', 12, 1),
           (236, 'GxFuzzFaceFullerMod', 'Analog distortion emulation of the classic Dunlop Fuzz Face (Fuller Mods) (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fuzzfacefm_#_fuzzfacefm_', 12, 1),
           (237, 'GxFuzzFaceJH-2', 'Analog distortion emulation of the classic Dunlop Fuzz Face JH-2 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Dunlop Fuzz Face is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fuzzface_#_fuzzface_', 12, 1),
           (238, 'GxFuzz', 'A fuzz effect with lots of volume

*Unofficial documentation
', 'http://guitarix.sourceforge.net/plugins/gx_fuzz_#fuzz_', 12, 1),
           (239, 'GxFuzzMaster', 'Analog distortion emulation of the Vintage Fuzz Master (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Vintage Fuzz Master is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_fumaster_#_fumaster_', 12, 1),
           (240, 'GxFlanger', '
"Flanging /ˈflændʒɪŋ/ is an audio effect produced by mixing two identical signals together, one signal delayed by a small and gradually changing period, usually smaller than 20 milliseconds. This produces a swept comb filter effect: peaks and notches are produced in the resulting frequency spectrum, related to each other in a linear harmonic series. Varying the time delay causes these to sweep up and down the frequency spectrum. A flanger is an effects unit that creates this effect.

Part of the output signal is usually fed back to the input (a "re-circulating delay line"), producing a resonance effect which further enhances the intensity of the peaks and troughs. The phase of the fed-back signal is sometimes inverted, producing another variation on the flanging sound." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Flanging

', 'http://guitarix.sourceforge.net/plugins/gx_flanger#_flanger', 12, 1),
           (241, 'GxExpander', '
"The expander is a compressor in reverse. There are two types of expander. In some, signals above the threshold remain at unity gain whereas signals below the threshold are reduced in gain, whereas in others the signal above the threshold also has the gain increased. Therefore you can use an expander as a noise reduction unit. Set the threshold to be just below the level of the player when playing. When the player stops the signal will fall below this threshold and the signal is reduced in gain thus reducing the noise or spill."

*Unofficial documentation

source: http://www.sae.edu/reference_material/audio/pages/Compression.htm

', 'http://guitarix.sourceforge.net/plugins/gx_expander#_expander', 12, 1),
           (242, 'GxEcho-Stereo', '
A stereo echo plugin with independent delay time and delay volume for each channel. It also has a LFO modulator and two modes: linear and pingpong.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_echo_stereo#_echo_stereo', 12, 1),
           (243, 'Gxduck_delay_st', '
The delayed signal added to output dependent of input signal amplitude. 
If the input signal is high. The delayed signall turned off, and vise versa.
The switching controlled by envelope follower

', 'http://guitarix.sourceforge.net/plugins/gx_duck_delay_st_#_duck_delay_st_', 12, 1),
           (244, 'Gxduck_delay', '
The delayed signal added to output dependent of input signal amplitude. 
If the input signal is high. The delayed signall turned off, and vise versa.
The switching controlled by envelope follower

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_duck_delay_#_duck_delay_', 12, 1),
           (245, 'Gxdigital_delay_st', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_digital_delay_st_#_digital_delay_st_', 12, 1),
           (246, 'Gxdigital_delay', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_digital_delay_#_digital_delay_', 12, 1),
           (247, 'Gxdetune', 'A detuner with an octave option

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_detune_#_detune_', 12, 1),
           (248, 'GxDelay-Stereo', '
A stereo delay plugin with independent delay time and delay gain for each channel. It also has a LFO modulator and two modes: linear and pingpong.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_delay_stereo#_delay_stereo', 12, 1),
           (249, 'GxColorSoundTonebender', 'Analog distortion emulation of the classic Colorsound Tonebender (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Colorsound Tonebender is a trademark or trade name of another manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_cstb_#_cstb_', 12, 1),
           (250, 'GxCompressor', '
"Compression (or more technically Dynamic range compression) is a subtle effect primarily for electric guitar where the highest and lowest points of the sound wave are "limited". This boosts the volume of softer picked notes, while capping the louder ones, giving a more even level of volume. This is frequently used in country music, where fast clean passages can sound uneven unless artificially ''squashed''." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Compression_%28electric_guitar%29

', 'http://guitarix.sourceforge.net/plugins/gx_compressor#_compressor', 12, 1),
           (251, 'GxWahwah', '
...

', 'http://guitarix.sourceforge.net/plugins/gx_colwah_#_colwah_', 12, 1),
           (252, 'GxChorus-Stereo', '
"In music, a chorus effect (sometimes chorusing or chorused effect) occurs when individual sounds with roughly the same timbre and nearly (but never exactly) the same pitch converge and are perceived as one. While similar sounds coming from multiple sources can occur naturally (as in the case of a choir or string orchestra), it can also be simulated using an electronic effects unit or signal processing device." Wikipedia

*Unofficial documentation

source: http://en.wikipedia.org/wiki/Chorus_effect

', 'http://guitarix.sourceforge.net/plugins/gx_chorus_stereo#_chorus_stereo', 12, 1),
           (253, 'GxCabinet', '
', 'http://guitarix.sourceforge.net/plugins/gx_cabinet#CABINET', 12, 1),
           (254, 'GxBarkGraphicEQ', '
A Graphic Equalizer with Bark frequency scale.

*Unofficial documentation

', 'http://guitarix.sourceforge.net/plugins/gx_barkgraphiceq_#_barkgraphiceq_', 12, 1),
           (255, 'GxAmplifier Stereo', 'Stereo version of gx_amp.

This plugin is the combination of guitarix''s head, tonestack and cabinet, which, in that order, composes the signal path. In the tube-amp part, "PreGain" corresponds to the gain used at the amp input, "Drive" controls the power amp gain, "Distortion" is a blend between clean and distorted sound (lower boundary is all clean, upper boundary all distorted) and "MasterGain" controls the output gain. Mainly, the responsible for the signal distortion are "PreGain" and "Drive" parameters. Besides that, there is a list of possible valve combinations so you can vary your distortion.

At the Tonestack part, we find a basic equalization set ("Bass", "Middle", "Treble" and "Presence") and a list of tone-responses from a few well-known amps, you can check this list in the link at the end of this description (there might be some version differences).

Finally, at the Cabinet path, we have "Cabinet", which corresponds to another output gain, it doesn''t distort the signal so it can be used as a Master output and there''s another list, containing a virtual sound of the cabinet of speakers selected (more details in the link below).

Based on:
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=EnhancedUI
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Tonestack
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Cabinet_Impulse_Response_convolution
', 'http://guitarix.sourceforge.net/plugins/gx_amp_stereo#GUITARIX_ST', 12, 1),
           (256, 'GxAmplifier-X', 'This plugin is the combination of guitarix''s head, tonestack and cabinet, which, in that order, composes the signal path. In the tube-amp part, "PreGain" corresponds to the gain used at the amp input, "Drive" controls the power amp gain, "Distortion" is a blend between clean and distorted sound (lower boundary is all clean, upper boundary all distorted) and "MasterGain" controls the output gain. Mainly, the responsible for the signal distortion are "PreGain" and "Drive" parameters. Besides that, there is a list of possible valve combinations so you can vary your distortion.

At the Tonestack part, we find a basic equalization set ("Bass", "Middle", "Treble" and "Presence") and a list of tone-responses from a few well-known amps, you can check this list in the link at the end of this description (there might be some version differences).

Finally, at the Cabinet path, we have "Cabinet", which corresponds to another output gain, it doesn''t distort the signal so it can be used as a Master output and there''s another list, containing a virtual sound of the cabinet of speakers selected (more details in the link below).

Based on:
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=EnhancedUI
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Tonestack
https://sourceforge.net/apps/mediawiki/guitarix/index.php?title=Cabinet_Impulse_Response_convolution
', 'http://guitarix.sourceforge.net/plugins/gx_amp#GUITARIX', 12, 1),
           (257, 'Granulator', 'A realtime granulator plays small chunks of audio in the delay time setted', 'http://faust-lv2.googlecode.com/Granulator', 13, 1),
           (258, 'Prefreak', 'A blurry pre-delay; can be used in combination with Prefreak to complete the reverb', 'http://faust-lv2.googlecode.com/Prefreak', 14, 1),
           (259, 'Freaktail', 'The tail of a Reverb, can be used in combination with Prefreak to complete the reverb', 'http://faust-lv2.googlecode.com/Freaktail', 14, 1),
           (260, 'Freakclip', 'Clipped Filter', 'http://faust-lv2.googlecode.com/Freakclip', 14, 1),
           (261, 'Triple chorus', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The same as CS Chorus 2, but has three separate outputs.  Plan L,C,R for a nice stereo effect.', 'http://drobilla.net/plugins/fomp/triple_chorus', 15, 1),
           (262, 'reverb', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	This is a stereo reverb plugin based on the well-known greverb.', 'http://drobilla.net/plugins/fomp/reverb', 15, 1),
           (263, 'CS Phaser 1 with LFO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	Similar to CS Phaser 1, but the external modulation has been replaced by a built-in LFO.', 'http://drobilla.net/plugins/fomp/cs_phaser1_lfo', 15, 1),
           (264, 'CS Chorus 2', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 
	Functionally identical to variant 1, but upsamples the input to the delay lines in an attempt to mitigate the errors produced by the linear interpolation at the output.', 'http://drobilla.net/plugins/fomp/cs_chorus2', 15, 1),
           (265, 'CS Chorus 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 
	Based on a CSound orchestra file by Sean Costello. There are two low frequency oscillators, each having three outputs that are 120 degrees apart in phase. The summed outputs modulate three delay lines. Make sure the static delay (first parameter) is at least equal to the sum of the two modulation depths.', 'http://drobilla.net/plugins/fomp/cs_chorus1', 15, 1),
           (266, 'Auto-wah', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The auto-wah, is basically a combination of an envelope follower and a resonant lowpass filter. For increasing level both the frequency and the bandwidth of the filter will increase. How much is controlled by ''Drive''. For a normal wah, use a pedal to control ''Frequency'' and set ''Drive'' to zero.', 'http://drobilla.net/plugins/fomp/autowah', 15, 1),
           (267, 'Saw VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. The ''edge'' for this saw variant (1/F amplitude spectrum) is made by integrating the anti-aliased pulse. Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments. Tests by Matthias Nagorni revealed the output sounded quite ''harsh'' when compared to his analogue instruments. Comparing the spectra, it became clear that a mathematically ''exact'' spectrum was not desirable from a musical point of view. For this reason, a built-in lowpass filter was added. The default setting (0.5) will yield output identical to that of the Moog Voyager.', 'http://drobilla.net/plugins/fomp/saw_vco', 15, 1),
           (268, 'reverb-amb', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	This is a stereo reverb plugin based on the well-known greverb.', 'http://drobilla.net/plugins/fomp/reverb_amb', 15, 1),
           (269, 'Rec VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. The ''edge'' for this rectangular variant is made by integrating the anti-aliased pulse. Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments. Tests by Matthias Nagorni revealed the output sounded quite ''harsh'' when compared to his analogue instruments. Comparing the spectra, it became clear that a mathematically ''exact'' spectrum was not desirable from a musical point of view. For this reason, a built-in lowpass filter was added. The default setting (0.5) will yield output identical to that of the Moog Voyager.', 'http://drobilla.net/plugins/fomp/rec_vco', 15, 1),
           (270, 'Pulse VCO', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the principle of using a precomputed interpolated dirac pulse. This is the pulse variant (flat amplitude spectrum). Aliases should be below -80dB for fundamental frequencies below the sample rate / 6 (i.e. up to 8 kHz at Fsamp = 48 kHz). This frequency range includes the fundamental frequencies of all known musical instruments.', 'http://drobilla.net/plugins/fomp/pulse_vco', 15, 1),
           (271, '4-Band Parametric Filter', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen.
	There''s one plugin in this first release, a four-band parametric equaliser. Each section has an active/bypass switch, frequency, bandwidth and gain controls. There is also a global bypass switch and gain control. The 2nd order resonant filters are implemented using a Mitra-Regalia style lattice filter, which has the nice property of being stable even while parameters are being changed. All switches and controls are internally smoothed, so they can be used ''live'' whithout any clicks or zipper noises. This should make this plugin a good candidate for use in systems that allow automation of plugin control ports, such as Ardour, or for stage use.', 'http://drobilla.net/plugins/fomp/parametric1', 15, 1),
           (272, 'Moog Low-Pass Filter 4', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	The same as variant 3, but adds a selection of 0, 6, 12, 18 or 24 db/oct output.', 'http://drobilla.net/plugins/fomp/mvclpf4', 15, 1),
           (273, 'Moog Low-Pass Filter 3', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on variant 2, with two differences. It uses the the technique described by Stilson and Smith to extend the constant-Q range, and the internal sample frequency is doubled, giving a better approximation to the non-linear behaviour at high freqencies. This variant has high Q over the entire frequency range and will oscillate up to above 10 kHz, while the two others show a decreasing Q at high frequencies. This filter is reasonably well tuned, and can be ''played'' as a VCO up to at least 5 kHz.', 'http://drobilla.net/plugins/fomp/mvclpf3', 15, 1),
           (274, 'Moog Low-Pass Filter 2', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Uses five non-linear elements, in the input and in all four filter sections. It works by using the derivative of the nonlinearity (for which 1 / (1 + x * x) is reasonable approximation). The main advantage of this is that only one evaluation of the non-linear function is required for each section. The four variables that contain the filter state (c1...c4) represent not the voltage on the capacitors (as in the first filter) but the current flowing in the resistive part.', 'http://drobilla.net/plugins/fomp/mvclpf2', 15, 1),
           (275, 'Moog Low-Pass Filter 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	A fairly simple design which does not even pretend to come close the ''real thing''. It uses a very crude approximation of the non-linear resistor in the first filter section only. Retained in this distribution because it''s a cheap (in terms of CPU usage) general purpose 24 dB/oct lowpass filter that could be useful.', 'http://drobilla.net/plugins/fomp/mvclpf1', 15, 1),
           (276, 'Moog High-Pass Filter 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	Based on the voltage controlled highpass filter by Robert Moog, with some attention to the nonlinear effects.  This is quite different from the lowpass filters.  When you ''overdrive'' the filter, the cutoff frequency will rise.  This first version is really very experimental.', 'http://drobilla.net/plugins/fomp/mvchpf1', 15, 1),
           (277, 'CS Phaser 1', 'Fomp is an LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen. 	
	This is similar to the CSound module ''phaser1''. It''s a series connection of 1 to 30 first order allpass filters with feedback. For ''Output mix'', the range -1 to 0 crossfades between the inverted output and the input, and the range 0 to 1 crossfades between the input and the non-inverted output. Without feedback, the maximum effect is at +/- 0.5. For both ''Feedback gain'' and ''Output mix'', the best polarity depends on whether the number of sections is even or odd.', 'http://drobilla.net/plugins/fomp/cs_phaser1', 15, 1),
           (278, 'Fluid SynthPads', 'This plugin contains the ''Synth Pads'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthPads', 16, 1),
           (279, 'Fluid SynthLeads', 'This plugin contains the ''Synth Leads'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthLeads', 16, 1),
           (280, 'Fluid SynthFX', 'This plugin contains the ''Synth FX'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSynthFX', 16, 1),
           (281, 'Fluid Strings', 'This plugin contains the ''Strings'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidStrings', 16, 1),
           (282, 'Fluid SoundFX', 'This plugin contains the ''Sound FX'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidSoundFX', 16, 1),
           (283, 'Fluid Reeds', 'This plugin contains the ''Reed'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidReeds', 16, 1),
           (284, 'Fluid Pipes', 'This plugin contains the ''Pipe'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPipes', 16, 1),
           (285, 'Fluid Pianos', 'This plugin contains the ''Piano'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPianos', 16, 1),
           (286, 'Fluid Percussion', 'This plugin contains the ''Percussion'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidPercussion', 16, 1),
           (287, 'Fluid Organs', 'This plugin contains the ''Organ'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidOrgans', 16, 1),
           (288, 'Fluid Guitars', 'This plugin contains the ''Guitar'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidGuitars', 16, 1),
           (289, 'Fluid Ethnic', 'This plugin contains the ''Ethnic'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidEthnic', 16, 1),
           (290, 'Fluid Ensemble', 'This plugin contains the ''Ensemble'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidEnsemble', 16, 1),
           (291, 'Fluid Drums', 'This plugin contains the ''Drums'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidDrums', 16, 1),
           (292, 'Fluid Chromatic Percussion', 'This plugin contains the ''Chromatic Percussion'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidChromPerc', 16, 1),
           (293, 'Fluid Brass', 'This plugin contains the ''Brass'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidBrass', 16, 1),
           (294, 'Fluid Bass', 'This plugin contains the ''Bass'' section of the Fluid GM soundfont.The Fluid GM soundfont was constructed in part from edited/cleaned/remixed/programmed samples found in the public domain and recordings made by Frank Wen.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_FluidBass', 16, 1),
           (295, 'AirFont320', 'AirFont 320 made in 2005 by Milton Paredes.', 'http://kxstudio.linuxaudio.org/plugins/FluidPlug_AirFont320', 17, 1),
           (296, 'Fabla 2.0', '', 'http://www.openavproductions.com/fabla2', 18, 1),
           (297, 'Soul Force', 'A fairly standard waveshaping distortion plugin, made more interesting through the use of feedback to control the shaping.
Can get pretty loud and obnoxious.
', 'http://www.niallmoody.com/ndcplugs/soulforce.htm', 19, 1),
           (298, 'Ping Pong Pan', 'Ping Pong Panning.
', 'http://distrho.sf.net/plugins/PingPongPan', 19, 1),
           (299, 'Nekobi', 'Simple single-oscillator synth based on the Roland TB-303.
', 'http://distrho.sf.net/plugins/Nekobi', 19, 1),
           (300, 'MVerb', 'Studio quality reverb, provides a practical demonstration of Dattorro’s figure-of-eight reverb structure.
', 'http://distrho.sf.net/plugins/MVerb', 19, 1),
           (301, 'MaPitchshift', 'Max Gen Pitchshifter example.
', 'http://distrho.sf.net/plugins/MaPitchshift', 19, 1),
           (302, 'MaGigaverb', 'Max Gen Gigaverb example.
', 'http://distrho.sf.net/plugins/MaGigaverb', 19, 1),
           (303, 'MaFreeverb', 'Max Gen Freeverb example.
', 'http://distrho.sf.net/plugins/MaFreeverb', 19, 1),
           (304, 'MaBitcrush', 'Max Gen Bitcrush example.
', 'http://distrho.sf.net/plugins/MaBitcrush', 19, 1),
           (305, 'Kars', 'Simple karplus-strong plucked string synth.
', 'http://distrho.sf.net/plugins/Kars', 19, 1),
           (306, 'Cycle Shifter', 'Reads in a cycle''s-worth of the input signal, then (once the whole cycle''s been read in) outputs it again, on top of the current output.
Works best with long/sustained sounds (e.g. strings, pads etc.), sounds like a weird kind of gentle distortion.
', 'http://www.niallmoody.com/ndcplugs/cycleshifter.htm', 19, 1),
           (307, 'Amplitude Imposer', 'Takes 2 stereo inputs and imposes the amplitude envelope of the first one on the second one.
Also has a threshold level for the second input, so that when the signal falls below it, it is amplified up to the threshold, to give a greater signal to be amplitude modulated.
', 'http://www.niallmoody.com/ndcplugs/ampimposer.htm', 19, 1),
           (308, '3 Band Splitter', '3 Band Equalizer, splitted output version.
', 'http://distrho.sf.net/plugins/3BandSplitter', 19, 1),
           (309, '3 Band EQ', '3 Band Equalizer, stereo version.
', 'http://distrho.sf.net/plugins/3BandEQ', 19, 1),
           (310, 'C* Wider - Stereo image Synthesis', 'In addition to provoding a basic panorama control, a perception of stereo width is created using complementary filters on the two output channels.

The output channels always sum to a flat frequency response.

The design of this plugin owes to the Orban 245F Stereo Synthesizer.

source: http://quitte.de/dsp/caps.html#Wider
', 'http://moddevices.com/plugins/caps/Wider', 20, 1),
           (311, 'C* White - White noise generator', 'Mostly white pseudonoise, mixed and filtered from the output of two Dattorro multibit generators.

source: http://quitte.de/dsp/caps.html#White
', 'http://moddevices.com/plugins/caps/White', 20, 1),
           (312, 'C* ToneStack - Tone stack emulation', 'This emulation of the tone stack of a traditional Fender-design instrument amplifier has been devised and implemented by David T. Yeh, with subsequent expansion to include more models by Tim Goetze.

Due to the nature of the original circuit, the bass, mid and treble controls are not operating independently as in a modern three-way equaliser.

All but the last model are using the procedural implementation with continuously updated direct form II filters and sample rate independency.  It must be noted that the "DC 30" preset has been included despite the slight difference in topology between the British original and the Fender circuit.

The "5F6-A LT" model is using the lattice filter implementation mentioned in [yeh06], operating on precomputed simulation data for 44.1 kHz.

source: http://quitte.de/dsp/caps.html#ToneStack
', 'http://moddevices.com/plugins/caps/ToneStack', 20, 1),
           (313, 'C* SpiceX2', 'Stereo version of Spice. Bass compression is governed by the sum of both channels, as in CompressX2. Nevertheless, the amount of harmonic generation differing between the two channels can have subtle effects on the stereo image.

source: http://quitte.de/dsp/caps.html#Spice
', 'http://moddevices.com/plugins/caps/SpiceX2', 20, 1),
           (314, 'C* Spice', 'This effect plugin is useful when more bass register definition or more treble presence is called for and generic equalisation does not work without noticeably raising the signal or noise level. A common application is refreshing of material that has been subjected to low-quality analog transmission.

Bass and treble portions of the signal are isolated using two 24 dB/octave Linkwitz-Riley crossover networks[lr76] to ensure a flat frequency response at zero effect intensity (controlled through the .gain settings). After compression, a polynomial waveshaper synthesises the first three overtones of the bass register. This enhances the perception of the fundamental frequency, being the difference tone of these harmonics. Treble band processing applies analog-style saturation with only simplistic antialiasing. Synthesised harmonic content is shaped through bandpass and highpass filters and mixed back into the crossover sum signal.

A stereo version is available as SpiceX2.

source: http://quitte.de/dsp/caps.html#Spice
', 'http://moddevices.com/plugins/caps/Spice', 20, 1),
           (315, 'C* Sin - Sine wave generator', 'The old friend, indispensable for testing and tuning.

source: http://quitte.de/dsp/caps.html#Sin
', 'http://moddevices.com/plugins/caps/Sin', 20, 1),
           (316, 'C* Scape - Stereo delay + Filters', 'A stereo delay with resonant filters and fractally modulated panning.

The delay times are set through the bpm control and the divider adjustment. Triplet and sixteenth settings create a dotted rhythm. With every beat, the filter resonance frequencies are retuned to random steps on an equal-tempered chromatic scale, to the reference set through the tune control.

source: http://quitte.de/dsp/caps.html#Scape
', 'http://moddevices.com/plugins/caps/Scape', 20, 1),
           (317, 'C* Saturate', 'Please note that this plugin embodies a very basic building block of audio DSP, not an elaborate effect that will be pleasing to hear right away. To turn saturation into a musically useful effect it is usually combined with some sort of filtering and dynamics modulation.

The mode control chooses from a selection of clipping functions of varying character. Even-order harmonics can be added with the bias setting. Towards the maximum, sound will start to get scratchy and eventually starve away.

The plugin is 8x oversampled with 64-tap polyphase filters, effectively suppressing aliasing noise for most musical applications. Changes to the bias control induce short-lived energy at DC in the output. In order to reduce the computational load incurred when evaluating transcendental functions at eight times the nominal sample rate, these are approximated roughly, using Chebyshev polynomials whose coefficients depend on the amplitude''s floating point representation exponent.

source: http://quitte.de/dsp/caps.html#Saturate
', 'http://moddevices.com/plugins/caps/Saturate', 20, 1),
           (318, 'C* PlateX2 - Stereo in/out Versatile plate reverb', 'This version of the Plate reverberator comes with stereo inputs.

source: http://quitte.de/dsp/caps.html#Plate
', 'http://moddevices.com/plugins/caps/PlateX2', 20, 1),
           (319, 'C* Plate - Versatile plate reverb', 'This reverb processor is an adaptation of the design discussed in [dat97a]. Tuned for a soft attack and smooth ambience, it consists of a network of twelve delay lines of varying length. At its heart, two of these are modulated very subtly, in a chorus-like fashion.

The bandwidth control reduces high-frequency content before it enters the ''tank'', while damping controls how quickly the reverberating tail darkens.

source: http://quitte.de/dsp/caps.html#Plate
', 'http://moddevices.com/plugins/caps/Plate', 20, 1),
           (320, 'C* PhaserII - Mono phaser modulated by a Lorenz fractal', 'This take on the classic effect features two modulation choices, traditional sine-based periodicity or smoothened fractal oscillation.

Very high resonance settings can cause self-oscillation peaking in excess of 0 dB.

source: http://quitte.de/dsp/caps.html#PhaserII
', 'http://moddevices.com/plugins/caps/PhaserII', 20, 1),
           (321, 'C* Noisegate - Attenuate noise resident in silence', 'This plugin aims to reduce undesirable background noise and hum in otherwise silent passages.

When the signal''s instantaneous amplitude exceeds the opening threshold, the gate is opened. The time it takes until the gate is fully open can be set with the attack control. As soon as the signal''s RMS power level drops below the closing threshold, the gate closes. This takes a fixed time of 20 ms; closed gate attenuation is 60 dB.

To cope with powerline hum as often present in signals from electric guitars, a notch filter can be activated by setting the mains frequency control to a non-zero value.  The filter will prevent this frequency from contributing to the signal power measurement. This allows a low closing threshold setting without mains hum keeping the gate open unduly.  The default mains setting is 50 Hz.

source: http://quitte.de/dsp/caps.html#Noisegate
', 'http://moddevices.com/plugins/caps/Noisegate', 20, 1),
           (322, 'C* Narrower - Stereo image width reduction', 'This plugin reduces the width of a stereophonic signal. Its primary use is for preventing fatigue from listening to ''creatively panned'' music on headphones.

Mid/side processing tends to sound more transparent for moderate strength settings.  However, it will more strongly attenuate signals that are panned to the far sides of the stereo image (rarely encountered in contemporary music production anymore but quite common, for example, on early Beatles recordings or others from that time).

source: http://quitte.de/dsp/caps.html#Narrower
', 'http://moddevices.com/plugins/caps/Narrower', 20, 1),
           (323, 'C* Fractal - Audio stream from deterministic chaos', 'This plugin turns the oscillating state of a fractal attractor into an audio stream. The result is something that most would without much hesitation classify as noise.

The Lorenz attractor is one of the earliest models of deterministic chaos discovered deriving from the Navier-Stokes equationswp.

The Rössler system is similar but contains only one non-linearity.

The x, y and z controls set the amplitude of the respective variables of the attractor state in the output audio signal.

The attractor state variables are scaled and translated to stay mostly within the [-1,1] range and not contain a DC offset. Nevertheless, due to the unpredictable nature of the systems, peak limits cannot be guaranteed.  In addition, some energy near DC may be produced; therefore a configurable high-pass filter is part of the circuit. It can be turned off by setting the hp parameter to zero.

The output signal varies with the sample rate.

source: http://quitte.de/dsp/caps.html#Fractals
', 'http://moddevices.com/plugins/caps/Fractal', 20, 1),
           (324, 'C* EqFA4p - 4-band parametric shelving equalizer', 'Four Mitra-Regalia peaking equaliser filters in series; a vector arithmetic re-implementation of Fons Adriaensens "Parametric1" equaliser with minor differences.

source: http://quitte.de/dsp/caps.html#EqFA4p
', 'http://moddevices.com/plugins/caps/EqFA4p', 20, 1),
           (325, 'C* Eq4p - 4-band parametric equaliser', 'Four adjustable biquad filters in series, in a vector arithmetic implementation. The default setup is an identity filter with a mode configuration of lowshelve, band, band, hishelve, all at zero gain.

The Q control value maps non-linearly to actual filter Q: a zero control value results in filter Q of ½, a value of 0.3 corresponds to a Butterworth-equivalent Q of ½√2, and the maximum control setting of 1 results in a filter Q of 50.

Parallelisation of the serial filter topology causes its response to lag by three samples.

Control response is smoothened by crossfading between two filter banks.

source: http://quitte.de/dsp/caps.html#Eq4p
', 'http://moddevices.com/plugins/caps/Eq4p', 20, 1),
           (326, 'C* Eq10X2 - 10-band equalizer', 'The controls of this stereo version of Eq apply to both channels.

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://moddevices.com/plugins/caps/Eq10X2', 20, 1),
           (327, 'C* Eq10 - 10-band equalizer', 'A classic octave-band biquad-filter design, basically a direct digital translation of the analog original. There''s also a stereo version (Eq10X2).

Frequency bands centered above Nyquist are automatically disabled.

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://moddevices.com/plugins/caps/Eq10', 20, 1),
           (328, 'C* CompressX2 - Stereo compressor', 'This stereo version of Compress applies uniform compression to both channels in proportion to their combined power.

source: http://quitte.de/dsp/caps.html#Compress
', 'http://moddevices.com/plugins/caps/CompressX2', 20, 1),
           (329, 'C* Compress - Mono compressor', 'This compressor has been designed primarily to create natural-sounding sustain for the electric guitar without sacrificing its brightly percussive character. However, it appears to apply well to a variety of other sound sources, and with CompressX2 a stereo version is available as well.

To be able produce strong compression and still maintain a natural sound, the design catches (attack-phase) power spikes with a soft saturation circuit, converting them into additional harmonic content and enforcing a strict limit on the output level. Saturating operation is the default setting of the mode control. Three anti-aliasing options are available, 2x oversampling with 32-tap filters and 4x with 64 and 128 taps.

The measure control select which indicator of loudness to base calculations on: peak – instantaneous amplitude – measurement allows the unit to react very quickly, while rms – root mean square power – is of a gentler kind.

Compression amount is controlled through the strength knob, from 0 effectively disabling the effect, up to a maximum ratio of 16:1. The attack and release controls map higher values to slower reactions.

source: http://quitte.de/dsp/caps.html#Compress
', 'http://moddevices.com/plugins/caps/Compress', 20, 1),
           (330, 'C* Click - Metronome', 'A sample-accurate metronome. Two simplistic modal synthesis models are available for the click: box is a small wooden box struck with a soft wooden mallet, stick a scratchy stick hit. In addition, there''s also a very synthetic beep, and finally dirac, a very nasty single-sample pulse of 0 dB amplitude and little immediate musical use.
All click sounds are synthesised once when the plugin is loaded and then played back from memory.

source: http://quitte.de/dsp/caps.html#Click
', 'http://moddevices.com/plugins/caps/Click', 20, 1),
           (331, 'C* ChorusI - Mono chorus/flanger', 'A standard mono chorus with optional feedback. The parameter range suits subtle effects as well as all-out flanging.

Modifying the delay time t when feedback is active will cause audible ''zipper'' noise.

source: http://quitte.de/dsp/caps.html#ChorusI
', 'http://moddevices.com/plugins/caps/ChorusI', 20, 1),
           (332, 'C* CEO - Chief Executive Oscillator', 'The Chief Executive Oscillator forever calls for more profit.

Sound data created with the flite[flite] application.

source: http://quitte.de/dsp/caps.html#CEO
', 'http://moddevices.com/plugins/caps/CEO', 20, 1),
           (333, 'C* CabinetIV - Idealised loudspeaker cabinet emulation', 'This plugin applies an acoustic instrument body modeling technique to recreate the timbre-shaping of an electric instrument amplifier''s speaker cabinet. Nonlinear effects occurring in physical speakers under high load are not emulated.

A selection of several hundred response shapes automatically created in the likeness of classic cabinets has been narrowed down to a handful of idealised tones.  As with AmpVTS, which provides a matching recreation of traditional guitar amplification, the design and selection process has been ruled by musicality over fidelity.

The filter banks implemented are 64 2nd order IIR and one 128-tap FIR in parallel. Their parameter presets are shared between the 44.1 and 48 kHz sample rates, the higher rate implying that timbre brightens up. Higher sample rates produce the same tones by rate conversion, up to 192 kHz.

Despite the complexity, computational load is very modest thanks to vector arithmetic if a hardware implementation is available – if not, however, the load will be easily an order of magnitude higher, and possibly found to be prohibitive on less powerful hardware.

source: http://quitte.de/dsp/caps.html#CabinetIV
', 'http://moddevices.com/plugins/caps/CabinetIV', 20, 1),
           (334, 'C* CabinetIII - Idealised loudspeaker cabinet emulation', 'A loudspeaker cabinet emulation far less demanding than the recommended CabinetIV.  Implemented as two sets of 31st-order IIR filters precomputed (using Prony''s method) for fs of 44.1 and 48 kHz.

The appropriate filter set is selected at runtime.  The alt switch allows the selection of the same fiter model for the alternative sample rate; at 48 kHz the alternative will sound slightly darker, at 44.1 slightly brighter.  At other sample rates, the plugin will not sound very much like a guitar speaker cabinet.

source: http://quitte.de/dsp/caps.html#CabinetIII
', 'http://moddevices.com/plugins/caps/CabinetIII', 20, 1),
           (335, 'C* AutoFilter', 'A versatile selection of filters of varying character in band and lowpass configuration. The cutoff frequency can be modulated by both the input signal envelope and by a fractal oscillator. The default settings provide some sort of an automatic wah effect.

The extent of filter modulation is set through the range parameter. The shape of the modulation is mixed from the attractor and the envelope according to the lfo/env balance.

Filter stage gain can be used to add inter-stage saturation. To prevent this from causing audible aliasing, the plugin can be run in oversampled mode, at ratios selectable through the over control.

At very high Q and f combined, the filter stability may become compromised. Computational load varies greatly with the over and filter settings.

source: http://quitte.de/dsp/caps.html#AutoFilter
', 'http://moddevices.com/plugins/caps/AutoFilter', 20, 1),
           (336, 'C* AmpVTS - Tube amp + Tone stack', 'Tracing the stages of a typical tube amplifier circuit, this plugin aims to recreate those features of traditional guitar amplification electronics that have proved musically useful, and to provide them with the most musical rather than the most authentic ranges of adjustment and character.  CabinetIV provides matching recreations of loudspeaker cabinets.

The processor consists – with some interconnections – of a configurable lowcut input filter, a ToneStack circuit of the procedural variant, a saturating ''preamp'' stage with adjustable gain and variable distortion asymmetry followed by the bright filter, compression characteristics determined by the attack and squash controls and finally a ''power amp'' stage with the amount of saturation depending on both gain and power settings.

Sound quality and computational load can be balanced with the over control affording a choice of 2x or 4x oversampling with 32-tap filters, or 8x with 64 taps.  Lower quality settings will sound slightly grittier and less transparent, and at high gain aliasing may become audible.

source: http://quitte.de/dsp/caps.html#AmpVTS
', 'http://moddevices.com/plugins/caps/AmpVTS', 20, 1),
           (337, 'Calf Envelope Filter', '      The louder you play, the higher the filter
    ', 'http://calf.sourceforge.net/plugins/EnvelopeFilter', 21, 1),
           (338, 'Calf X-Over 4 Band', '', 'http://calf.sourceforge.net/plugins/XOver4Band', 21, 1),
           (339, 'Calf X-Over 3 Band', '', 'http://calf.sourceforge.net/plugins/XOver3Band', 21, 1),
           (340, 'Calf X-Over 2 Band', '', 'http://calf.sourceforge.net/plugins/XOver2Band', 21, 1),
           (341, 'Calf Vocoder', '', 'http://calf.sourceforge.net/plugins/Vocoder', 21, 1),
           (342, 'Calf Vintage Delay', '    DELAY DELay delay
    ', 'http://calf.sourceforge.net/plugins/VintageDelay', 21, 1),
           (343, 'Calf Transient Designer', '', 'http://calf.sourceforge.net/plugins/TransientDesigner', 21, 1),
           (344, 'Calf Tape Simulator', '', 'http://calf.sourceforge.net/plugins/TapeSimulator', 21, 1),
           (345, 'Calf Stereo Tools', '', 'http://calf.sourceforge.net/plugins/StereoTools', 21, 1),
           (346, 'Calf Sidechain Limiter', '', 'http://calf.sourceforge.net/plugins/SidechainLimiter', 21, 1),
           (347, 'Calf Sidechain Gate', '', 'http://calf.sourceforge.net/plugins/SidechainGate', 21, 1),
           (348, 'Calf Sidechain Compressor', '', 'http://calf.sourceforge.net/plugins/SidechainCompressor', 21, 1),
           (349, 'Calf Saturator', '', 'http://calf.sourceforge.net/plugins/Saturator', 21, 1),
           (350, 'Calf Rotary Speaker', '', 'http://calf.sourceforge.net/plugins/RotarySpeaker', 21, 1),
           (351, 'Calf Ring Modulator', '    ring ring!
    ', 'http://calf.sourceforge.net/plugins/RingModulator', 21, 1),
           (352, 'Calf Reverse Delay', '', 'http://calf.sourceforge.net/plugins/ReverseDelay', 21, 1),
           (353, 'Calf Reverb', '', 'http://calf.sourceforge.net/plugins/Reverb', 21, 1),
           (354, 'Calf Pulsator', '', 'http://calf.sourceforge.net/plugins/Pulsator', 21, 1),
           (355, 'Calf Phaser', '    Just phase it.
    ', 'http://calf.sourceforge.net/plugins/Phaser', 21, 1),
           (356, 'Calf Organ', '    Sounds like an organ, or whatever else you want.
    ', 'http://calf.sourceforge.net/plugins/Organ', 21, 1),
           (357, 'Calf Multiband Limiter', '', 'http://calf.sourceforge.net/plugins/MultibandLimiter', 21, 1),
           (358, 'Calf Multiband Gate', '', 'http://calf.sourceforge.net/plugins/MultibandGate', 21, 1),
           (359, 'Calf Multiband Compressor', '', 'http://calf.sourceforge.net/plugins/MultibandCompressor', 21, 1),
           (360, 'Calf Multi Chorus', '    Why use one chorus if you can use more?
    ', 'http://calf.sourceforge.net/plugins/MultiChorus', 21, 1),
           (361, 'Calf Monosynth', '', 'http://calf.sourceforge.net/plugins/Monosynth', 21, 1),
           (362, 'Calf Mono Input', '', 'http://calf.sourceforge.net/plugins/MonoInput', 21, 1),
           (363, 'Calf Mono Compressor', '', 'http://calf.sourceforge.net/plugins/MonoCompressor', 21, 1),
           (364, 'Calf Limiter', '    Enough, is enough.
    ', 'http://calf.sourceforge.net/plugins/Limiter', 21, 1),
           (365, 'Calf Haas Stereo Enhancer', '', 'http://calf.sourceforge.net/plugins/HaasEnhancer', 21, 1),
           (366, 'Calf Gate', '    For when you don''t want noise
    ', 'http://calf.sourceforge.net/plugins/Gate', 21, 1),
           (367, 'Calf Flanger', '    ''wieeuw'' -Flanger
    ', 'http://calf.sourceforge.net/plugins/Flanger', 21, 1),
           (368, 'Calf Filterclavier', '    Play the filter with a keyboard!
    ', 'http://calf.sourceforge.net/plugins/Filterclavier', 21, 1),
           (369, 'Calf Filter', '', 'http://calf.sourceforge.net/plugins/Filter', 21, 1),
           (370, 'Calf Exciter', '', 'http://calf.sourceforge.net/plugins/Exciter', 21, 1),
           (371, 'Calf Equalizer 8 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer8Band', 21, 1),
           (372, 'Calf Equalizer 5 Band', '    Easy to use equalizer
    ', 'http://calf.sourceforge.net/plugins/Equalizer5Band', 21, 1),
           (373, 'Calf Equalizer 30 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer30Band', 21, 1),
           (374, 'Calf Equalizer 12 Band', '', 'http://calf.sourceforge.net/plugins/Equalizer12Band', 21, 1),
           (375, 'Calf Emphasis', '', 'http://calf.sourceforge.net/plugins/Emphasis', 21, 1),
           (376, 'Calf Deesser', '', 'http://calf.sourceforge.net/plugins/Deesser', 21, 1),
           (377, 'Calf Crusher', '', 'http://calf.sourceforge.net/plugins/Crusher', 21, 1),
           (378, 'Calf Compressor', '    Compressor
    ', 'http://calf.sourceforge.net/plugins/Compressor', 21, 1),
           (379, 'Calf Compensation Delay Line', '', 'http://calf.sourceforge.net/plugins/CompensationDelay', 21, 1),
           (380, 'Calf Bass Enhancer', '', 'http://calf.sourceforge.net/plugins/BassEnhancer', 21, 1),
           (381, 'Triangle', '', 'http://drobilla.net/plugins/blop/triangle', 22, 1),
           (382, 'Square', '', 'http://drobilla.net/plugins/blop/square', 22, 1),
           (383, 'Sawtooth', '', 'http://drobilla.net/plugins/blop/sawtooth', 22, 1),
           (384, 'Tracker', '', 'http://drobilla.net/plugins/blop/tracker', 22, 1),
           (385, 'Clock Square', '', 'http://drobilla.net/plugins/blop/sync_square', 22, 1),
           (386, 'Clock Pulse', '', 'http://drobilla.net/plugins/blop/sync_pulse', 22, 1),
           (387, '64 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_64', 22, 1),
           (388, '32 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_32', 22, 1),
           (389, '16 Step Sequencer', '', 'http://drobilla.net/plugins/blop/sequencer_16', 22, 1),
           (390, 'Random Wave', '', 'http://drobilla.net/plugins/blop/random', 22, 1),
           (391, 'Quantiser (50 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_50', 22, 1),
           (392, 'Quantiser (20 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_20', 22, 1),
           (393, 'Quantiser (100 Steps)', '', 'http://drobilla.net/plugins/blop/quantiser_100', 22, 1),
           (394, 'Pulse', '', 'http://drobilla.net/plugins/blop/pulse', 22, 1),
           (395, '4 Pole Resonant Low-Pass', '', 'http://drobilla.net/plugins/blop/lp4pole', 22, 1),
           (396, 'Control to CV Interpolator', '', 'http://drobilla.net/plugins/blop/interpolator', 22, 1),
           (397, 'Retriggerable DAHDSR Envelope', '', 'http://drobilla.net/plugins/blop/dahdsr', 22, 1),
           (398, 'Amplifier', '', 'http://drobilla.net/plugins/blop/amp', 22, 1),
           (399, 'Retriggerable ADSR Envelope', '', 'http://drobilla.net/plugins/blop/adsr_gt', 22, 1),
           (400, 'ADSR Envelope', '', 'http://drobilla.net/plugins/blop/adsr', 22, 1),
           (401, 'Roomy', 'A spacious open algorithmic reverb.', 'http://www.openavproductions.com/artyfx#roomy', 18, 1),
           (402, 'Kuiza', 'A 4 band equalizer with preset bands.', 'http://www.openavproductions.com/artyfx#kuiza', 18, 1),
           (403, 'Filta', 'Highpass lowpass filter combination.', 'http://www.openavproductions.com/artyfx#filta', 18, 1),
           (404, 'Whaaa', 'A wah pedal.', 'http://www.openavproductions.com/artyfx#whaaa', 18, 1),
           (405, 'Vihda', 'A stereo widener plugin based on a mid-side matrix with inversion of the right channel.', 'http://www.openavproductions.com/artyfx#vihda', 18, 1),
           (406, 'Satma', 'A distortion maximizer effect.', 'http://www.openavproductions.com/artyfx#satma', 18, 1),
           (407, 'Panda', 'A compressor expander limiter that can squeeze the dynamics out of any signal.', 'http://www.openavproductions.com/artyfx#panda', 18, 1),
           (408, 'Masha', 'A beat-stutter type effect.', 'http://www.openavproductions.com/artyfx#masha', 18, 1),
           (409, 'Ducka', 'Sidechain envelope plugin, changes the volume of the main audio based on the amplitude of a sidechain signal.', 'http://www.openavproductions.com/artyfx#ducka', 18, 1),
           (410, 'Driva', 'Digital guitar distortion, including multiple different tone sorts and waveshaping functions.', 'http://www.openavproductions.com/artyfx#driva', 18, 1),
           (411, 'Della', 'BPM dependant delay with feedback', 'http://www.openavproductions.com/artyfx#della', 18, 1),
           (412, 'Bitta', 'Bit crushing causes bit-reduction type distortion', 'http://www.openavproductions.com/artyfx#bitta', 18, 1),
           (413, 'amsynth', 'A Very Big Synth', 'http://code.google.com/p/amsynth/amsynth', 23, 1),
           (414, 'abGate', '', 'http://hippie.lt/lv2/gate', 24, 1),
           (415, 'ZynReverb', '', 'http://zynaddsubfx.sourceforge.net/fx#Reverb', 25, 1),
           (416, 'ZynPhaser', '', 'http://zynaddsubfx.sourceforge.net/fx#Phaser', 25, 1),
           (417, 'ZynEcho', '', 'http://zynaddsubfx.sourceforge.net/fx#Echo', 25, 1),
           (418, 'ZynDynamicFilter', '', 'http://zynaddsubfx.sourceforge.net/fx#DynamicFilter', 25, 1),
           (419, 'ZynDistortion', '', 'http://zynaddsubfx.sourceforge.net/fx#Distortion', 25, 1),
           (420, 'ZynChorus', '', 'http://zynaddsubfx.sourceforge.net/fx#Chorus', 25, 1),
           (421, 'ZynAlienWah', '', 'http://zynaddsubfx.sourceforge.net/fx#AlienWah', 25, 1),
           (422, 'ZynAddSubFX', '', 'http://zynaddsubfx.sourceforge.net', 25, 1);

 INSERT INTO efeito.categoria_efeito (id_categoria, id_efeito) 
      VALUES 
           (1, 14),
           (2, 14),
           (3, 16),
           (3, 17),
           (3, 18),
           (3, 19),
           (3, 20),
           (3, 21),
           (3, 22),
           (3, 23),
           (3, 24),
           (3, 25),
           (3, 26),
           (3, 27),
           (3, 28),
           (3, 29),
           (3, 30),
           (3, 31),
           (3, 32),
           (3, 33),
           (3, 34),
           (3, 35),
           (3, 36),
           (3, 37),
           (3, 38),
           (3, 39),
           (3, 40),
           (3, 41),
           (3, 42),
           (4, 46),
           (5, 47),
           (6, 47),
           (7, 48),
           (8, 49),
           (7, 50),
           (9, 51),
           (7, 52),
           (10, 53),
           (11, 54),
           (12, 55),
           (13, 55),
           (5, 56),
           (14, 57),
           (15, 57),
           (3, 58),
           (16, 58),
           (3, 59),
           (16, 59),
           (11, 60),
           (14, 61),
           (14, 62),
           (12, 63),
           (14, 64),
           (7, 65),
           (4, 66),
           (1, 67),
           (10, 68),
           (12, 69),
           (13, 69),
           (11, 70),
           (7, 71),
           (8, 72),
           (8, 73),
           (5, 74),
           (6, 74),
           (10, 75),
           (9, 76),
           (10, 77),
           (3, 78),
           (16, 78),
           (17, 78),
           (9, 79),
           (9, 80),
           (3, 81),
           (4, 82),
           (12, 83),
           (13, 83),
           (3, 84),
           (16, 84),
           (18, 84),
           (10, 85),
           (9, 86),
           (11, 87),
           (14, 88),
           (19, 88),
           (7, 89),
           (20, 89),
           (3, 90),
           (7, 91),
           (21, 91),
           (7, 92),
           (21, 92),
           (7, 93),
           (7, 94),
           (7, 95),
           (9, 96),
           (3, 97),
           (14, 98),
           (19, 98),
           (9, 99),
           (12, 100),
           (13, 100),
           (4, 101),
           (12, 102),
           (13, 102),
           (3, 103),
           (3, 104),
           (7, 105),
           (10, 106),
           (7, 107),
           (3, 108),
           (7, 109),
           (14, 110),
           (22, 110),
           (9, 111),
           (10, 112),
           (11, 113),
           (7, 114),
           (23, 114),
           (9, 115),
           (14, 116),
           (19, 116),
           (3, 117),
           (11, 118),
           (1, 119),
           (1, 120),
           (1, 121),
           (3, 122),
           (3, 123),
           (1, 124),
           (1, 125),
           (3, 126),
           (3, 127),
           (3, 128),
           (12, 129),
           (12, 130),
           (12, 131),
           (12, 132),
           (12, 133),
           (12, 134),
           (12, 135),
           (12, 136),
           (12, 137),
           (12, 138),
           (14, 139),
           (12, 140),
           (7, 141),
           (23, 141),
           (5, 142),
           (3, 143),
           (12, 144),
           (4, 145),
           (14, 146),
           (5, 147),
           (4, 148),
           (7, 149),
           (3, 150),
           (12, 151),
           (13, 151),
           (5, 152),
           (6, 152),
           (9, 153),
           (14, 154),
           (19, 154),
           (14, 155),
           (14, 156),
           (15, 156),
           (8, 157),
           (5, 158),
           (6, 158),
           (4, 159),
           (5, 160),
           (6, 160),
           (14, 161),
           (5, 162),
           (6, 162),
           (11, 163),
           (9, 164),
           (12, 165),
           (13, 165),
           (11, 166),
           (9, 167),
           (14, 168),
           (8, 169),
           (5, 170),
           (9, 171),
           (10, 172),
           (9, 173),
           (9, 174),
           (7, 175),
           (21, 175),
           (7, 176),
           (21, 176),
           (7, 177),
           (21, 177),
           (11, 178),
           (11, 179),
           (9, 180),
           (9, 181),
           (5, 182),
           (24, 182),
           (1, 183),
           (3, 184),
           (25, 184),
           (3, 185),
           (25, 185),
           (3, 186),
           (26, 186),
           (3, 187),
           (26, 187),
           (10, 188),
           (10, 189),
           (14, 190),
           (19, 190),
           (14, 191),
           (19, 191),
           (9, 192),
           (3, 193),
           (1, 194),
           (27, 194),
           (7, 195),
           (7, 196),
           (11, 197),
           (9, 198),
           (9, 199),
           (8, 200),
           (8, 201),
           (11, 202),
           (1, 203),
           (3, 204),
           (10, 205),
           (7, 206),
           (7, 207),
           (9, 208),
           (8, 209),
           (8, 210),
           (10, 211),
           (9, 212),
           (10, 213),
           (10, 214),
           (14, 215),
           (28, 215),
           (14, 216),
           (28, 216),
           (14, 217),
           (28, 217),
           (9, 218),
           (7, 219),
           (21, 219),
           (12, 220),
           (13, 220),
           (9, 221),
           (9, 222),
           (10, 223),
           (11, 224),
           (9, 225),
           (11, 226),
           (14, 227),
           (19, 227),
           (1, 228),
           (8, 229),
           (8, 230),
           (9, 231),
           (9, 232),
           (9, 233),
           (3, 234),
           (16, 234),
           (3, 235),
           (9, 236),
           (9, 237),
           (9, 238),
           (9, 239),
           (7, 240),
           (23, 240),
           (14, 241),
           (22, 241),
           (11, 242),
           (11, 243),
           (11, 244),
           (11, 245),
           (11, 246),
           (12, 247),
           (13, 247),
           (11, 248),
           (9, 249),
           (14, 250),
           (19, 250),
           (7, 251),
           (7, 252),
           (20, 252),
           (8, 253),
           (3, 254),
           (16, 254),
           (8, 255),
           (8, 256),
           (10, 258),
           (9, 260),
           (7, 261),
           (20, 261),
           (10, 262),
           (7, 263),
           (21, 263),
           (7, 264),
           (20, 264),
           (7, 265),
           (20, 265),
           (3, 266),
           (5, 267),
           (24, 267),
           (10, 268),
           (5, 269),
           (24, 269),
           (5, 270),
           (24, 270),
           (3, 271),
           (16, 271),
           (17, 271),
           (3, 272),
           (25, 272),
           (3, 273),
           (25, 273),
           (3, 274),
           (25, 274),
           (3, 275),
           (25, 275),
           (3, 276),
           (26, 276),
           (7, 277),
           (21, 277),
           (5, 278),
           (6, 278),
           (5, 279),
           (6, 279),
           (5, 280),
           (6, 280),
           (5, 281),
           (6, 281),
           (5, 282),
           (6, 282),
           (5, 283),
           (6, 283),
           (5, 284),
           (6, 284),
           (5, 285),
           (6, 285),
           (5, 286),
           (6, 286),
           (5, 287),
           (6, 287),
           (5, 288),
           (6, 288),
           (5, 289),
           (6, 289),
           (5, 290),
           (6, 290),
           (5, 291),
           (6, 291),
           (5, 292),
           (6, 292),
           (5, 293),
           (6, 293),
           (5, 294),
           (6, 294),
           (5, 295),
           (6, 295),
           (5, 296),
           (6, 296),
           (9, 297),
           (29, 297),
           (4, 298),
           (5, 299),
           (6, 299),
           (10, 300),
           (12, 301),
           (13, 301),
           (10, 302),
           (10, 303),
           (5, 305),
           (6, 305),
           (14, 307),
           (28, 307),
           (3, 308),
           (16, 308),
           (3, 309),
           (16, 309),
           (4, 310),
           (5, 311),
           (8, 312),
           (14, 313),
           (14, 314),
           (5, 315),
           (24, 315),
           (11, 316),
           (9, 317),
           (10, 318),
           (10, 319),
           (7, 320),
           (21, 320),
           (1, 321),
           (4, 322),
           (5, 323),
           (3, 324),
           (16, 324),
           (3, 325),
           (16, 325),
           (3, 326),
           (16, 326),
           (3, 327),
           (16, 327),
           (14, 328),
           (19, 328),
           (14, 329),
           (19, 329),
           (1, 330),
           (7, 331),
           (20, 331),
           (5, 332),
           (24, 332),
           (8, 333),
           (8, 334),
           (3, 335),
           (8, 336),
           (3, 337),
           (1, 338),
           (1, 339),
           (1, 340),
           (3, 341),
           (11, 342),
           (8, 344),
           (4, 345),
           (14, 346),
           (15, 346),
           (14, 347),
           (22, 347),
           (14, 348),
           (19, 348),
           (9, 349),
           (8, 350),
           (7, 351),
           (11, 352),
           (10, 353),
           (7, 354),
           (7, 355),
           (5, 356),
           (6, 356),
           (14, 357),
           (15, 357),
           (14, 358),
           (22, 358),
           (14, 359),
           (19, 359),
           (7, 360),
           (5, 361),
           (6, 361),
           (1, 362),
           (14, 363),
           (19, 363),
           (14, 364),
           (15, 364),
           (4, 365),
           (14, 366),
           (22, 366),
           (7, 367),
           (3, 368),
           (3, 369),
           (12, 370),
           (3, 371),
           (16, 371),
           (3, 372),
           (16, 372),
           (3, 373),
           (16, 373),
           (3, 374),
           (16, 374),
           (3, 375),
           (14, 376),
           (19, 376),
           (9, 377),
           (14, 378),
           (19, 378),
           (1, 379),
           (12, 380),
           (5, 381),
           (24, 381),
           (5, 382),
           (24, 382),
           (5, 383),
           (24, 383),
           (5, 385),
           (24, 385),
           (5, 386),
           (24, 386),
           (5, 390),
           (24, 390),
           (5, 394),
           (24, 394),
           (3, 395),
           (25, 395),
           (1, 396),
           (14, 398),
           (28, 398),
           (10, 401),
           (3, 402),
           (16, 402),
           (3, 403),
           (9, 406),
           (11, 408),
           (9, 410),
           (11, 411),
           (9, 412),
           (5, 413),
           (6, 413),
           (14, 414),
           (30, 414),
           (10, 415),
           (7, 416),
           (21, 416),
           (11, 417),
           (3, 418),
           (9, 419),
           (7, 420),
           (20, 420),
           (7, 421),
           (21, 421),
           (5, 422),
           (6, 422);


