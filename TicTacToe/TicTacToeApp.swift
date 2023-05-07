import SwiftUI

let _9zero = Array(repeating: 0, count: 9)
let lines = [[0,3,6], [1,4,7], [2,5,8],   [0,1,2], [3,4,5], [6,7,8],   [0,4,8], [2,4,6]]
let ones = [1,1,1]
let twos = [2,2,2]

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
        }
    }
}
