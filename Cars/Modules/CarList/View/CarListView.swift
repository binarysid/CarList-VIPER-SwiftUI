//
//  ContentView.swift
//  Cars
//
//  Created by Linkon Sid on 16/12/22.
//

import SwiftUI
import AlertToast

struct CarListView: View {
    @ObservedObject var adapter: CarListViewAdapter

    var body: some View {
        NavigationView {
            ZStack {
                background()
                loader()
                itemList()
            }
            .toast(isPresenting: $adapter.state.viewError, duration: 3) {
                AlertToast(type: .regular, title: AppConstants.ErrorMessage.defaultError)
                    }
            .navigationBarTitle(Text(AppConstants.Text.appTitle))
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
