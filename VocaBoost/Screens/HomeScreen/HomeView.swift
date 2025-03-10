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
            CustomBackgroundView().ignoresSafeArea()
            VStack {
                GilroyText("VocaBoost", fontSize: 40, weight: .bold)
                    .foregroundStyle(LinearGradient(colors: [.customGrayLight, .customGrayMedium], startPoint: .top, endPoint: .bottom))
                
                TextField("input your fucking word", text: $viewModel.dataInput)
                    .padding(20)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                
                List(viewModel.vocabulary) { word in
                    HStack {
                        Button(action: {
                            viewModel.selectedWord = word
                        }) {
                            GilroyText(word.name + " " + (word.phonetic ?? "")).foregroundColor(.black)
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
                            Button(action: {
                                Task {
                                    await viewModel.googleSignIn()
                                }
                            }) {
                                HStack {
                                    Image("google")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    
                                    GilroyText("Sign in with Google", fontSize: 15, color: .white)
                                }
                                .frame(height: 50)
                                .padding(.horizontal, 20)
                                .background(Color.customGrayLight)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                Task {
                                    await viewModel.insertVocab()
                                }
                            }) {
                                GilroyText("Insert", fontSize: 15, color: .white)
                                    .foregroundColor(.white)
                            }
                            .frame(height: 50)
                            .padding(.horizontal, 20)
                            .background(Color.customGrayLight)
                            .cornerRadius(10)
                        }
                    }
                }
            }.onTapGesture {
                hideKeyboard()
            }
            ErrorPopupView()
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail Screen")
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeView(viewModel: .init())
}
