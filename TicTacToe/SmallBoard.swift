import SwiftUI

struct SmallBoard: View {
    
    let mode: Modes
    let color: Color
    @Binding var board: [Int]
    var tap: (Int) -> Void
    
    var body: some View {
        let spacingCheck: CGFloat = mode == .extreme ? 3 : 7
        
        return VStack(spacing: spacingCheck) {
            ForEach(0..<3){ i in
                HStack(spacing: spacingCheck) {
                    ForEach(0..<3) { j in
                        let index = j + i*3
                        Text(board[index] == 0 ? " " : board[index] == 1 ? "O" : "X")
                            .foregroundColor(Color.black)
                            .font(.system(size: 500))
                            .minimumScaleFactor(0.01)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .background(color)
                            .onTapGesture {
                                tap(index)
                            }
                            .disabled(board[index] != 0)
                    }
                }
            }
        }
        .padding(mode == .extreme ? 2 : 5)
        .background(Color.black)
        .aspectRatio(1, contentMode: .fit)
    }
}

struct gameBoard_Previews: PreviewProvider {
    static var previews: some View {
        SmallBoard(mode: .twoPlayer, color: .white, board: .constant([1,2,1,0,0,0,0,0,0]), tap: { _ in })
    }
}
