class TreeNode: Equatable {
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.key == rhs.key
    }
    
    var key: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(key: Int) {
        self.key = key
    }
}


class BinaryTree {
    
    var root: TreeNode?
    
    init() {
        self.root = nil
    }
    
    func insert(key: Int, current: TreeNode? = nil) {
        let treeNode = TreeNode(key: key)
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
    
    func search(key: Int, node: TreeNode? = nil) -> TreeNode? {
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
    
    private func remove(node: TreeNode?) {
        let parent = searchParent(node: node, search: root)
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
    }
    
    private func searchParent(node: TreeNode?, search: TreeNode?) -> TreeNode? {
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
    
    func printFrom(node: TreeNode?) {
        guard let node = node else { return }
        
        printFrom(node: node.left)
        print("\(node.key)")
        printFrom(node: node.right)
        return
    }
}
