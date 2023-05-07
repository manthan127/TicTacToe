import SwiftUI

enum Modes: String, CaseIterable {
    case twoPlayer
    case easy
    case medium
    case hard
    case extreme
    
    var color: Color {
        switch self {
        case .twoPlayer: return Color.green
        case .easy: return Color.yellow
        case .medium: return Color.orange
        case .hard: return Color.red
        case .extreme: return Color.white
        }
    }
}


struct ContentView: View {
    
    @State private var mode = Modes.twoPlayer
    
    @State var navExtreme: Bool = false
    @State var navGame = false
    
    let width = UIScreen.main.bounds.width/3
    var body: some View {
        VStack{
            Spacer()
            NavigationLink(destination: ExtremeScreen() , isActive: $navExtreme){}
            
            NavigationLink(destination: GameScreen(mode: mode) , isActive: $navGame){}
            
            Button {
                if mode == .extreme {
                    navExtreme = true
                } else {
                    navGame = true
                }

            } label: {
                Text("Play")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(width: width, height: (width/3)*2)
                    .background(RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: .init(x: 0.4, y: 0.4), startRadius: 5, endRadius: 70))
                    .cornerRadius(10)
            }
            .offset(y: 30)

            Spacer()
            
            Text("Choose mode")
                .font(.title)
                .offset(y: 50)
            Picker(selection: $mode, label: Text("Choose mode")){
                ForEach(Modes.allCases, id: \.self) {
                    Text($0.rawValue)
                        .font(.title2)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Spacer()
        }
        .background(RadialGradient(gradient: Gradient(colors: [Color.yellow, Color(UIColor.magenta)]), center: .init(x: 0.2, y: 0.2), startRadius: 100, endRadius: 500))
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
