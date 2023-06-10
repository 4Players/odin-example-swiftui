import OdinKit
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var room: OdinRoom
    @EnvironmentObject var settings: AppSettings

    @State var showError = false
    @State var lastError = ""

    var body: some View {
        VStack {
            Text("Welcome to ODIN")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)

            Image("LoginAvatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .padding(.bottom, 20)

            Text("Enter a room name to join or start a conversation.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)

            TextField("Desired Room Name", text: $settings.lastRoomId)
                .disableAutocorrection(true)
#if os(iOS)
                .textInputAutocapitalization(.never)
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(5.0)
#endif
                .padding(.bottom, 10)

            TextField("Your Name", text: $settings.lastDisplayName)
                .disableAutocorrection(true)
#if os(iOS)
                .textInputAutocapitalization(.never)
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(5.0)
#endif
                .padding(.bottom, 50)

            Button(action: joinRoom) {
                Text("JOIN")
#if os(iOS)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.accentColor)
                    .cornerRadius(60)
#endif
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Something went wrong"), message: Text(lastError), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    private func joinRoom() {
        do {
            let accessKey = try OdinAccessKey(settings.accessKey)
            let authToken = try accessKey.generateToken(roomId: settings.lastRoomId, userId: settings.userId)

#if os(iOS)
            let operatingSystem = "iOS"
#else
            let operatingSystem = "macOS"
#endif

            let userData = PeerUserData(
                name: settings.lastDisplayName,
                inputMuted: 0,
                outputMuted: 0,
                platform: operatingSystem,
                version: ODIN_VERSION
            )

            try room.updatePeerUserData(userData: OdinCustomData.encode(userData))
            try room.updateGatewayUrl(settings.gatewayUrl)
            try room.updateAudioConfig(settings.apmConfig)

            _ = try room.join(token: authToken)
            _ = try room.addMedia(audioConfig: OdinAudioStreamConfig(
                sample_rate: UInt32(OdinAudio.sharedInstance().engine.inputNode.inputFormat(forBus: 0).sampleRate),
                channel_count: 1
            ))
        } catch let OdinResult.error(mesg) {
            showError = true
            lastError = mesg
        } catch {
            showError = true
            lastError = error.localizedDescription
        }
    }
}

struct LoginPreview: PreviewProvider {
    @StateObject static var room: OdinRoom = .init()
    @StateObject static var settings: AppSettings = .init()

    static var previews: some View {
        LoginView()
            .padding(.all)
            .environmentObject(room)
            .environmentObject(settings)
    }
}
