import OdinKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var room: OdinRoom

    var body: some View {
        switch room.connectionStatus.state {
            case OdinRoomConnectionState_Connected:
                RoomView()
            default:
                LoginView()
        }
    }
}
