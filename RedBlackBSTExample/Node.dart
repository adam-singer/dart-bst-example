class Node<Key extends Comparable, Value> {  
  Key key;          // Key
  Value val;        // assocated data
  Node<Key, Value> left, right; // links to left and right subtrees
  bool color;       // color of parent link
  num N;            // subtree count
  
  Node(this.key, this.val, this.color, this.N);
}
