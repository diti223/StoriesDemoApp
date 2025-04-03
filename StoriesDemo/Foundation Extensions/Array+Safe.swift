//
//  Array+Safe.swift
//  StoriesDemo
//
//  Created by Adrian Bilescu on 03.04.2025.
//


extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
