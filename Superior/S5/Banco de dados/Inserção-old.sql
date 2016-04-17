 INSERT INTO efeito.empresa (id_empresa, nome, site) 
      VALUES 
             (1, 'GUITARIX', 'http://guitarix.org/'),
             (2, 'CALF', 'http://calf-studio-gear.org/'),
             (3, 'MOD', 'http://moddevices.com/'),
             (4, 'TAP', 'http://tap-plugins.sourceforge.net/'),
             (5, 'CAPS', 'http://quitte.de/dsp/caps.html'),
             (6, 'ARTYFX', 'http://openavproductions.com/artyfx/');

 INSERT INTO efeito.categoria (id_categoria, nome) 
      VALUES 
             (1, 'Spectral'),
             (2, 'Delay'),
             (3, 'Simulator'),
             (4, 'Utility'),
             (5, 'Generator'),
             (6, 'Oscillator'),
             (7, 'Filter'),
             (8, 'Distortion'),
             (9, 'Pitch Shifter'),
             (10, 'Modulator'),
             (11, 'Chorus'),
             (12, 'Dynamics'),
             (13, 'Compressor'),
             (14, 'Expander'),
             (15, 'Flanger'),
             (16, 'Reverb'),
             (17, 'Phaser'),
             (18, 'Instrument'),
             (19, 'Equaliser'),
             (20, 'Spatial'),
             (21, 'Limiter');

 INSERT INTO efeito.efeito (id_efeito, nome, descricao, identificador, id_empresa, id_tecnologia) 
      VALUES 
           (1, 'Drop', 'It''s a pitch shifter which can drop the pitch until 12 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.

', 'http://portalmod.com/plugins/mod-devel/Drop', 3, 1),
           (2, 'SuperCapo', 'It''s a pitch shifter which can rise the pitch until 24 semitones (steps). Despite being more limited than Super Whammy, it uses less processing, but more than Capo.

', 'http://portalmod.com/plugins/mod-devel/SuperCapo', 3, 1),
           (3, 'Super Whammy', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up. "First" and "Last" determine the range of variation where the "Step" parameter will work. "First" doesn''t need to be necessarily smaller than "Last". "Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.

', 'http://portalmod.com/plugins/mod-devel/SuperWhammy', 3, 1),
           (4, 'Harmonizer2', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up. "First" and "Last" determine the range of variation where the "Step" parameter will work. "First" doesn''t need to be necessarily smaller than "Last". "Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.

', 'http://portalmod.com/plugins/mod-devel/Harmonizer2', 3, 1),
           (5, 'Harmonizer', 'A pitch shifter that can shift an input pitch from 12 semitones down to 24 semitones up. "First" and "Last" determine the range of variation where the "Step" parameter will work. "First" doesn''t need to be necessarily smaller than "Last". "Clean" parameter allows you to hear the bypass sound summed with the pitch shifted signal and "Gain" it''s the effect gain, does not affect the clean signal.

', 'http://portalmod.com/plugins/mod-devel/Harmonizer', 3, 1),
           (16, 'DS1', 'Analog distortion emulation of the classic Boss DS-1 (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Boss DS-1 is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://portalmod.com/plugins/mod-devel/DS1', 3, 1),
           (21, 'SwitchBox2', 'This switch box receives an audio input and channel it by one of it''s two outputs.

', 'http://portalmod.com/plugins/mod-devel/SwitchBox2', 3, 1),
           (24, 'CrossOver 3', 'This plugin receives an input signal and outputs 3 filtered signals. First one is filtered with a low pass filter (LPF), the second with a band pass filter (BPF) and the third with a high pass filter (HPF), cutoff frequency used on LPF and as the lower frequency from BPF is controlled by "Freq 1" and cutoff frequency used as the higher frequency on BPF and in HPF is controlled by "Freq 2". "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1", "Gain 2" and "Gain 3" controls the gains of all outputs respectively.


', 'http://portalmod.com/plugins/mod-devel/CrossOver3', 3, 1),
           (25, 'CrossOver 2', 'This plugin receives an input signal and outputs 2 filtered signals. First one is filtered with a low pass filter (LPF) and the second, with a high pass filter (HPF), both cutoff frequencies are determined by "Freq" parameter. "Order" indicates filter''s orders (or how fast frequencies above (in HPF) or below (in LPF) the cutoff frequency will decay. Higher the order, faster the decay) ."Gain 1" and "Gain 2" controls the gains of both outputs respectively.

', 'http://portalmod.com/plugins/mod-devel/CrossOver2', 3, 1),
           (43, 'LowPassFilter', 'A simple low pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies below the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://portalmod.com/plugins/mod-devel/LowPassFilter', 3, 1),
           (44, 'HighPassFilter', 'A simple high pass filter, "Freq" determines its cutoff frequency and "Order" the filter order (or how fast frequencies above the cutoff frequency will decay. Higher the order, faster the decay).

', 'http://portalmod.com/plugins/mod-devel/HighPassFilter', 3, 1),
           (45, 'BandPassFilter', 'A band pass filter, "Freq" determines its Center frequency, "Q" works on the filter bandwith and "Order" is the filter''s order (or how fast frequencies above the higher cutoff frequency and below the lower cutoff frequency will decay. Higher the order, faster the decay).

', 'http://portalmod.com/plugins/mod-devel/BandPassFilter', 3, 1),
           (47, 'Open Big Muff', 'Analog distortion emulation of the classic Electro Harmonix Big Muff Pi (*)

(*) ''Other product names modeled in this software are trademarks of their respective companies that do not endorse and are not associated or affiliated with MOD.
Electro Harmonix Big Muff Pi is trademark or trade name of other manufacturer and was used merely to identify the product whose sound was reviewed in the creation of this product.
All other trademarks are the property of their respective holders.''

', 'http://portalmod.com/plugins/mod-devel/BigMuffPi', 3, 1),
           (49, 'C* Saturate', 'Please note that this plugin embodies a very basic building block of audio DSP, not an elaborate effect that will be pleasing to hear right away. To turn saturation into a musically useful effect it is usually combined with some sort of filtering and dynamics modulation. 

The mode control chooses from a selection of clipping functions of varying character. Even-order harmonics can be added with the bias setting. Towards the maximum, sound will start to get scratchy and eventually starve away. 

The plugin is 8x oversampled with 64-tap polyphase filters, effectively suppressing aliasing noise for most musical applications. Changes to the bias control induce short-lived energy at DC in the output. In order to reduce the computational load incurred when evaluating transcendental functions at eight times the nominal sample rate, these are approximated roughly, using Chebyshev polynomials whose coefficients depend on the amplitude''s floating point representation exponent. 

source: http://quitte.de/dsp/caps.html#Saturate
', 'http://portalmod.com/plugins/caps/Saturate', 5, 1),
           (50, 'TAP Reverberator', 'TAP Reverberator is unique among reverberators freely available on the Linux platform. It supports creating no less than 43 reverberation effects, but its design permits this to be extended even further by the user, without doing any actual programming. Please take a look at TAP Reverb Editor, a separate JACK application for more information about this.

The design is based on the comb/allpass filter model. Comb filters create early reflections and allpass filters add to this by creating a dense reverberation effect. The output of the set of comb and allpass filters (also called the reverberator chamber) is processed further by sending it through a bandpass filter. The resulting band-limited reverberation is very similar to the natural reverberation that occurs in acoustic rooms. To achieve an even more natural-sounding effect, all comb filters have high-frequency compensation in their feedback loop. This is to model that the reflection ratio of acoustic surfaces is the function of frequency: higher frequencies are attenuated more, and thus decay time of higher frequency components is significantly shorter.

To enhance the reverberation sound even further, a special option called Enhanced Stereo is provided. When turned on (which is the default), it results in an added spatial spread of the reverb sound. This feature is most noticeable when applying the plugin to mono tracks: the sound of these tracks will "open up" in space.

source: http://tap-plugins.sourceforge.net/ladspa/reverb.html
', 'http://portalmod.com/plugins/tap/reverb', 4, 1),
           (51, 'C* Noisegate - Attenuate noise resident in silence', 'This plugin aims to reduce undesirable background noise and hum in otherwise silent passages. 

When the signal''s instantaneous amplitude exceeds the opening threshold, the gate is opened. The time it takes until the gate is fully open can be set with the attack control. As soon as the signal''s RMS power level drops below the closing threshold, the gate closes. This takes a fixed time of 20 ms; closed gate attenuation is 60 dB. 

To cope with powerline hum as often present in signals from electric guitars, a notch filter can be activated by setting the mains frequency control to a non-zero value.  The filter will prevent this frequency from contributing to the signal power measurement. This allows a low closing threshold setting without mains hum keeping the gate open unduly.  The default mains setting is 50 Hz. 

source: http://quitte.de/dsp/caps.html#Noisegate
', 'http://portalmod.com/plugins/caps/Noisegate', 5, 1),
           (52, 'Gain 2x2', 'Stereo version of the simple volume gain plugin without "zipping" noise while messing with the gain parameter.

', 'http://portalmod.com/plugins/mod-devel/Gain2x2', 3, 1),
           (53, 'C* PhaserII - Mono phaser modulated by a Lorenz fractal', 'This take on the classic effect features two modulation choices, traditional sine-based periodicity or smoothened fractal oscillation. 

Very high resonance settings can cause self-oscillation peaking in excess of 0 dB. 

source: http://quitte.de/dsp/caps.html#PhaserII
', 'http://portalmod.com/plugins/caps/PhaserII', 5, 1),
           (54, 'Capo', 'It''s a pitch shifter which can rise the pitch until 4 semitones (steps). Despite being more limited than Super Whammy, it uses less processing.

', 'http://portalmod.com/plugins/mod-devel/Capo', 3, 1),
           (55, 'C* SpiceX2', 'Stereo version of Spice. Bass compression is governed by the sum of both channels, as in CompressX2. Nevertheless, the amount of harmonic generation differing between the two channels can have subtle effects on the stereo image. 

source: http://quitte.de/dsp/caps.html#Spice
', 'http://portalmod.com/plugins/caps/SpiceX2', 5, 1),
           (56, 'Roomy', 'Roomy is a reverb effect, with simple automatable controls. Perfect as an insert on the master bus, for those epic reverb builds before the drop.

source: http://openavproductions.com/artyfx/
', 'http://portalmod.com/plugins/artyfx/roomy', 6, 1),
           (57, 'C* White - White noise generator', 'Mostly white pseudonoise, mixed and filtered from the output of two Dattorro multibit generators.

source: http://quitte.de/dsp/caps.html#White
', 'http://portalmod.com/plugins/caps/White', 5, 1),
           (58, 'C* Eq10 - 10-band equalizer', 'A classic octave-band biquad-filter design, basically a direct digital translation of the analog original. There''s also a stereo version (Eq10X2). 

Frequency bands centered above Nyquist are automatically disabled. 

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://portalmod.com/plugins/caps/Eq10', 5, 1),
           (59, 'TAP Stereo Echo', 'This plugin supports conventional mono and stereo delays, ping-pong delays and the Haas effect (also known as Cross Delay Stereo). A relatively simple yet quite effective plugin.

source: http://tap-plugins.sourceforge.net/ladspa/echo.html
', 'http://portalmod.com/plugins/tap/echo', 4, 1),
           (60, 'C* ToneStack - Tone stack emulation', 'This emulation of the tone stack of a traditional Fender-design instrument amplifier has been devised and implemented by David T. Yeh, with subsequent expansion to include more models by Tim Goetze. 

Due to the nature of the original circuit, the bass, mid and treble controls are not operating independently as in a modern three-way equaliser. 

All but the last model are using the procedural implementation with continuously updated direct form II filters and sample rate independency.  It must be noted that the "DC 30" preset has been included despite the slight difference in topology between the British original and the Fender circuit. 

The "5F6-A LT" model is using the lattice filter implementation mentioned in [yeh06], operating on precomputed simulation data for 44.1 kHz. 

source: http://quitte.de/dsp/caps.html#ToneStack
', 'http://portalmod.com/plugins/caps/ToneStack', 5, 1),
           (62, 'C* CabinetIV - Idealised loudspeaker cabinet emulation', 'This plugin applies an acoustic instrument body modeling technique to recreate the timbre-shaping of an electric instrument amplifier''s speaker cabinet. Nonlinear effects occurring in physical speakers under high load are not emulated.

A selection of several hundred response shapes automatically created in the likeness of classic cabinets has been narrowed down to a handful of idealised tones.  As with AmpVTS, which provides a matching recreation of traditional guitar amplification, the design and selection process has been ruled by musicality over fidelity.

The filter banks implemented are 64 2nd order IIR and one 128-tap FIR in parallel. Their parameter presets are shared between the 44.1 and 48 kHz sample rates, the higher rate implying that timbre brightens up. Higher sample rates produce the same tones by rate conversion, up to 192 kHz.
 
Despite the complexity, computational load is very modest thanks to vector arithmetic if a hardware implementation is available – if not, however, the load will be easily an order of magnitude higher, and possibly found to be prohibitive on less powerful hardware.

source: http://quitte.de/dsp/caps.html#CabinetIV
', 'http://portalmod.com/plugins/caps/CabinetIV', 5, 1),
           (63, 'Filta', 'Filta is a highpass / lowpass filter combo. Working on a trance build, or just need some frequencies gone? Filta is the tool for the job, one dial for flexibilty but keeping simplicity!

source: http://openavproductions.com/artyfx/
', 'http://portalmod.com/plugins/artyfx/filta', 6, 1),
           (64, 'TAP Sigmoid Booster', 'This plugin applies a time-invariant nonlinear amplitude transfer function to the signal. Depending on the signal and the plugin settings, various related effects (compression, soft limiting, emulation of tape saturation, mild distortion) can be achieved.

source: http://tap-plugins.sourceforge.net/ladspa/sigmoid.html
', 'http://portalmod.com/plugins/tap/sigmoid', 4, 1),
           (65, 'TAP Equalizer/BW', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://portalmod.com/plugins/tap/eqbw', 4, 1),
           (66, 'C* Plate - Versatile plate reverb', 'This reverb processor is an adaptation of the design discussed in [dat97a]. Tuned for a soft attack and smooth ambience, it consists of a network of twelve delay lines of varying length. At its heart, two of these are modulated very subtly, in a chorus-like fashion. 

The bandwidth control reduces high-frequency content before it enters the ''tank'', while damping controls how quickly the reverberating tail darkens. 

source: http://quitte.de/dsp/caps.html#Plate
', 'http://portalmod.com/plugins/caps/Plate', 5, 1),
           (69, 'C* NoiseGate - Attenuate noise resident in silence', 'This plugin aims to reduce undesirable background noise and hum in otherwise silent passages. 

When the signal''s instantaneous amplitude exceeds the opening threshold, the gate is opened. The time it takes until the gate is fully open can be set with the attack control. As soon as the signal''s RMS power level drops below the closing threshold, the gate closes. This takes a fixed time of 20 ms; closed gate attenuation is 60 dB. 

To cope with powerline hum as often present in signals from electric guitars, a notch filter can be activated by setting the mains frequency control to a non-zero value.  The filter will prevent this frequency from contributing to the signal power measurement. This allows a low closing threshold setting without mains hum keeping the gate open unduly.  The default mains setting is 50 Hz. 

source: http://quitte.de/dsp/caps.html#NoiseGate
', 'http://portalmod.com/plugins/caps/NoiseGate', 5, 1),
           (71, 'C* AutoFilter', 'A versatile selection of filters of varying character in band and lowpass configuration. The cutoff frequency can be modulated by both the input signal envelope and by a fractal oscillator. The default settings provide some sort of an automatic wah effect. 

The extent of filter modulation is set through the range parameter. The shape of the modulation is mixed from the attractor and the envelope according to the lfo/env balance.

Filter stage gain can be used to add inter-stage saturation. To prevent this from causing audible aliasing, the plugin can be run in oversampled mode, at ratios selectable through the over control. 

At very high Q and f combined, the filter stability may become compromised. Computational load varies greatly with the over and filter settings. 

source: http://quitte.de/dsp/caps.html#AutoFilter
', 'http://portalmod.com/plugins/caps/AutoFilter', 5, 1),
           (72, 'C* PlateX2 - Stereo in/out Versatile plate reverb', 'This version of the Plate reverberator comes with stereo inputs. 

source: http://quitte.de/dsp/caps.html#Plate
', 'http://portalmod.com/plugins/caps/PlateX2', 5, 1),
           (73, 'C* Eq4p - 4-band parametric equaliser', 'Four adjustable biquad filters in series, in a vector arithmetic implementation. The default setup is an identity filter with a mode configuration of lowshelve, band, band, hishelve, all at zero gain. 

The Q control value maps non-linearly to actual filter Q: a zero control value results in filter Q of ½, a value of 0.3 corresponds to a Butterworth-equivalent Q of ½√2, and the maximum control setting of 1 results in a filter Q of 50. 

Parallelisation of the serial filter topology causes its response to lag by three samples. 

Control response is smoothened by crossfading between two filter banks. 

source: http://quitte.de/dsp/caps.html#Eq4p
', 'http://portalmod.com/plugins/caps/Eq4p', 5, 1),
           (75, 'TAP Tubewarmth', 'TAP TubeWarmth adds the character of vacuum tube amplification to your audio tracks by emulating the sonically desirable nonlinear characteristics of triodes. In addition, this plugin also supports emulating analog tape saturation.

source: http://tap-plugins.sourceforge.net/ladspa/tubewarmth.html
', 'http://portalmod.com/plugins/tap/tubewarmth', 4, 1),
           (76, 'TAP Pitch Shifter', 'This plugin gives you the opportunity to change the pitch of individual tracks or full mixes, in the range of plus/minus one octave. Audio length (tempo) is not affected by this plugin, since audio is completely resampled. Besides being a special effect for creating foxy guitar tracks, it may come handy if your (otherwise very attractive) singer or chorus-girl was a bit indisposed at the time of recording: with the power of Ardour automation, you are given a chance to correct smaller pitch errors.

source: http://tap-plugins.sourceforge.net/ladspa/pitch.html
', 'http://portalmod.com/plugins/tap/pitch', 4, 1),
           (77, 'TAP DeEsser', 'TAP DeEsser is a plugin for attenuating higher pitched frequencies in vocals such as those found in ''ess'', ''shh'' and ''chh'' sounds. Almost any vocal recording will contain ''ess'' sounds, whether a strong vocal delivery, from bad recording, speech impediments or simply many ''ess'' words spoken together. Wind instruments and other musical instruments can also create shrill high-pitched noises. Audio engineers need to control these harsh ''ess'' sounds in most recordings.

source: http://tap-plugins.sourceforge.net/ladspa/deesser.html
', 'http://portalmod.com/plugins/tap/deesser', 4, 1),
           (78, 'C* Narrower - Stereo image width reduction', 'This plugin reduces the width of a stereophonic signal. Its primary use is for preventing fatigue from listening to ''creatively panned'' music on headphones. 

Mid/side processing tends to sound more transparent for moderate strength settings.  However, it will more strongly attenuate signals that are panned to the far sides of the stereo image (rarely encountered in contemporary music production anymore but quite common, for example, on early Beatles recordings or others from that time). 

source: http://quitte.de/dsp/caps.html#Narrower 
', 'http://portalmod.com/plugins/caps/Narrower', 5, 1),
           (79, 'TAP Chorus/Flanger', 'This plugin is an implementation capable of creating traditional Chorus and Flanger effects, spiced up a bit to make use of stereo processing. It sounds best on guitar and synth tracks.

source: http://tap-plugins.sourceforge.net/ladspa/chorusflanger.html
', 'http://portalmod.com/plugins/tap/chorusflanger', 4, 1),
           (80, 'TAP Tremolo', 'The tremolo effect is probably one of the most ancient effects, originated in the earliest days of the history of studio recording. It lost some of its popularity over time (and with the emerge of more exciting digital effects), but you still hear this effect on newer recordings from time to time.

source: http://tap-plugins.sourceforge.net/ladspa/tremolo.html
', 'http://portalmod.com/plugins/tap/tremolo', 4, 1),
           (81, 'C* Eq10X2 - 10-band equalizer', 'The controls of this stereo version of Eq apply to both channels. 

source: http://quitte.de/dsp/caps.html#Eq10
', 'http://portalmod.com/plugins/caps/Eq10X2', 5, 1),
           (82, 'C* Scape - Stereo delay + Filters', 'A stereo delay with resonant filters and fractally modulated panning. 

The delay times are set through the bpm control and the divider adjustment. Triplet and sixteenth settings create a dotted rhythm. With every beat, the filter resonance frequencies are retuned to random steps on an equal-tempered chromatic scale, to the reference set through the tune control. 

source: http://quitte.de/dsp/caps.html#Scape
', 'http://portalmod.com/plugins/caps/Scape', 5, 1),
           (83, 'C* Spice', 'This effect plugin is useful when more bass register definition or more treble presence is called for and generic equalisation does not work without noticeably raising the signal or noise level. A common application is refreshing of material that has been subjected to low-quality analog transmission. 

Bass and treble portions of the signal are isolated using two 24 dB/octave Linkwitz-Riley crossover networks[lr76] to ensure a flat frequency response at zero effect intensity (controlled through the .gain settings). After compression, a polynomial waveshaper synthesises the first three overtones of the bass register. This enhances the perception of the fundamental frequency, being the difference tone of these harmonics. Treble band processing applies analog-style saturation with only simplistic antialiasing. Synthesised harmonic content is shaped through bandpass and highpass filters and mixed back into the crossover sum signal. 

A stereo version is available as SpiceX2. 

source: http://quitte.de/dsp/caps.html#Spice
', 'http://portalmod.com/plugins/caps/Spice', 5, 1),
           (84, 'TAP Equalizer', 'This plugin is an 8-band equalizer with adjustable band center frequencies. It allows you to make precise adjustments to the tonal coloration of your tracks. The design and code of this plugin is based on that of the DJ EQ plugin by Steve Harris, which can be downloaded (among lots of other useful plugins) from http://plugin.org.uk.

source: http://tap-plugins.sourceforge.net/ladspa/eq.html
', 'http://portalmod.com/plugins/tap/eq', 4, 1),
           (85, 'TAP AutoPanner', 'The AutoPanner is a very well-known effect; its hardware incarnation originates in the age of voltage controlled synthesizers. Its main use is to liven up synth tracks in the mix.

source: http://tap-plugins.sourceforge.net/ladspa/autopan.html
', 'http://portalmod.com/plugins/tap/autopan', 4, 1),
           (87, 'TAP Reflector', 'This plugin creates a psychedelic reverse audio effect. Overlapping time intervals of incoming samples are treated as blocks called ''fragments''. Each fragment is reversed in time, and faded in and out while played back to the output, hence creating a nearly constant signal level with the mixture resembling a normal reverse-played track -- with the difference that the audio actually progresses forward, only pieces of it are reversed.

source: http://tap-plugins.sourceforge.net/ladspa/reflector.html
', 'http://portalmod.com/plugins/tap/reflector', 4, 1),
           (88, 'C* Wider - Stereo image Synthesis', 'In addition to provoding a basic panorama control, a perception of stereo width is created using complementary filters on the two output channels. 

The output channels always sum to a flat frequency response. 

The design of this plugin owes to the Orban 245F Stereo Synthesizer.

source: http://quitte.de/dsp/caps.html#Wider
', 'http://portalmod.com/plugins/caps/Wider', 5, 1),
           (89, 'TAP Rotary Speaker', 'This plugin simulates the sound of rotating speakers. Two pairs of rotating speakers are simulated, each pair fixed on a vertical axis, with their horns spreading the sound in opposite directions. The two pairs of speakers are rotating with different revolutions (frequencies). The incoming sound is split into a low and a high part (with a low-pass and a high-pass filter, using a crossover frequency of 1 kHz). The low part is fed into the "Rotor" pair of speakers, and the high part into the "Horn" pair. A pair of horizontally aligned microphones is used to pick up the resulting sound. The distance of the microphones (the width of the stereo image of the effect) is adjustable.

source: http://tap-plugins.sourceforge.net/ladspa/rotspeak.html
', 'http://portalmod.com/plugins/tap/rotspeak', 4, 1),
           (90, 'Gain', 'Simple volume gain plugin without "zipping" noise while messing with the gain parameter.

', 'http://portalmod.com/plugins/mod-devel/Gain', 3, 1),
           (91, 'TAP Fractal Doubler', 'Originally developed to do vocal doubling, this plugin is suitable for doubling tracks with vocals, acoustic/electric guitars, bass and just about any other instrument on them. The effect is created by applying small changes to the pitch and timing of the incoming signal. These changes are created by one-dimensional random fractal lines producing pink noise.

source: http://tap-plugins.sourceforge.net/ladspa/doubler.html
', 'http://portalmod.com/plugins/tap/doubler', 4, 1),
           (92, 'TAP Pink/Fractal Noise', 'This plugin came to life as a secondary product of the development of TAP Fractal Doubler. It adds pink noise to the incoming signal using a one-dimensional random fractal line generated by the Midpoint Displacement Method, which is a computationally cheap method suitable for generating random fractals.

source: http://tap-plugins.sourceforge.net/ladspa/pinknoise.html
', 'http://portalmod.com/plugins/tap/pinknoise', 4, 1),
           (93, 'TAP Scaling Limiter', 'You want to maximize the loudness of your master tracks. Your drummer has the habit of playing with varying velocity. You want to squeeze high transient spikes down into the bulk of the audio. You want a limiter with transparent sound, but without distortion. This is for you, then. The unique design of this innocent looking plugin results in the ability to achieve signal level limiting without audible artifacts.

Most limiters operate on the same basis as compressors: they monitor the signal level, and when it gets above a threshold level they reduce the gain on a momentary basis, resulting in an unpleasant "pumping" effect. Or even worse, they chop the signal at the top. This plugin actually scales each half-cycle individually down to a smaller level so the peak is placed exactly at the limit level. This operation (from zero-cross to zero-cross) results in an instantaneous blending of peaks and transient spikes down into the bulk of the audio.

source: http://tap-plugins.sourceforge.net/ladspa/limiter.html
', 'http://portalmod.com/plugins/tap/limiter', 4, 1),
           (94, 'C* CEO - Chief Executive Oscillator', 'The Chief Executive Oscillator forever calls for more profit. 

Sound data created with the flite[flite] application. 

source: http://quitte.de/dsp/caps.html#CEO
', 'http://portalmod.com/plugins/caps/CEO', 5, 1),
           (95, 'TAP Vibrato', 'This plugin modulates the pitch of its input signal with a low-frequency sinusoidal signal. It is useful for guitar and synth tracks, and it can also come handy if a strange effect is needed.

source: http://tap-plugins.sourceforge.net/ladspa/vibrato.html
', 'http://portalmod.com/plugins/tap/vibrato', 4, 1),
           (96, 'C* Click - Metronome', 'A sample-accurate metronome. Two simplistic modal synthesis models are available for the click: box is a small wooden box struck with a soft wooden mallet, stick a scratchy stick hit. In addition, there''s also a very synthetic beep, and finally dirac, a very nasty single-sample pulse of 0 dB amplitude and little immediate musical use. 
All click sounds are synthesised once when the plugin is loaded and then played back from memory. 

source: http://quitte.de/dsp/caps.html#Click
', 'http://portalmod.com/plugins/caps/Click', 5, 1),
           (98, 'C* Sin - Sine wave generator', 'The old friend, indispensable for testing and tuning. 

source: http://quitte.de/dsp/caps.html#Sin
', 'http://portalmod.com/plugins/caps/Sin', 5, 1),
           (99, 'C* Compress - Mono compressor', 'This compressor has been designed primarily to create natural-sounding sustain for the electric guitar without sacrificing its brightly percussive character. However, it appears to apply well to a variety of other sound sources, and with CompressX2 a stereo version is available as well. 

To be able produce strong compression and still maintain a natural sound, the design catches (attack-phase) power spikes with a soft saturation circuit, converting them into additional harmonic content and enforcing a strict limit on the output level. Saturating operation is the default setting of the mode control. Three anti-aliasing options are available, 2x oversampling with 32-tap filters and 4x with 64 and 128 taps. 

The measure control select which indicator of loudness to base calculations on: peak – instantaneous amplitude – measurement allows the unit to react very quickly, while rms – root mean square power – is of a gentler kind. 

Compression amount is controlled through the strength knob, from 0 effectively disabling the effect, up to a maximum ratio of 16:1. The attack and release controls map higher values to slower reactions. 

source: http://quitte.de/dsp/caps.html#Compress
', 'http://portalmod.com/plugins/caps/Compress', 5, 1),
           (100, 'C* CompressX2 - Stereo compressor', 'This stereo version of Compress applies uniform compression to both channels in proportion to their combined power. 

source: http://quitte.de/dsp/caps.html#Compress
', 'http://portalmod.com/plugins/caps/CompressX2', 5, 1),
           (101, 'TAP Mono Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://portalmod.com/plugins/tap/dynamics_m', 4, 1),
           (108, 'TAP Stereo Dynamics', 'TAP Dynamics is a versatile tool for changing the dynamic content of your tracks. Currently it supports 15 dynamics transfer functions, among which there are compressors, limiters, expanders and noise gates. However, the plugin itself supports arbitrary dynamics transfer functions, so you may add your own functions as well, without any actual programming.

The plugin comes in two versions: Mono (M) and Stereo (St). This is needed because independent processing of two channels is not always desirable in the case of stereo material. The stereo version has an additional control to set the appropriate mode for stereo processing (you may still choose to process the two channels independently, although the same effect is achieved by using the mono version).

source: http://tap-plugins.sourceforge.net/ladspa/dynamics.html
', 'http://portalmod.com/plugins/tap/dynamics_st', 4, 1),
           (109, 'C* AmpVTS - Tube amp + Tone stack', 'Tracing the stages of a typical tube amplifier circuit, this plugin aims to recreate those features of traditional guitar amplification electronics that have proved musically useful, and to provide them with the most musical rather than the most authentic ranges of adjustment and character.  CabinetIV provides matching recreations of loudspeaker cabinets. 

The processor consists – with some interconnections – of a configurable lowcut input filter, a ToneStack circuit of the procedural variant, a saturating ''preamp'' stage with adjustable gain and variable distortion asymmetry followed by the bright filter, compression characteristics determined by the attack and squash controls and finally a ''power amp'' stage with the amount of saturation depending on both gain and power settings. 

Sound quality and computational load can be balanced with the over control affording a choice of 2x or 4x oversampling with 32-tap filters, or 8x with 64 taps.  Lower quality settings will sound slightly grittier and less transparent, and at high gain aliasing may become audible. 

source: http://quitte.de/dsp/caps.html#AmpVTS
', 'http://portalmod.com/plugins/caps/AmpVTS', 5, 1);

 INSERT INTO efeito.categoria_efeito (id_categoria, id_efeito) 
      VALUES 
           (1, 1),
           (1, 2),
           (1, 3),
           (1, 4),
           (1, 5),
           (8, 16),
           (4, 21),
           (7, 24),
           (7, 25),
           (7, 43),
           (7, 44),
           (7, 45),
           (8, 47),
           (8, 49),
           (16, 50),
           (4, 51),
           (4, 52),
           (10, 53),
           (17, 53),
           (1, 54),
           (12, 55),
           (16, 56),
           (5, 57),
           (7, 58),
           (19, 58),
           (2, 59),
           (3, 60),
           (3, 62),
           (7, 63),
           (8, 64),
           (7, 65),
           (19, 65),
           (16, 66),
           (4, 69),
           (7, 71),
           (16, 72),
           (7, 73),
           (19, 73),
           (3, 75),
           (1, 76),
           (9, 76),
           (12, 77),
           (20, 78),
           (10, 79),
           (10, 80),
           (7, 81),
           (19, 81),
           (2, 82),
           (12, 83),
           (7, 84),
           (19, 84),
           (20, 85),
           (2, 87),
           (20, 88),
           (10, 89),
           (4, 90),
           (1, 91),
           (5, 92),
           (12, 93),
           (21, 93),
           (5, 94),
           (6, 94),
           (10, 95),
           (4, 96),
           (5, 98),
           (6, 98),
           (12, 99),
           (13, 99),
           (12, 100),
           (13, 100),
           (12, 101),
           (12, 108),
           (3, 109);


