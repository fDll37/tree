import Foundation

final class AVLNode: Equatable {
    
    static func == (lhs: AVLNode, rhs: AVLNode) -> Bool {
        lhs.key == rhs.key
    }
    
    var key: Int
    var left: AVLNode?
    var right: AVLNode?
    var height: Int = 0
    
    init(key: Int) {
        self.key = key
    }
}

protocol BalanceProtocol {
    func updateHeight(node: AVLNode?)
    func minLeftRotate(node: AVLNode) -> AVLNode
    func minRightRotate(node: AVLNode) -> AVLNode
    func maxLeftRotate(node: AVLNode) -> AVLNode
    func maxRightRotate(node: AVLNode) -> AVLNode
    func balance(node: AVLNode?) -> AVLNode?
}


final class AVLTree {
    
    var root: AVLNode? = nil
    
    func insert(key: Int, current: AVLNode? = nil) {
        let treeNode = AVLNode(key: key)
        var currentNode = current
        
        guard root != nil else {
            self.root = treeNode
            return
        }
        
        if currentNode == nil {
            currentNode = root
        }
        
        if key < currentNode!.key {
            if currentNode?.left == nil {
                currentNode?.left = treeNode
            } else {
                insert(key: key, current: currentNode?.left)
            }
        } else {
            if currentNode?.right == nil {
                currentNode?.right = treeNode
            } else {
                insert(key: key, current: currentNode?.right)
            }
        }
    }
    
    func search(key: Int, node: AVLNode? = nil) -> AVLNode? {
        guard root != nil else {return  nil}
        var currentNode = node
        
        if currentNode == nil {
            currentNode = root
        }
        
        if key == currentNode?.key {
            return node
        }
        
        if key < currentNode!.key {
            return search(key: key, node: currentNode?.left)
        }
        return search(key: key, node: currentNode?.right)
        
    }
    
    func delete(key: Int) {
        let node = search(key: key)
        guard node != nil else { return }
        remove(node: node)
    }
    
    private func remove(node: AVLNode?) {
        
        let parent = searchParent(node: node, search: root)
        var node = node
        if node?.right == nil {
            if parent != nil {
                if parent?.left == node {
                    parent?.left = node?.left
                } else {
                    parent?.right = node?.left
                }
            } else {
                root = node?.left
                return
            }
        }
        
        var min = node?.right
        var minParent = node
        
        while min?.left != nil {
            minParent = min
            min = min?.left
        }
        
        if parent != nil {
            if parent?.left == node {
                parent?.left = min
            } else {
                parent?.right = min
            }
        } else {
            root = min
        }
        
        if min != node?.right {
            minParent?.left = min?.right
            min?.right = node?.right
        }
        
        min?.left = node?.left
        
        if node == minParent {
            node = min
        } else {
            node = minParent
            
            repeat {
                updateHeight(node: node)
                if node == nil { break }
                if node?.left != nil {
                    node?.left = balance(node: node?.left)
                }
                if node?.right != nil {
                    node?.right = balance(node: node?.right)
                }
                
                node = searchParent(node: node, search: root)
            } while node != nil
        }
    }
    
    private func searchParent(node: AVLNode?, search: AVLNode?) -> AVLNode? {
        guard node != nil else {
            return nil
        }
        
        guard search != nil else {
            return nil
        }
        
        if search?.left != nil {
            if node?.key == search?.left?.key {
                return search
            }
        }
        
        if search?.right != nil {
            if node?.key == search?.right?.key {
                return search
            }
        }
        
        if node!.key < search!.key {
            return searchParent(node: node, search: search?.left)
        }
        
        return searchParent(node: node, search: search?.right)
    }
    
    func printFrom(node: AVLNode?) {
        
        guard let node = node else { return }
        printFrom(node: node.left)
        NSLog("\(node.key)")
        printFrom(node: node.right)
        return
    }
    
}


extension AVLTree: BalanceProtocol {
    
    func balance(node: AVLNode? = nil) -> AVLNode? {
        guard var node = node else {
            return nil
        }
        
        print("balance for \(node.key)")
        
        let left = node.left == nil ? -1 : node.left!.height
        let right = node.right == nil ? -1 : node.right!.height
        let balance = left - right
        
        if abs(balance) < 2 {
            return node
        }
        
        if balance > 1 {
            guard let b = node.left else { return nil }
            let left = b.left == nil ? -1 : b.left!.height
            let right = b.right == nil ? -1 : b.right!.height
            
            if left - right >= 0 {
                node = minRightRotate(node: node)
            } else {
                node = maxRightRotate(node: node)
            }
        } else {
            guard let b = node.right else { return nil }
            let left = b.left == nil ? -1 : b.left!.height
            let right = b.right == nil ? -1 : b.right!.height
            
            if left - right <= 0 {
                node = minLeftRotate(node: node)
            } else {
                node = maxLeftRotate(node: node)
            }
        }
        
        if let parent = searchParent(node: node, search: root) {
                updateHeight(node: parent)
        }
        
        return node
    }
    
    func updateHeight(node: AVLNode?) {
        guard let node = node else { return }
        
        let left = node.left == nil ? -1 : node.left!.height
        let right = node.right == nil ? -1 : node.right!.height
        node.height = 1 + max(left, right)
    }
    
    func minLeftRotate(node: AVLNode) -> AVLNode {
        let b = node.right
        node.right = b?.left
        b?.left = node
        
        if root == node {
            root = b
        }
        
        updateHeight(node: node)
        updateHeight(node: b)
        
        return b!
    }
    
    func minRightRotate(node: AVLNode) -> AVLNode {
        let b = node.left
        node.left = b?.right
        b?.right = node
        
        if root == node {
            root = b
        }
        
        updateHeight(node: node)
        updateHeight(node: b)
        
        return b!
    }
    
    func maxLeftRotate(node: AVLNode) -> AVLNode {
        var currentNode = node
        currentNode.right = minRightRotate(node: currentNode.right!)
        currentNode = minLeftRotate(node: currentNode)
        
        updateHeight(node: currentNode)
        return currentNode
    }
    
    func maxRightRotate(node: AVLNode) -> AVLNode {
        var currentNode = node
        currentNode.left = minLeftRotate(node: currentNode.left!)
        currentNode = minRightRotate(node: currentNode)
        
        updateHeight(node: currentNode)
        return currentNode
    }
}


