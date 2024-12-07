import SwiftUI
import Charts

struct ParsingProgressView: View {
    @State private var casesData: [(time: Date, count: Int)] = [] // Данные для графика
    @State private var totalCases = Int.random(in: 100...1000) // Случайное общее число дел
    @State private var parsedCases = 0 // Количество полученных дел
    @State private var startTime = Date() // Время начала процесса
    @State private var timer: Timer? = nil

    var body: some View {
        VStack {
            Text("Получение дел с сайтов судов / проект LawMatic B2")
                .font(.headline)
                .padding()

            Text("Получено дел: \(parsedCases) из \(totalCases)")
                .padding()

            Chart {
                ForEach(casesData, id: \.time) { data in
                    AreaMark(
                        x: .value("Время", data.time),
                        y: .value("Количество дел", data.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .green]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .frame(height: 250)
            .padding()

            Button(parsedCases < totalCases ? "Остановить процесс" : "Начать заново") {
                if parsedCases < totalCases {
                    stopParsing()
                } else {
                    restartParsing()
                }
            }
            .padding()
        }
        .onAppear {
            startParsing()
        }
        .onDisappear {
            stopParsing()
        }
    }

    private func startParsing() {
        startTime = Date()
        parsedCases = 0
        casesData = [(time: startTime, count: 0)]
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            simulateCaseParsing()
        }
    }

    private func stopParsing() {
        timer?.invalidate()
        timer = nil
    }

    private func restartParsing() {
        totalCases = Int.random(in: 100...1000)
        startParsing()
    }

    private func simulateCaseParsing() {
        guard parsedCases < totalCases else {
            stopParsing()
            return
        }

        // Симуляция случайного времени получения дел
        let randomDelay = Double.random(in: 0.1...3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            let randomCases = Int.random(in: 1...5)
            parsedCases = min(parsedCases + randomCases, totalCases)
            casesData.append((time: Date(), count: parsedCases))
        }
    }
}

struct ContentView: View {
    var body: some View {
        ParsingProgressView()
    }
}

struct CourtCasesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
