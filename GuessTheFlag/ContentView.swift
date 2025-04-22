//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Дарья Яцынюк on 06.04.2023.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
    Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var animationAmount = 0.0
    @State private var wasTapped: Int? = nil
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var eightQuestion = false
    @State private var endGameTitle = ""
    
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var howMuchFlagTapped = 0
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .titleStyle()
                    //.font(.largeTitle.weight(.bold))
                            //.foregroundColor(.white)
                
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation {
                                  wasTapped = number
                                  animationAmount += 360
                                }
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                        .rotation3DEffect(.degrees(number == wasTapped ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(wasTapped != nil && number != wasTapped ? 0.25 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert(endGameTitle, isPresented: $eightQuestion) {
            Button("New game", action: reset)
        } message: {
            Text("Your score is \(score)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
        howMuchFlagTapped += 1
    }
    
    func checkHowMuchFlagTapped() {
        if howMuchFlagTapped == 8 {
            eightQuestion = true
            endGameTitle = "Game over!"
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        checkHowMuchFlagTapped()
        animationAmount = 0
        wasTapped = nil
    }
    
    
    func reset() {
        score = 0
        howMuchFlagTapped = 0
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
