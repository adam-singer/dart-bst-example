class RedBlackBST<Key extends Comparable, Value> {
  static final RED = true;
  static final BLACK = false; 
  
  Node<Key, Value> root;
  
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
    return root is Node<Key, Value>;
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
  
  
  
  //
  // Check integrity of red-black BST data structure
  //
  bool check() {
    return true; 
  }
}
