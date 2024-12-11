import Foundation

final class SplayNode: Equatable {
    
    static func == (lhs: SplayNode, rhs: SplayNode) -> Bool {
        lhs.key == rhs.key
    }
    
    var key: Int
    var left: SplayNode?
    var right: SplayNode?
    var height: Int = 0
    
    init(key: Int) {
        self.key = key
    }
}



final class SplayTree {
    
    var root: SplayNode? = nil
    
    func splayInsert(key: Int) {
        let currentNode = insert(key: key)
        var parent = searchParent(node: currentNode, search: root)
        
        while parent != nil {
            let grand = searchParent(node: parent, search: root)
            
            if parent?.left == currentNode {
                let node = minRightRotate(node: parent!)
                
                if grand != nil {
                    if grand?.left == parent {
                        grand?.left = node
                    } else {
                        grand?.right = node
                    }
                }
            } else {
                let node = minLeftRotate(node: parent!)
                
                if grand != nil {
                    if grand?.left == parent {
                        grand?.left = node
                    } else {
                        grand?.right = node
                    }
                }
            }
            parent = grand
        }
    }
    
    private func insert(key: Int, current: SplayNode? = nil) -> SplayNode {
        let treeNode = SplayNode(key: key)
        var currentNode = current
        
        guard root != nil else {
            self.root = treeNode
            return treeNode
        }
        
        if currentNode == nil {
            currentNode = root
        }
        
        if key < currentNode!.key {
            if currentNode?.left == nil {
                currentNode?.left = treeNode
            } else {
                return insert(key: key, current: currentNode?.left)
            }
        } else {
            if currentNode?.right == nil {
                currentNode?.right = treeNode
            } else {
                return insert(key: key, current: currentNode?.right)
            }
        }
        
        return treeNode
    }
    
    func search(key: Int, node: SplayNode? = nil) -> SplayNode? {
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
    
    private func remove(node: SplayNode?) {
        
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
    
    private func searchParent(node: SplayNode?, search: SplayNode?) -> SplayNode? {
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
    
    func printFrom(node: SplayNode?) {
        
        guard let node = node else { return }
        printFrom(node: node.left)
        NSLog("\(node.key)")
        printFrom(node: node.right)
        return
    }
    
}


extension SplayTree {
    
    func balance(node: SplayNode? = nil) -> SplayNode? {
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
    
    func updateHeight(node: SplayNode?) {
        guard let node = node else { return }
        
        let left = node.left == nil ? -1 : node.left!.height
        let right = node.right == nil ? -1 : node.right!.height
        node.height = 1 + max(left, right)
    }
    
    func minLeftRotate(node: SplayNode) -> SplayNode {
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
    
    func minRightRotate(node: SplayNode) -> SplayNode {
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
    
    func maxLeftRotate(node: SplayNode) -> SplayNode {
        var currentNode = node
        currentNode.right = minRightRotate(node: currentNode.right!)
        currentNode = minLeftRotate(node: currentNode)
        
        updateHeight(node: currentNode)
        return currentNode
    }
    
    func maxRightRotate(node: SplayNode) -> SplayNode {
        var currentNode = node
        currentNode.left = minLeftRotate(node: currentNode.left!)
        currentNode = minRightRotate(node: currentNode)
        
        updateHeight(node: currentNode)
        return currentNode
    }
}


