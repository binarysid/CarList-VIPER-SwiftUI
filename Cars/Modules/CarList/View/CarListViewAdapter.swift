//
//  CarAdapter.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import SwiftUI
import Combine

// Adapter for updating view state and connecting to presenter
final class CarListViewAdapter: ObservableObject {
    @Published var state: CarListViewState
    var presenter: CarListViewInput?

    init(state: CarListViewState) {
        self.state = state
    }

    func fetchList() async {
        await presenter?.fetchCarList()
    }
}

// MARK: - View Output
extension CarListViewAdapter: CarListViewOutput {
    func showLoader() {
        Task {
            await MainActor.run {
                state.viewLoader = true
            }
        }
    }

    func hideLoader() {
        Task {
            await MainActor.run {
                state.viewLoader = false
            }
        }
    }

    // show error message
    func update(error: String) {
        Task {
            await MainActor.run {
                state.viewError = true
                state.errorMessage = error
            }
        }
    }

    // update list
    func update(data: [CarViewData]) {
        Task {
            await MainActor.run {
                state.viewObject = data
            }
        }
    }
}

// MARK: - Navigation
extension CarListViewAdapter {
    func navigationRouteBuilder<Content: View>(
        from data: CarViewData,
        @ViewBuilder content: () -> Content
      ) -> some View {
        NavigationLink(
            destination: buildDetailView(with: data)) {
              content()
        }
    }

    private func buildDetailView(with data: CarViewData) -> some View {
        guard let detailView = presenter?.makeDetailView(with: data) else { return AnyView(EmptyView()) }
        return AnyView(detailView)
    }
}
