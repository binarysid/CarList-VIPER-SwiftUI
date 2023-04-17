//
//  ContentView.swift
//  Cars
//
//  Created by Linkon Sid on 16/12/22.
//

import SwiftUI

struct CarListView: View {
    @ObservedObject var adapter: CarListViewAdapter

    var body: some View {
        NavigationView {
            ZStack {
                background()
                loader()
                itemList()
            }
            .alert(TextConstant.Error.default, isPresented: $adapter.state.viewError, actions: {
            })
            .navigationBarTitle(Text(TextConstant.appTitle))
        }
        .task {
            await adapter.fetchList()
        }
    }
}

extension CarListView {
    func itemList() -> some View {
        List(adapter.state.viewObject) { data in
            adapter.navigationRouteBuilder(from: data, content: {
                CarCell(data: data)
            })
            .listRowBackground(Color.clear)
            .listRowInsets(.init())
            .padding([.bottom, .top])
        }
        .background(Color.clear)
        .listStyle(PlainListStyle())
    }

    func background() -> some View {
        Color.black
            .ignoresSafeArea()
    }

    func loader() -> some View {
        ProgressLoader(tintColor: .white, scaleSize: 2.0).padding(.bottom, 50).hidden(!adapter.state.viewLoader)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CarListRouter.createModule()
    }
}
