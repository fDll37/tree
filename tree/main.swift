let tree = BinaryTree()

for element in [7, 4, 1, 2, 9, 0, 10, 4, 5] {
    tree.insert(key: element)
}

tree.printFrom(node: tree.root)
tree.delete(key: 5)
tree.printFrom(node: tree.root)
