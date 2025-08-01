//
//  ContentView.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//
import SwiftUI
import Observation

struct NewsResponse: Codable {
    let articles: [News]
}

struct News: Codable, Identifiable {
    var id: String { title }
    let title: String
    let description: String
    let content: String
    let image: String
    let publishedAt: String
}

struct HomeView: View {
    @Environment(ApplicationData.self) private var appData

    var body: some View {
        NavigationView {
            List(appData.userData) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack {
                        HStack {
                            CellEvent(event: event)
                        }
                    }
                }
                .navigationTitle(Text("Event Places"))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView: View {
    @Environment(ApplicationData.self) private var appData

    @ObservedObject var mainViewModel: MainViewModel
    @State private var newsItems: [News] = []
    @State private var displayedNews: [News] = []
    @State private var isLoading = false
    @State private var fetchError = false
    @State private var selectedTab: Int = 1

    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }

    var body: some View {
        ZStack {
            Color.blue.opacity(0.2).ignoresSafeArea()

            TabView(selection: $selectedTab) {
                homeTab
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)

                HomeView()
                    .tabItem {
                        Image(systemName: "newspaper.fill")
                        Text("Events")
                    }
                    .tag(2)

                ProfileView(ProfileViewModel: mainViewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profile")
                    }
                    .tag(1)

                ContactView()
                    .tabItem {
                        Image(systemName: "envelope.fill")
                        Text("Contact")
                    }
                    .tag(3)
            }
        }
    }


    var homeTab: some View {
        ZStack {
            /*Color.blue.opacity(0.5)
                .ignoresSafeArea(edges: .top)
*/
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                    } else if displayedNews.isEmpty && newsItems.isEmpty {
                        Text("Press the button to load news.")
                            .foregroundColor(.black)

                        Button("Get News") {
                            fetchNews()
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    } else {
                        ForEach(displayedNews) { news in
                            ZStack {
                                Color.white.cornerRadius(10)
                                VStack {
                                    if let url = URL(string: news.image) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 350, height: 200)
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(10)
                                    }

                                    Text(news.title)
                                        .font(.headline)

                                    Text(news.description)
                                        .font(.subheadline)
                                    Text("Published at: \(news.publishedAt)")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                                .padding()
                            }
                        }

                        VStack {
                            if newsItems.isEmpty && !displayedNews.isEmpty {
                                Text("No more Articles to be found")
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .font(.title)

                                Button {
                                    selectedTab = 2
                                } label: {
                                    HStack {
                                        Text("See Events in Area")
                                        Image(systemName: "party.popper.fill")
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            }

                            HStack {
                                if !newsItems.isEmpty {
                                    Button("Next") {
                                        showNextOne()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                }

                                Button("Reset") {
                                    newsItems = []
                                    displayedNews = []
                                }
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            }
                        }
                    }

                    if fetchError {
                        Text("Failed to load news.")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80) // ✅ Adds space above TabView
            }
        }
    }

    func fetchNews() {
        isLoading = true
        fetchError = false
        newsItems = []
        displayedNews = []

        guard let url = URL(string: "https://gnews.io/api/v4/top-headlines?country=us&category=entertainment&apikey=c32652854f0f4282e32fef9bba7c11a6") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    fetchError = true
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    newsItems = decoded.articles.shuffled()
                    showNextOne()
                }
            } catch {
                DispatchQueue.main.async {
                    fetchError = true
                }
            }
        }.resume()
    }

    func showNextOne() {
        guard !newsItems.isEmpty else { return }
        let nextOne = Array(newsItems.prefix(3))
        displayedNews = nextOne
        newsItems.removeFirst(min(3, newsItems.count))
    }
}

struct ProfileView: View {
    @ObservedObject var ProfileViewModel: MainViewModel
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            UserProfileView(
                mainViewModel: ProfileViewModel,
                selectedTab: $selectedTab
            )
        }
    }
}

struct Event: Identifiable, Hashable {
    let id = UUID()
    var image: String
    var name: String
    var price: Double
    var Date: String
}

struct CellEvent: View {
    let event: Event

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Image(event.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text(event.name)
                    .font(.headline)

                Text(event.Date)
                    .font(.caption)
            }
            Spacer()
            Text("$\(event.price)")
        }
    }
}

struct EventDetailView: View {
    let event: Event

    var body: some View {
        VStack {
            Image(event.image)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 200)

            Text("Make: \(event.name)")
                .font(.largeTitle)
                .bold()

            Text("Model: \(event.Date)")
                .font(.title2)
                .padding()

            Text("$\(event.price)")
                .font(.title2)
                .padding()
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .top) // ✅ Only top

            VStack(spacing: 20) {
                Text("Contact Me")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .offset(y: 20)
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Submit") {
                    showAlert = true
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()

                Image("cashapp")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .offset(y: -35)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Thank You!"),
                    message: Text("Your message has been sent."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 80) // ✅ Keeps it above TabView
        }
    }
}

#Preview {
    ContentView(mainViewModel: MainViewModel())
        .environment(ApplicationData.shared)
}
