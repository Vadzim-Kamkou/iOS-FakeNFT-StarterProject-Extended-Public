//
//  ProfileEditScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Волошин Александр on 2/9/26.
//
import SwiftUI
import Kingfisher
import ProgressHUD

struct EditProfileScreen: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services
    @State private var showingPhotoDialog = false
    @State private var showingPhotoURLAlert = false
    @State private var newPhotoURLText: String = "https://"
    @State private var showingExitAlert = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack(alignment: .bottomTrailing) {
                        KFImage(URL(string: viewModel.editAvatar))
                            .placeholder {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Button {
                            showingPhotoDialog = true
                        } label: {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color(.systemBackground)))
                        }
                        .offset(x: -4, y: -4)
                    }
                    
                    // Форма
                    VStack(alignment: .leading, spacing: 20) {
                        singleLineField(title: "Имя", text: $viewModel.editName)
                        multiLineField(title: "Описание", text: $viewModel.editDescription)
                        singleLineField(title: "Сайт", text: $viewModel.editWebsite, keyboardType: .URL)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 80)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.hasChanges {
                    Button {
                        Task {
                            await viewModel.saveEditingProfile(using: services.profileService)
                            
                            await MainActor.run {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Сохранить")
                            .font(.bodyBold)
                            .foregroundColor(Color(.systemBackground))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 16)
                    .background(Color(UIColor.systemBackground))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .disabled(viewModel.isLoading)
                } else {
                    Color.clear.frame(height: 20)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.hasChanges)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.hasChanges {
                            showingExitAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.bodyBold)
                            .foregroundColor(Color.primary)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .onAppear {
                viewModel.startEditing()
            }
            .confirmationDialog("Фото профиля", isPresented: $showingPhotoDialog, titleVisibility: .visible) {
                Button("Изменить фото") {
                    showingPhotoURLAlert = true
                }
                Button("Удалить фото", role: .destructive) {
                    viewModel.editAvatar = ""
                }
                Button("Отмена", role: .cancel) {}
            }
            .alert("Ссылка на фото", isPresented: $showingPhotoURLAlert) {
                TextField("https://", text: $newPhotoURLText)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Отмена", role: .cancel) {
                    newPhotoURLText = "https://"
                }
                Button("Сохранить") {
                    if let _ = URL(string: newPhotoURLText), !newPhotoURLText.isEmpty {
                        viewModel.editAvatar = newPhotoURLText
                    }
                    newPhotoURLText = "https://"
                }
            }
            
            .alert("Уверены,\n что хотите выйти?", isPresented: $showingExitAlert) {
                Button("Остаться") {}
                Button("Выйти", role: .cancel) {
                    dismiss()
                }
                
            }
            .interactiveDismissDisabled(viewModel.isLoading)
        }
    }
    @ViewBuilder
    private func singleLineField(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField("", text: text)
                .padding(14)
                .frame(height: 48)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(keyboardType == .URL)
        }
    }
    
    @ViewBuilder
    private func multiLineField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            TextEditor(text: text)
                .frame(minHeight: 100, maxHeight: .infinity)
                .padding(10)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .scrollContentBackground(.hidden)
        }
    }
}
