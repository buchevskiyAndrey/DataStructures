//
//  LinkedList.swift
//  DataStructures
//
//  Created by Бучевский Андрей on 04.02.2024.
//

struct LinkedList<Value> {

    // MARK: - Properties

    var head: Node<Value>?

    var tail: Node<Value>?

    var isEmpty: Bool {
        head == nil
    }

    // MARK: - Methods

    mutating func push(_ value: Value) {
        copyNodes()

        head = Node(value: value, next: head)

        if tail == nil {
            tail = head
        }
    }

    mutating func append(_ value: Value) {
        copyNodes()

        guard !isEmpty else {
            push(value)
            return
        }

        tail?.next = Node(value: value)
        tail = tail?.next
    }

    func node(at index: Int) -> Node<Value>? {
        var currentIndex = 0
        var currentNode = head
        while currentIndex < index, currentNode != nil {
            currentIndex += 1
            currentNode = currentNode?.next
        }
        return currentNode
    }

    @discardableResult
    mutating func insert(after node: Node<Value>, value: Value) -> Node<Value> {
        copyNodes()

        guard node !== tail else {
            append(value)
            return tail!
        }
        node.next = Node(value: value, next: node.next)
        return node.next!
    }

    @discardableResult
    mutating func pop() -> Value? {
        copyNodes()

        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }

        return head?.value
    }

    @discardableResult
    mutating func removeLast() -> Value? {
        copyNodes()

        guard head?.next != nil else {
            return pop()
        }

        defer {
            var currentNode = head
            while currentNode?.next !== tail  {
                currentNode = currentNode?.next
            }
            tail = currentNode
            tail?.next = nil
        }

        return tail?.value
    }

    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }

        defer {
            if node.next === tail {
                tail = node
            }

            node.next = node.next?.next
        }

        return node.next?.value
    }

    public func printInReverse() {
        printInReverse(head)
    }

    public func getMiddle() -> Node<Value>? {
        var slow = head
        var fast = head

        while let fastNext = fast?.next {
            fast = fastNext.next
            slow = slow?.next
        }

        return slow
    }

    mutating public func reverse() {
        guard !isEmpty else { return }

        tail = head
        var current = head?.next
        var previous = head
        previous?.next = nil

        while current != nil {
            let next = current?.next
            current?.next = previous
            previous = current
            current = next
        }
        head = previous
    }
}

// MARK: - Collection

extension LinkedList: Collection {

    struct Index: Comparable {

        var node: Node<Value>?

        static func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }

        static func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }

    var startIndex: Index {
        Index(node: head)
    }

    var endIndex: Index {
        Index(node: tail?.next)
    }

    func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }

    subscript(position: Index) -> Value {
        position.node!.value
    }
}

// MARK: - Private Methods

private extension LinkedList {

    mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head), var oldNode = head else { return }

        var newNode = Node(value: oldNode.value)

        while let nextOldNode = oldNode.next {
            newNode.next = Node(value: nextOldNode.value)
            newNode = newNode.next!

            oldNode = nextOldNode
        }

        tail = newNode
    }

    mutating func copyNodes(returningCopyOf node: Node<Value>?) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&head), var oldNode = head else { return nil  }

        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?

        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }

        return nodeCopy
    }

    private func printInReverse<T>(_ node: Node<T>?) {
        guard let node = node else { return }
        printInReverse(node.next)
        print(node.value)
    }
}

// MARK: - CustomStringConvertible

extension LinkedList: CustomStringConvertible {

    var description: String {
        guard let head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

