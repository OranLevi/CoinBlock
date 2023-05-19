//
//  SearchBarView.swift
//  CoinBlock
//
//  Created by Oran Levi on 18/05/2023.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            TextField("Serach", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .keyboardType(.asciiCapable)
                .overlay (
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.accent)
                        .padding()
                        .offset(x:10)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
            
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.dark)
        }      .previewLayout(.sizeThatFits)
        
    }
}
