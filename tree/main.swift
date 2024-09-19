//let tree = BinaryTree()
//
//for element in [7, 4, 1, 2, 9, 0, 10, 4, 5, 17, 14, 21, 12, 39, 40, 10, 24, 35] {
//    tree.insert(key: element)
//}
//
//tree.printFrom(node: tree.root)
//tree.delete(key: 5)
//tree.printFrom(node: tree.root)

print("_-------------------------------------")
let treeAVL = AVLTree()

for element in [7, 4, 1, 2, 9, 0, 5, 11, 78, 17, 14, 21, 12, 39, 40, 10, 24, 35] {
    treeAVL.insert(key: element)
}

treeAVL.printFrom(node: treeAVL.root)
print("_-------------------------------------")
treeAVL.delete(key: 11)
print("_-------------------------------------")
treeAVL.printFrom(node: treeAVL.root)
