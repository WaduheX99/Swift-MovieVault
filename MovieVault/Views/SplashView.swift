//
//  SplashView.swift
//  MovieVault
//
//  Created by Faza Faresha Affandi on 23/05/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                MainView()
            } else {
                VStack {
                    Spacer()

                    Image("MV_Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 240)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
