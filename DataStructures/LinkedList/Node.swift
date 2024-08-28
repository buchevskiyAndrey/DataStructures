//
//  Node.swift
//  DataStructures
//
//  Created by Бучевский Андрей on 04.02.2024.
//

class Node<Value> {

    var value: Value
    var next: Node?

    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {

    var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}
