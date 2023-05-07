import SwiftUI

struct ExtremeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var pBoard = _9zero
    @State var turn: Bool = true
    @State var win: Bool = false { didSet {
        if win { showAlert = true }
    }}
    @State var draw: Bool = false { didSet {
        if draw { showAlert = true }
    }}
    @State var showAlert: Bool = false
    @State var boards = Array(repeating: _9zero, count: 9)
    
    @State var permanentDis: Set<Int> = []
    @State var selected: Set<Int> = [4]
    
    func state(of bIndex: Int) -> (Int, colour: Color) {
        if selected.contains(bIndex) {
            return (0, .yellow)
        } else if pBoard[bIndex] == 1 {
            return (1, Color.blue.opacity(0.5))
        } else if pBoard[bIndex] == 2 {
            return (2, Color.red.opacity(0.5))
        } else if pBoard[bIndex] == 3 {
            return (3, Color.green.opacity(0.5))
        }
        return (4, .white)
    }
    
    var body: some View {
        VStack {
            Text( "Turn of player:-  " + (turn ? "O" : "X"))
                .font(.title)
            VStack(spacing: 7) {
                ForEach(0..<3){ i in
                    HStack(spacing: 7) {
                        ForEach(0..<3) { j in
                            let bIndex = j + i*3
                            
                            let x = state(of: bIndex)
                            
                            SmallBoard(mode: .extreme, color: x.colour, board: $boards[bIndex], tap: { index in
                                boards[bIndex][index] = turn ? 1 : 2
                                check(at: bIndex)
                                selected = pBoard[index] == 0 ? [index] : Set(pBoard.indices.filter{ pBoard[$0] == 0 })
                                shouldContinue()
                            })
                            .disabled(x.0 != 0)
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text( draw ? "game draw" : (turn ? "O" : "X") + " won the game"),
                      primaryButton: .default(Text("home screen"), action: {
                        presentationMode.wrappedValue.dismiss()
                      }),
                      secondaryButton: .default(Text("play again"), action: {
                        pBoard = _9zero
                        boards = Array(repeating: _9zero, count: 9)
                        win = false
                        draw = false
                        selected = [4]
                        turn.toggle()
                      })
                )
            })
            .padding(5)
            .background(Color.green)
            .padding(15)
        }
    }
    
    func shouldContinue() {
        let check = turn ? ones : twos
        let winC = { (set3:Array) in set3.map{pBoard[$0]} == check }
        if lines.contains(where: winC) {
            win = true
        } else if !pBoard.contains(0) {
            draw = true
        } else {
            turn.toggle()
        }
    }
    
    func check(at bIndex: Int) {
        let check = turn ? ones : twos
        let winC = { (set3:Array) in set3.map{boards[bIndex][$0]} == check }
        if lines.contains(where: winC) {
            pBoard[bIndex] = turn ? 1 : 2
        } else if !boards[bIndex].contains(0) {
            pBoard[bIndex] = 3
        }
    }
}

struct ExtremeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExtremeScreen()
    }
}
