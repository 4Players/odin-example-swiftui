import OdinKit
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        TabView {
            Form {
                HStack {
                    Text("Server Address:").frame(width: 120, alignment: .leading)
                    TextField(OdinGatewayUrl.production.rawValue, text: $settings.gatewayUrl)
                }

                HStack {
                    Text("Access Key:").frame(width: 120, alignment: .leading)
                    TextField("Your secret Access Key", text: $settings.accessKey)
                }
            }
            .padding()
            .tabItem {
                Label("Authentication", systemImage: "lock")
            }

            Form {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Voice Activity Detection:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.voice_activity_detection)
                    }
                                
                    HStack {
                        Text("Voice Activity Detection Sensitivity:").frame(width: 240, alignment: .leading)
                        Slider(value: $settings.apmConfig.voice_activity_detection_attack_probability, in: 0.0...1.0)
                    }
                                
                    HStack {
                        Text("Volume Gate:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.volume_gate)
                    }
                                
                    HStack {
                        Text("Volume Gate Loudness:").frame(width: 240, alignment: .leading)
                        Slider(value: $settings.apmConfig.volume_gate_attack_loudness, in: -100.0...0.0)
                    }
                                
                    HStack {
                        Text("Noise Suppression:").frame(width: 240, alignment: .leading)
                        Picker("", selection: $settings.apmConfig.noise_suppression_level.rawValue) {
                            Text("None")
                                .tag(OdinNoiseSuppressionLevel_None.rawValue)
                            Text("Low")
                                .tag(OdinNoiseSuppressionLevel_Low.rawValue)
                            Text("Moderate")
                                .tag(OdinNoiseSuppressionLevel_Moderate.rawValue)
                            Text("High")
                                .tag(OdinNoiseSuppressionLevel_High.rawValue)
                            Text("Very High")
                                .tag(OdinNoiseSuppressionLevel_VeryHigh.rawValue)
                        }
                    }
                                
                    HStack {
                        Text("Echo Canceller:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.echo_canceller)
                    }
                                
                    HStack {
                        Text("High Pass Filter:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.high_pass_filter)
                    }
                                
                    HStack {
                        Text("Pre-Amplifier:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.pre_amplifier)
                    }
                                
                    HStack {
                        Text("Transient Suppressor:").frame(width: 240, alignment: .leading)
                        Toggle("", isOn: $settings.apmConfig.transient_suppressor)
                    }
                }
            }
            .padding()
            .tabItem {
                Label("Signal Processing", systemImage: "music.mic")
            }
        }
        .frame(width: 480, height: 320)
    }
}
