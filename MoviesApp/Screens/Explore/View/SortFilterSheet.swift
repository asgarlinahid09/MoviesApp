//
//  SortFilterSheet.swift
//  MoviesApp
//
//  Created by Nahid Askerli on 25.09.26.
//

import SwiftUI

struct SortFilterSheet: View {
    @Bindable var viewModel: ExploreViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            sheetTitle
            filterSections
            actionButtons
        }
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
    }

   

    private var sheetTitle: some View {
        Text("Sort & Filter")
            .font(.headline)
            .foregroundStyle(.red)
            .padding(.top, 20)
    }



    private var filterSections: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                genreSection
                timePeriodsSection
                sortSection
            }
        }
    }

    private var genreSection: some View {
        filterSection(title: "Genre") {
            scrollingChips(viewModel.genres.map(\.name)) { name in
                viewModel.selectedGenre?.name == name
            } onTap: { name in
                if viewModel.selectedGenre?.name == name {
                    viewModel.selectedGenre = nil
                } else {
                    viewModel.selectedGenre = viewModel.genres.first { $0.name == name }
                }
            }
        }
    }

    private var timePeriodsSection: some View {
        filterSection(title: "Time Periods") {
            scrollingChips(["All Periods"] + viewModel.availableYears.map(String.init)) { label in
                label == "All Periods" ? viewModel.selectedYear == nil : Int(label) == viewModel.selectedYear
            } onTap: { label in
                viewModel.selectedYear = (label == "All Periods") ? nil : Int(label)
            }
        }
    }

    private var sortSection: some View {
        filterSection(title: "Sort") {
            scrollingChips(["Popularity", "Latest Release"]) { label in
                (label == "Popularity" && viewModel.selectedSort == .popularityDescending) ||
                (label == "Latest Release" && viewModel.selectedSort == .releaseDateDescending)
            } onTap: { label in
                let option: DiscoverSortOption = (label == "Popularity") ? .popularityDescending : .releaseDateDescending
                viewModel.selectedSort = (viewModel.selectedSort == option) ? nil : option
            }
        }
    }

    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            resetButton
            applyButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private var resetButton: some View {
        Button {
            Task {
                await viewModel.resetFilter()
                dismiss()
            }
        } label: {
            Text("Reset")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.1))
                .foregroundStyle(.red)
                .clipShape(Capsule())
        }
    }

    private var applyButton: some View {
        Button {
            Task {
                await viewModel.applyFilter()
                dismiss()
            }
        } label: {
            Text("Apply")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }


    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline.bold())
                .padding(.horizontal, 20)
            content()
        }
    }

    private func scrollingChips(_ items: [String], isSelected: @escaping (String) -> Bool, onTap: @escaping (String) -> Void) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Button {
                        onTap(item)
                    } label: {
                        Text(item)
                            .font(.caption.bold())
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(isSelected(item) ? Color.red : Color.white)
                            .foregroundStyle(isSelected(item) ? .white : .red)
                            .overlay(
                                Capsule().stroke(Color.red.opacity(isSelected(item) ? 0 : 0.4), lineWidth: 1)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
