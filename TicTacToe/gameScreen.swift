import SwiftUI

struct GameScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var mode: Modes
    @State var board = _9zero
    @State var capsule: [Int] = []
    @State var turn: Bool = true
    @State var showAlert: Bool = false
    @State var win: Bool = false {
        didSet { if win {
            showAlert = true
        }}
    }
    @State var draw: Bool = false {
        didSet { if draw {
            showAlert = true
        }}
    }
    
    /// View
    var body: some View {
        VStack {
            Text( "Turn of player:-  " + (turn ? "O" : "X"))
                .font(.title)
            
            SmallBoard(mode: mode, color: mode.color, board: $board, tap: { index in
                board[index] = turn ? 1 : 2
                
                if shouldContinue() {
                    turn.toggle()
                    if mode != .twoPlayer {
                        switch mode {
                            case .easy: easy()
                            case .medium: medium(isHard: false)
                            default: medium(isHard: true)
                        }
                        
                        if shouldContinue() {
                            turn.toggle()
                        }
                    }
                }
            } )
            .overlay(lineView)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text( draw ? "game draw" : (turn ? "O" : "X") + " won the game"),
                      primaryButton: .default(Text("home screen"), action: {
                    presentationMode.wrappedValue.dismiss()
                }),
                      secondaryButton: .default(Text("play again"), action: {
                    board = _9zero
                    win = false
                    draw = false
                    capsule = []
                    turn.toggle()
                    if !turn && mode != .twoPlayer {
                        switch mode {
                        case .easy: easy()
                        case .medium: medium(isHard: false)
                        default: medium(isHard: true)
                        }
                        
                        turn.toggle()
                    }
                })
                )
            })
            .padding(15)
        }
    }
    
    var lineView: some View {
        ZStack {
            HStack{
                ForEach (0..<3) { i in
                    Capsule()
                        .opacity(capsule.contains(i) ? 0.4 : 0)
                }
            }
            
            VStack {
                ForEach (3..<6) { i in
                    if i != 4 {
                        Capsule()
                            .opacity(capsule.contains(i) ? 0.4 : 0)
                    } else {
                        ZStack {
                            Capsule()
                                .opacity(capsule.contains(4) ? 0.4 : 0)
                            GeometryReader { geo in
                                Capsule()
                                    .padding(.horizontal, geo.size.height*(sqrt(2)-1)/2)
                                    .scaleEffect(x: sqrt(2), y: 1, anchor: .center)
                                    .rotationEffect(Angle(degrees: 45.0))
                                    .opacity(capsule.contains(6) ? 0.4 : 0)
                                Capsule ()
                                    .padding(.horizontal, geo.size.height*(sqrt(2)-1)/2)
                                    .scaleEffect(x: sqrt(2), y: 1, anchor: .center)
                                    .rotationEffect(Angle(degrees: -45.0))
                                    .opacity(capsule.contains(7) ? 0.4 : 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Logic
    func easy() {
        if let firstEmpty = (0..<9).shuffled().first(where: {board[$0] == 0}) {
            board[firstEmpty] = 2
        }
    }
    
    func medium(isHard: Bool) {
        func find(_ search: [Int])-> [Int] {
            for i in lines.indices {
                if lines[i].map({ board[$0] }).sorted() == search, let firstEmpty = lines[i].first(where: {board[$0] == 0}) {
                    return [firstEmpty]
                }
            }
            return []
        }
        
        let smartCorner = {
            [[1,0,0,0,2,0,0,0,1], [0,0,1,0,2,0,1,0,0]].contains(board) ? [1,3,5,7].shuffled() : []
        }
        
        let medium = [smartCorner , [0,2,6,8].shuffled, [1,3,5,7].shuffled ]
        
        let closures = [{[4]}, {find([0,2,2])}, {find([0,1,1])}] + (isHard ? [hard] : medium)
        
        for closure in closures {
            if let firstEmpty = closure().first(where: {board[$0] == 0}) {
                board[firstEmpty] = 2
                return
            }
        }
        
    }
    
    func hard() -> [Int] {
        
        func evaluate() -> Int {
            for i in lines.indices {
                let lis = Set(lines[i].map{board[$0]})
                if lis == Set([2]) {
                    return 10
                }
                if lis == Set([1]) {
                    return -10
                }
            }
            return 0
        }
        
        func minimax(_ depth: Int, _ isMax: Bool)->Int {
            if !board.contains(0) {
                return 0
            }
            
            let score = evaluate()
            if score != 0 {
                return score
            }
            
            var best = isMax ? -1000 : 1000
            
            for i in 0..<9 where board[i] == 0 {
                board[i] = isMax ? 2 : 1
                best = isMax ? max(best, minimax(depth + 1, !isMax)) : min(best, minimax(depth + 1, !isMax))
                board[i] = 0
            }
            return best
        }
        
        var bestVal = -1000
        var bestMove = -1
        
        for i in 0..<9 {
            if board[i] == 0 {
                board[i] = 2
                let moveVal = minimax(0, false)
                board[i] = 0
                if moveVal > bestVal {
                    bestMove = i
                    bestVal = moveVal
                }
            }
        }
        return [bestMove]
    }
    
    func shouldContinue() -> Bool {
        let check = turn ? ones : twos
        capsule = lines.indices.filter{ lines[$0].map{board[$0]} == check }
        
        if capsule.count != 0 {
            win = true
        } else if !board.contains(0) {
            draw = true
        } else {
            return true
        }
        
        return false
    }
}

struct gameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen(mode: .twoPlayer)
    }
}
