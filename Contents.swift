import UIKit

class Node<T> {
    var next: Node<T>?
    var previous: Node<T>?
    var key:T
    var value:T
    
    init(withKey key: T, value: T) {
        self.key = key
        self.value = value
    }
}

class LRU {
    
    private var head: Node<Int>
    private var tail: Node<Int>
    private var capicity: Int
    private var count = 0
    private var cache: [Int: Node<Int>] = [:]
    init(withCapicity capicity:Int) {
        self.capicity = capicity
        self.head = Node<Int>(withKey: Int.min, value: Int.max)
        self.tail = Node<Int>(withKey: Int.min, value: Int.max)
        self.head.next = tail
        self.tail.previous = head
    }

    func remove(_ node: Node<Int>) {
        node.next?.previous = node.previous
        node.previous?.next = node.next
    }
    
    func moveToHead(_ node: Node<Int>) {
        remove(node)
        add(node)
    }
    
    func getNode(_ node: Node<Int>)-> Int {
        guard let searchedNode = cache[node.key] else {
            return -1
        }
        moveToHead(node)
        return searchedNode.value
    }
    
    func add(_ node: Node<Int>) {
        node.next = head.next
        node.previous = head
        
        head.next?.previous = node
        head.next?.next = node
    }
    
    func put( _ node: Node<Int>) {
        if let searchedNode = cache[node.key] {
            searchedNode.value = node.value
            moveToHead(searchedNode)
        }
        let newNode = Node(withKey: node.key, value: node.value)
        if count == capicity {
            count -= 1
        }
        if let pre = tail.previous {
            remove(pre)
            cache[pre.key] = nil
        }
        count += 1
        add(newNode)
    }
}
let lruTest = LRU(withCapicity: 3)
lruTest.put(Node<Int>(withKey: 1, value: 1))
lruTest.put(Node<Int>(withKey: 2, value: 2))
lruTest.put(Node<Int>(withKey: 3, value: 3))
lruTest.put(Node<Int>(withKey: 4, value: 4))
