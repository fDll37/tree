final class Treap {
    
    var x: Int
    var y: Int
    var left: Treap?
    var right: Treap?
    var middle: Treap?
    
    static var random: Int { Int.random(in: 0...12345) }
    
    init(x: Int, y: Int = -1, left: Treap? = nil, right: Treap? = nil) {
        self.y = y == -1 ? Treap.random % 100 : y
        self.x = x
        self.left = left
        self.right = right
    }
    
    static func merge(left: Treap?, right: Treap?) -> Treap? {
        if left == nil { return right }
        if right == nil { return left }
        
        if left!.y > right!.y {
            let newRight = merge(left: left?.right, right: right)
            return Treap(x: left!.x, y: left!.y, left: left?.left, right: newRight)
        } else {
            let newLeft = merge(left: left, right: right?.left)
            return Treap(x: right!.x, y: right!.y, left: newLeft, right: right?.right)
        }
    }
    
    func add(x: Int) -> Treap? {
        split(x: x, left: &left, right: &right)
        middle = Treap(x: x, y: Treap.random)
        return Treap.merge(left: (Treap.merge(left: left, right: middle)), right: right)
    }
    
    func remove(x: Int) -> Treap? {
        split(x: x - 1, left: &left, right: &right)
        right?.split(x: x, left: &middle, right: &right)
        return Treap.merge(left: left, right: right)
    }
    
    func split(x: Int, left: inout Treap?, right: inout Treap?) {
        var newTree: Treap? = nil
        
        if self.x <= x {
            if self.right == nil {
                right = nil
            } else {
                self.right?.split(x: x, left: &newTree, right: &right)
            }
            left = Treap(x: self.x,y: y,left: self.left, right: newTree)
        } else {
            if self.left == nil {
                left = nil
            } else {
                self.left?.split(x: self.x, left: &left, right: &newTree)
            }
            right = Treap(x: self.x, y: y, left: newTree, right: self.right)
        }
    }
    
    
    
    
}
