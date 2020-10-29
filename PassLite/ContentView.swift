//
//  ContentView.swift
//  PassLite
//
//  Created by Oleksandr Yakubchyk on 14.10.2020.
//

import AppKit
import SwiftUI
import PassphraseGenerator

enum ViewState {
    case list
    case addNew
    case settings
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    @State var isPresented = false
    @State var selectedItem: SecuredEntity?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = true
                }) {
                    Text("Add new")
                }.padding().sheet(isPresented: .init(get: {
                    self.selectedItem != nil || isPresented
                }, set: { _ in
                    self.selectedItem = nil
                    self.isPresented = false
                }), content: {
                    AddNewItemView(itemId: selectedItem?.id, item: selectedItem, presenting: $isPresented).environment(\.managedObjectContext, context)
                })
            }
            ListView(selectedItem: $selectedItem)
        }.frame(width: 350, height: 300)
    }
    
    func shouldBeEditViewVisible(item: SecuredEntity?) -> Bool {
        return item != nil
    }
}

struct ListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: SecuredEntity.getAllItems()) var items: FetchedResults<SecuredEntity>
    
    @Binding var selectedItem: SecuredEntity?
    
    var body: some View {
        HStack {
            List(items, id: \.self, selection: $selectedItem) { item in
                TestRow(name: item.name)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }

    }
}

struct TestRow: View {

    var name: String
    
    var body: some View {
        HStack {
            Text(name)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
