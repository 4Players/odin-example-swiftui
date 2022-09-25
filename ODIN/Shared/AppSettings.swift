import Foundation
import OdinKit

class AppSettings: ObservableObject {
    private let kConfigAuthAccessKey = "config.auth.access_key"
    private let kConfigAuthGatewayUrl = "config.auth.server_url"
    private let kConfigAuthUserIdentifier = "config.auth.user_id"
    private let kConfigApmVadEnabled = "config.apm.voice_activity_detection"
    private let kConfigApmVadProbability = "config.apm.voice_activity_detection_probability"
    private let kConfigApmVolumeGateEnabled = "config.apm.volume_gate"
    private let kConfigApmVolumeGateLoudness = "config.apm.volume_gate_loudness"
    private let kConfigApmEchoCancellerEnabled = "config.apm.echo_canceller"
    private let kConfigApmHighPassFilterEnabled = "config.apm.high_pass_filter"
    private let kConfigApmPreAmplifierEnabled = "config.apm.pre_amplifier"
    private let kConfigApmNoiseSuppressionLevel = "config.apm.noise_suppression"
    private let kConfigApmTransientSuppressorEnabled = "config.apm.transient_suppressor"
    private let kConfigApmGainControllerEnabled = "config.apm.gain_controller"
    private let kConfigRecentRoomId = "config.recent.room"
    private let kConfigRecentDisplayName = "config.recent.name"
    private let kConfigSdkVersion = "version.odin"
    
    private let vadReleaseOffset = 0.1
    private let volumeGateReleaseOffset = 10.0
    
    @Published var accessKey: String = "" {
        didSet {
            UserDefaults.standard.set(accessKey, forKey: kConfigAuthAccessKey)
        }
    }
    
    @Published var gatewayUrl: String = "" {
        didSet {
            UserDefaults.standard.set(gatewayUrl, forKey: kConfigAuthGatewayUrl)
        }
    }
    
    @Published var lastRoomId: String = "" {
        didSet {
            UserDefaults.standard.set(lastRoomId, forKey: kConfigRecentRoomId)
        }
    }
        
    @Published var lastDisplayName: String = "" {
        didSet {
            UserDefaults.standard.set(lastDisplayName, forKey: kConfigRecentDisplayName)
        }
    }
    
    @Published var apmConfig: OdinApmConfig = .init() {
        didSet {
            UserDefaults.standard.set(apmConfig.voice_activity_detection, forKey: kConfigApmVadEnabled)
            UserDefaults.standard.set(apmConfig.voice_activity_detection_attack_probability * 10, forKey: kConfigApmVadProbability)
            UserDefaults.standard.set(apmConfig.volume_gate, forKey: kConfigApmVolumeGateEnabled)
            UserDefaults.standard.set(apmConfig.volume_gate_attack_loudness, forKey: kConfigApmVolumeGateLoudness)
            UserDefaults.standard.set(apmConfig.echo_canceller, forKey: kConfigApmEchoCancellerEnabled)
            UserDefaults.standard.set(apmConfig.high_pass_filter, forKey: kConfigApmHighPassFilterEnabled)
            UserDefaults.standard.set(apmConfig.pre_amplifier, forKey: kConfigApmPreAmplifierEnabled)
            UserDefaults.standard.set(apmConfig.noise_suppression_level.rawValue, forKey: kConfigApmNoiseSuppressionLevel)
            UserDefaults.standard.set(apmConfig.transient_suppressor, forKey: kConfigApmTransientSuppressorEnabled)
            UserDefaults.standard.set(apmConfig.gain_controller, forKey: kConfigApmGainControllerEnabled)
        }
    }
    
    var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: kConfigAuthUserIdentifier) else {
            let newUserId = UUID().uuidString
            UserDefaults.standard.set(newUserId, forKey: kConfigAuthUserIdentifier)
            return newUserId
        }
        
        return userId
    }

    init() {
        let mainBundlePath = Bundle.main.bundlePath
#if os(iOS)
        let confBundlePath = (mainBundlePath as NSString).appendingPathComponent("Settings.bundle")
#else
        let confBundlePath = (mainBundlePath as NSString).appendingPathComponent("Contents/Resources/Settings.bundle")
#endif
            
        let settings = NSDictionary(contentsOfFile: (confBundlePath as NSString).appendingPathComponent("Root.plist"))
            
        if let prefSpecifiers = settings?.object(forKey: "PreferenceSpecifiers") as? [[String: Any]] {
            var defaults = [String: Any]()
            for prefItem in prefSpecifiers {
                guard let key = prefItem["Key"] as? String else { continue }
                defaults[key] = prefItem["DefaultValue"]
            }
                
            UserDefaults.standard.register(defaults: defaults)
        }
        
        reload()
    }
    
    func reload() {
        let vadAttackProbability = UserDefaults.standard.double(forKey: kConfigApmVadProbability) / 10
        let vadReleaseProbability = vadAttackProbability - vadReleaseOffset
        let volumeGateAttachLoudness = UserDefaults.standard.double(forKey: kConfigApmVolumeGateLoudness)
        let volumeGateReleaseLoudness = volumeGateAttachLoudness - volumeGateReleaseOffset
        let noiseSuppressionLevel = UserDefaults.standard.integer(forKey: kConfigApmNoiseSuppressionLevel)
        
        accessKey = UserDefaults.standard.string(forKey: kConfigAuthAccessKey) ?? ""
        gatewayUrl = UserDefaults.standard.string(forKey: kConfigAuthGatewayUrl) ?? OdinGatewayUrl.production.rawValue
        lastRoomId = UserDefaults.standard.string(forKey: kConfigRecentRoomId) ?? ""
        lastDisplayName = UserDefaults.standard.string(forKey: kConfigRecentDisplayName) ?? ""
        apmConfig = .init(
            voice_activity_detection: UserDefaults.standard.bool(forKey: kConfigApmVadEnabled),
            voice_activity_detection_attack_probability: Float(vadAttackProbability),
            voice_activity_detection_release_probability: Float(vadReleaseProbability),
            volume_gate: UserDefaults.standard.bool(forKey: kConfigApmVolumeGateEnabled),
            volume_gate_attack_loudness: Float(volumeGateAttachLoudness),
            volume_gate_release_loudness: Float(volumeGateReleaseLoudness),
            echo_canceller: UserDefaults.standard.bool(forKey: kConfigApmEchoCancellerEnabled),
            high_pass_filter: UserDefaults.standard.bool(forKey: kConfigApmHighPassFilterEnabled),
            pre_amplifier: UserDefaults.standard.bool(forKey: kConfigApmPreAmplifierEnabled),
            noise_suppression_level: OdinNoiseSuppressionLevel(rawValue: UInt32(noiseSuppressionLevel)),
            transient_suppressor: UserDefaults.standard.bool(forKey: kConfigApmTransientSuppressorEnabled),
            gain_controller: UserDefaults.standard.bool(forKey: kConfigApmGainControllerEnabled)
        )
        
        UserDefaults.standard.set(ODIN_VERSION, forKey: kConfigSdkVersion)
    }
}
