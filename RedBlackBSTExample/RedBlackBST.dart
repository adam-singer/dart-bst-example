class RedBlackBST<Key extends Comparable, Value> {
  static final RED = true;
  static final BLACK = false; 
  
  Node<Key,Value> root;
  
  //
  // Node helper methods
  //
  
  // is node x red; false if x is null ?
  bool isRed(Node<Key, Value> x) {
    if (x is Node<Key, Value> && x.color == RED) {
      return true;
    } else {
      return false;
    }
  }
  
  // number of node in subtree rooted at x; 0 if x is null
  int sizeWithNode(Node<Key, Value> x) {
    if (x is Node<Key, Value>) {
      return x.N;
    } else {
      return 0;
    }
  }
  
  //
  // Size Methods
  //
  // return number of key-value pairs in this symbol table
  int size() {
    return sizeWithNode(root); 
  }
  
  // is this symbol table empty?
  bool isEmpty() {
    return !(root is Node<Key, Value>);
  }
  
  //
  // Standard BST search
  //
  // value associated with the given key; null if no such key
  Value getValue(Key key) {
    return getValueWithNode(root, key);
  }
  
  // value associated with given key in subtree rooted at x; null if no such key
  Value getValueWithNode(Node<Key, Value> x, Key key) {
    while (x is Node<Key, Value>) {
      int cmp = key.compareTo(x.key);
      if (cmp < 0) {
        x = x.left;
      } else if (cmp > 0) {
        x = x.right;
      } else {
        return x.val;
      }
    }
    
    return null;
  }
  
  // is there a key-value pair with the given key?
  bool contains(Key key) {
    return getValue(key) is Value;
  }
  
  // is there a key-value pair with the given key in the subtree rooted at x?
  bool containsWithNode(Node<Key, Value> x, Key key) {
    return getValueWithNode(x, key) is Value;
  }
  
  //
  // Red-black insertion
  // 
  void put(Key key, Value val) {
    root = putWithNode(root, key, val);
    root.color = BLACK;
    assert(check());
  }
  
  Node<Key, Value> putWithNode(Node<Key, Value> h, Key key, Value val) {
    if (!(h is Node<Key, Value>)) {
      return new Node<Key, Value>(key, val, RED, 1);
    }
    
    int cmp = key.compareTo(h.key);
    if (cmp < 0) {
      h.left = putWithNode(h.left, key, val);
    } else if (cmp > 0) {
      h.right = putWithNode(h.right, key, val);
    } else {
      h.val = val;
    }
    
    // fix-up any right-leaning links
    if (isRed(h.right) && !isRed(h.left)) {
      h = rotateLeft(h);
    }
    
    if (isRed(h.left) && isRed(h.left.left)) {
      h = rotateRight(h);
    }
    
    if (isRed(h.left) && isRed(h.right)) {
      flipColors(h);
    }
    
    h.N = sizeWithNode(h.left) + sizeWithNode(h.right) + 1;
    
    return h;
  }
  
  // 
  // Red-black deletion
  // 
  void deleteMin() {
    if (isEmpty()) {
      throw new Exception("BST underflow");    
    }
    
    // if both children of root are black, set root to red
    if (!isRed(root.left) && !isRed(root.right)) {
      root.color = RED;
    }
    
    root = deleteMinWithNode(root);
    if (!isEmpty()) {
      root.color = BLACK;
    }
    
    assert(check());
  }
  
  // delete the key-value pair with the minimum key rooted at h
  Node<Key, Value> deleteMinWithNode(Node<Key, Value> h) {
    if (!(h.left is Node<Key, Value>)) {
      return null;
    }
    
    if (!isRed(h.left) && !isRed(h.left.left)) {
      h = moveRedLeft(h);
    }
    
    h.left = deleteMinWithNode(h.left);
    return balance(h);
  }
  
  // delete the key-value pair with the maximum key
  void deleteMax() {
    if (isEmpty()) {
      throw new Exception("BST underflow");
    }
    
    // if both children of root are black, set root to red
    if (!isRed(root.left) && !isRed(root.right)) {
      root.color = RED;
    }
    
    root = deleteMaxWithNode(root);
    if (!isEmpty()) {
      root.color = BLACK;
    }
    
    assert(check());
  }
  
  // delete the key-value pair with the maximum key rooted at h
  Node<Key, Value> deleteMaxWithNode(Node<Key, Value> h) {
    if (isRed(h.left)) {
      h = rotateRight(h);
    }
    
    if (!(h.right is Node<Key, Value>)) {
      return null;
    }
    
    if (!isRed(h.right) && !isRed(h.right.left)) {
      h = moveRedRight(h);
    }
    
    h.right = deleteMaxWithNode(h.right);
    
    return balance(h);
  }
  
  // delete the key-value pair with the given key
  void delete(Key key) {
    if (!contains(key)) {
      print('symbol table does not contain ' + key);
      return;
    }
    
    // if both children of root are black, set root to red
    if (!isRed(root.left) && !isRed(root.right)) {
      root.color = RED;
    }
    
    root = deleteWithNode(root, key);
    if (!isEmpty()) {
      root.color = BLACK;
    }
    
    assert(check());
  }
  
  // delete the key-value pair with the given key rooted at h
  Node<Key, Value> deleteWithNode(Node<Key, Value> h, Key key) {
    assert(containsWithNode(h,key));
    
    if (key.compareTo(h.key) < 0) {
      if (!isRed(h.left) && !isRed(h.left.left)) {
        h = moveRedLeft(h);
      }
      
      h.left = deleteWithNode(h.left, key);
    } else {
      if (isRed(h.left)) {
        h = rotateRight(h);
      }
      
      if (key.compareTo(h.key) == 0 && !(h.right is Node<Key, Value>)) {
        return null;
      }
      
      if (!isRed(h.right) && !isRed(h.right.left)) {
        h = moveRedRight(h);
      }
      
      if (key.compareTo(h.key) == 0) {
        h.val = getValueWithNode(h.right, minWithNode(h.right).key);
        h.key = minWithNode(h.right).key;
        h.right = deleteMinWithNode(h.right);
      } else {
        h.right = deleteWithNode(h.right, key);
      }   
    }
    
    return balance(h);
  }
  
  //
  // red-black tree helper functions
  //
  // make a left-leaning link lean to the right
  Node<Key,Value> rotateRight(Node<Key,Value> h) {
    assert(h is Node); 
    assert(isRed(h.left));
    Node<Key, Value> x = h.left;
    h.left = x.right;
    x.right = h;
    x.color = x.right.color;
    x.right.color = RED;
    x.N = h.N;
    h.N = sizeWithNode(h.left) + sizeWithNode(h.right) + 1;
    return x;
  }
  
  // make a right-leaning link lean to the left
  Node<Key, Value> rotateLeft(Node<Key, Value> h) {
    assert((h is Node) && isRed(h.right));
    Node<Key, Value> x = h.right;
    h.right = x.left;
    x.left = h;
    x.color = x.left.color;
    x.left.color = RED;
    x.N = h.N;
    h.N = sizeWithNode(h.left) + sizeWithNode(h.right) + 1;
    return x;
  }
  
  // flip the colors of a node and its two children
  void flipColors(Node<Key, Value> h) {
    // h must have opposite color of its two children
    assert((h is Node) && 
        (h.left is Node) && 
        (h.right is Node));
    
    assert((!isRed(h) && isRed(h.left) && isRed(h.right)) 
        ||
        (isRed(h) && !isRed(h.left) && !isRed(h.right)));
    
    h.color = !h.color;
    h.left.color = !h.left.color;
    h.right.color = !h.right.color;
  }
  
  // Assuming that h is red and both h.left and h.left.left 
  // are black, make h.left or one of its children red.
  Node<Key, Value> moveRedLeft(Node<Key, Value> h) {
    assert(h is Node);
    assert(isRed(h) && !isRed(h.left) && !isRed(h.left.left));
    
    flipColors(h);
    if (isRed(h.right.left)) {
      h.right = rotateRight(h.right);
      h = rotateLeft(h);
    }
    return h;
  }
  
  // Assuming that h is red and both h.right and h.right.left
  // are black, make h.right or one of its children red. 
  Node<Key, Value> moveRedRight(Node<Key, Value> h) {
    assert(h is Node);
    assert(isRed(h) && !isRed(h.right) && !isRed(h.right.left));
    
    flipColors(h);
    if (isRed(h.left.left)) {
      h = rotateRight(h);
    }
    
    return h;
  }
  
  // restore red-black tree invariant
  Node<Key, Value> balance(Node<Key, Value> h) {
    assert(h is Node);
    if (isRed(h.right)) {
      h = rotateLeft(h);
    }
    
    if (isRed(h.left) && isRed(h.left.left)) {
      h = rotateRight(h);
    }
    
    if (isRed(h.left) && isRed(h.right)) {
      flipColors(h);
    }
    
    h.N = sizeWithNode(h.left) + sizeWithNode(h.right) + 1;
    return h;
  }
  
  // 
  // Utility functions
  // 
  // height of tree; 0 if empty
  int height() {
    return heightWithNode(root);
  }
  
  int heightWithNode(Node<Key, Value> x) {
    if (!(x is Node<Key, Value>)) {
      return 0;
    }
    
    return 1 + Math.max(heightWithNode(x.left), heightWithNode(x.right));
  }
  
  //
  // Ordered symbol table methods
  //
  // the smallest key; null if no such key
  Key min() {
    if (isEmpty()) {
      return null;
    }
    
    return minWithNode(root).key;
  }
  
  // the smallest key in subtree rooted at x; null if no such key
  Node<Key, Value> minWithNode(Node<Key, Value> x) {
    assert(x is Node);
    
    if (!(x.left is Node<Key, Value>)) {
      return x;
    } else {
      return minWithNode(x.left);
    }
  }
  
  // the largest key; null if no such key
  Key max() {
    if (isEmpty()) {
      return null;
    } else {
      return maxWithNode(root).key;
    }
  }
  
  // the largest key in the subtree rooted at x; null if no such key
  Node<Key, Value> maxWithNode(Node<Key, Value> x) {
    assert(x is Node);
    if (!(x.right is Node<Key, Value>)) {
      return x;
    } else {
      return maxWithNode(x.right);
    }
  }
  
  // the largest key less than or equal to the given key
  Key floor(Key key) {
    Node<Key, Value> x = floorWithNode(root,key);
    if (!(x is Node<Key, Value>)) {
      return null;
    } else {
      return x.key;
    }
  }
  
  // the largest key in the subtree rooted at x less than or equal to the given key
  Node<Key, Value> floorWithNode(Node<Key, Value> x, Key key) {
    if (!(x is Node<Key, Value>)) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);
    
    if (cmp == 0) {
      return x;
    }
    
    if (cmp < 0) {
      return floorWithNode(x.left, key);
    }
    
    Node<Key, Value> t = floorWithNode(x.right, key);
    if (t is Node<Key, Value>) {
      return t;
    } else {
      return x;
    }
  }
  
  // the smallest key greater than or equal to the given key
  Key ceiling(Key key) {
    Node<Key, Value> x = ceilingWithNode(root, key);
    if (!(x is Node<Key, Value>)) {
      return null;
    } else {
      return x.key;
    }
  }
  
  // the smallest key in the subtree rooted at x greater than or equal to the given key
  Node<Key, Value> ceilingWithNode(Node<Key, Value> x, Key key) {
    if (!(x is Node<Key, Value>)) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);
    
    if (cmp == 0) {
      return x;
    }
    
    if (cmp > 0) {
      return ceilingWithNode(x.right, key);
    }
    
    Node<Key, Value> t = ceilingWithNode(x.left, key);
    if (t is Node<Key, Value>) {
      return t;
    } else {
      return x;
    }
  }
  
  // the key of rank k
  Key select(int k) {
    if (k < 0 || k >= size()) {
      return null;
    }
    
    Node x = selectWithNode(root, k);
    return x.key;
  }
  
  // the key of rank k in the subtree rooted at x
  Node<Key, Value> selectWithNode(Node<Key, Value> x, int k) {
    assert(x is Node);
    assert(k >= 0 && k < sizeWithNode(x));
    int t = sizeWithNode(x.left);
    if (t > k) {
      return selectWithNode(x.left, k);
    } else if (t < k) {
      return selectWithNode(x.right, k - t - 1);
    } else {
      return x;
    }
  }
  
  // number of keys less than key
  int rank(Key key) {
    return rankWithNode(key, root);
  }
  
  // number of keys less than key in the subtree rooted at x
  int rankWithNode(Key key, Node<Key, Value> x) {
    if (!(x is Node<Key, Value>)) {
      return 0;
    }
    
    int cmp = key.compareTo(x.key);
    if (cmp < 0) {
      return rankWithNode(key, x.left);
    } else if (cmp > 0) {
      return 1 + sizeWithNode(x.left) + rankWithNode(key, x.right);
    } else {
      return sizeWithNode(x.left);
    }
  }
  
  //
  // Range count and range search.  
  //
  // all of the keys, as an queue
  Queue<Key> keys() {
    return keysWithLoHi(min(), max());
  }
  
  // the keys between lo and hi, as an queue
  Queue<Key> keysWithLoHi(Key lo, Key hi) {
   Queue<Key> queue = new Queue<Key>();
   keysWithLoHiNode(root, queue, lo, hi);
   return queue;
  }
  
  // add the keys between lo and hi in the subtree rooted at x to the queue
  void keysWithLoHiNode(Node<Key, Value> x, Queue<Key> queue, Key lo, Key hi) {
    if (!(x is Node<Key, Value>)) {
      return;
    }
    
    int cmplo = lo.compareTo(x.key);
    int cmphi = hi.compareTo(x.key);
    
    if (cmplo < 0) {
      keysWithLoHiNode(x.left, queue, lo, hi);
    }
    
    if (cmplo <= 0 && cmphi >= 0) {
      queue.add(x.key);
    }
    
    if (cmphi > 0) {
      keysWithLoHiNode(x.right, queue, lo, hi);
    }
  }
  
  // number keys between lo and hi
  int sizeWithKeys(Key lo, Key hi) {
    if (lo.compareTo(hi) > 0) {
      return 0;
    }
    
    if (contains(hi)) {
      return rank(hi) - rank(lo) + 1;
    } else {
      return rank(hi) - rank(lo);
    }
  }
  
  
  //
  // Check integrity of red-black BST data structure
  //
  bool check() {
    if (!isBST()) {
      print('No in symmetric order');
    }
    
    if (!isSizeConsistent()) {
      print('Subtree counts not consistent');
    }
    
    if (!isRankConsistent()) {
      print('Ranks not consistent');
    }
    
    if (!is23()) {
      print('Not a 2-3 tree');
    }
    
    if (!isBalanced()) {
      print('Not balanced');
    }
    
    return isBST() && isSizeConsistent() && isRankConsistent() && is23() && isBalanced(); 
  }
  
  // Does this binary tree satisfy symmetric order?
  // Note: this test also ensures that data structure is a binary tree since order is strict
  bool isBST() {
    return isBSTWithNodes(root, null, null);
  }
  
  // is the tree rooted at x a BST with all keys strictly between min and max
  // (if min or max is null, treat as empty constraint)
  // Credit: Bob Dondero's elegant solution
  bool isBSTWithNodes(Node<Key, Value> x, Key _min, Key _max) {
    if (!(x is Node<Key, Value>)) { 
      return true; 
    }
    
    if (_min is Key && x.key.compareTo(_min) <= 0) {
      return false; 
    }
    
    if (_max is Key && x.key.compareTo(_max) >= 0) {
      return false; 
    }
    
    return isBSTWithNodes(x.left, _min, x.key) && isBSTWithNodes(x.right, x.key, _max);
  }
  
  // are the size fields correct?
  bool isSizeConsistent() {
    return isSizeConsistentWithNode(root); 
  }
  
  bool isSizeConsistentWithNode(Node<Key, Value> x) {
    if (!(x is Node<Key, Value>)) {
      return true; 
    }
    
    if (x.N != (sizeWithNode(x.left) + sizeWithNode(x.right) + 1)) {
      return false; 
    }
    
    return isSizeConsistentWithNode(x.left) && isSizeConsistentWithNode(x.right);
  }
  
  // check that ranks are consistent
  bool isRankConsistent() {
    for (int i=0; i<size(); i++) {
      if (i != rank(select(i))) {
        return false; 
      }
    }
    
    for (Key key in keys()) {
      if (key.compareTo(select(rank(key))) != 0) {
        return false;
      }
    }
    
    return true; 
  }
  
  // Does the tree have no red right links, and at most one (left)
  // red links in a row on any path?
  bool is23() {
    return is23WithNode(root);
  }
  
  bool is23WithNode(Node<Key, Value> x) {
    if (!(x is Node<Key, Value>)) {
      return true; 
    }
    
    if (isRed(x.right)) {
      return false;
    }
    
    if (x != root && isRed(x) && isRed(x.left)) {
      return false; 
    }
    
    return is23WithNode(x.left) && is23WithNode(x.right);
  }
  
  // do all paths from root to leaf have some number of black edges?
  bool isBalanced() {
    int black = 0; // number of black links on the path from root to min
    Node<Key, Value> x = root;
    while (x is Node<Key, Value>) {
      if (!isRed(x)) {
        black++;
      }
      
      x = x.left;
    }
    
    return isBalancedWithNode(root, black);
  }
  
  bool isBalancedWithNode(Node<Key, Value> x, int black) {
    if (!(x is Node<Key, Value>)) {
      return black == 0;
    }
    
    if (!isRed(x)) {
      black--;
    }
    
    return isBalancedWithNode(x.left, black) && isBalancedWithNode(x.right, black);
  }
}
