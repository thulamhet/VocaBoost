//
//  HomeView.swift
//  VocaBoost
//
//  Created by Nguyễn Công Thư on 27/2/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if let image = viewModel.avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(100)
                    }
                    VStack {
                        Text(viewModel.user?.fullName ?? "").bold()
                        Text(viewModel.user?.email ?? "").bold()
                    }
                }.padding(15)
                
                Spacer()
                
                TextField("input your fucking word", text: $viewModel.dataInput).padding()
                
                List(viewModel.vocabulary) { word in
                    HStack {
                        Button(action: {
                            viewModel.selectedWord = word
                        }) {
                            Text(word.name + " " + (word.phonetic ?? "")).foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "mic.fill")
                            .font(.none)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                viewModel.speak(word.name)
                            }
                    }
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .task {
                    Task {
                        await viewModel.fetchVocabulary()
                    }
                }
                .sheet(item: $viewModel.selectedWord, content: { item in
                    DetailWordView(word: viewModel.selectedWord).presentationDetents([.medium])
                })
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        HStack {
                            Button("reload") {
                                viewModel.getUserInfor()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("google signin") {
                                Task {
                                    await viewModel.googleSignIn()
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                        HStack {
                            Button("insert") {
                                Task {
                                    await viewModel.insertVocab()
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            
                            Button("inquiry") {
                                Task {
                                    await viewModel.refreshToken()
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
    }
    
    private func onAppear() {
        Task {
            await viewModel.refreshToken()
        }
    }
    
}

#Preview {
    HomeView(viewModel: .init())
}
