
import SwiftUI

struct LeaderboardView: View {
    
    @EnvironmentObject var scoreManager: ScoreManager
    
    var sortedScores: [Score] {
        scoreManager.scores.sorted { $0.time < $1.time }
    }
    
    var body: some View {
        
        VStack {
            
            Text("Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if sortedScores.isEmpty {
                
                Text("No scores yet")
                    .foregroundColor(.gray)
                    .padding()
                
            } else {
                
                List {
                    
                    ForEach(sortedScores) { score in
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                Text(score.playerName)
                                    .font(.headline)
                                
                                Text("Difficulty: \(score.difficulty)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("\(score.time)s")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Leaderboard")
    }
}