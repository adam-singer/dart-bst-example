class Node<Key,Value> {
  Key key; // sorted by key
  Value val; // assocated data
  Node<Key,Value> left, right; // left and right subtrees
  num N; // number of nodes in subtree
  Node(this.key, this.val, this.N);
}
