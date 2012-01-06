class BST<Key extends Comparable, Value> {
  Node<Key,Value> root; // root of BST
  
  // is the symbol table empty?
  bool isEmpty() {
    return sizeRoot() == 0;
  }
  
  // return number of key-value pairs in the BST
  sizeRoot() {
    return size(root);
  }
  
  // return number of key-value pairs in the BST rooted at x
  size(Node x) {
    if (x is Node) {
      return x.N;
    } else  {
      return 0;
    }
  }
  
  /////////////////////
  // Search BST for given key, and return associated value if found, 
  // return null if not found. 
  //
  
  // does there exist a key-value pair with given key?
  bool containsWithKey(Key key) {
    return getValue(key) is Value;
  }
  
  // return value assoicated with the given key, or null if no such key exists
  Value getValue(Key key) {
    return getValueFromNode(root, key);
  }
  
  Value getValueFromNode(Node x, Key key) {
    if (x == null) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);

    if (cmp < 0) {
      return getValueFromNode(x.left, key);
    } else if (cmp > 0) {
      return getValueFromNode(x.right, key);
    } else {
      return x.val;
    }
  }

  
  /////////////////////
  // Insert key-value pair into BST
  // If key already exists, update with new value
  // 
  
  put(Key key, Value val) {
    if (!(val is Value)) {
      delete(key); 
      return;
    }
   
    root = putWithNode(root, key, val);
    assert(check());
  }
  
  Node putWithNode(Node x, Key key, Value val) {
    if (!(x is Node<Key,Value>)) {
      return new Node<Key,Value>(key, val, 1);
    }
    
    int cmp = key.compareTo(x.key);
    
    if (cmp < 0) {
      x.left = putWithNode(x.left, key, val);
    } else if (cmp > 0) {
      x.right = putWithNode(x.right, key, val);
    } else {
      x.val = val;
    }
    
    x.N = 1 + size(x.left) + size(x.right);
    return x;
  }
  
  /////////////////////
  // Delete
  //
  deleteMin() {
    if (isEmpty()) {
      throw new Exception('Symbol table underflow');
    }
    root = deleteMinWithNode(root);
    assert(check());
  }
  
  Node<Key,Value> deleteMinWithNode(Node<Key,Value> x) {
    if (!(x.left is Node<Key,Value>)) {
      return x.right;
    }
    
    x.left = deleteMinWithNode(x.left);
    x.N = size(x.left) + size(x.right) + 1;
    return x;
  }
  
  deleteMax() {
    if (isEmpty()) {
      throw new Exception("Symbol table underflow");
    }
    
    root = deleteMaxWithNode(root);
    assert(check());
  }
  
  deleteMaxWithNode(Node<Key,Value> x) {
    if (!(x.right is Node<Key,Value>)) {
      return x.left;
    }
    
    x.right = deleteMaxWithNode(x.right);
    x.N = size(x.left) + size(x.right) + 1;
    return x;
  }
  
  delete(Key key) {
    root = deleteWithNode(root, key);
    assert(check());
  }
  
  deleteWithNode(Node<Key,Value> x, Key key) {
    if (!(x is Node<Key,Value>)) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);
    
    if (cmp < 0) {
      x.left = deleteWithNode(x.left, key);
    } else if (cmp > 0) {
      x.right = deleteWithNode(x.right, key);
    } else {
      if (!(x.right is Node<Key,Value>)) {
        return x.left;
      }
      
      if (!(x.left is Node<Key,Value>)) {
        return x.right;
      }
      
      Node<Key,Value> t = x;
      x = minWithNode(t.right);
      x.right = deleteMinWithNode(t.right);
      x.left = t.left;
    }
    
    x.N = size(x.left) + size(x.right) + 1;
    return x;
  }
  
  /////////////////////
  // Min, max, floor and ceiling
  // 
  Key min() {
    if (isEmpty()) {
      return null;
    } else {
      return minWithNode(root).key;
    }
  }
  
  Node<Key,Value> minWithNode(Node<Key,Value> x) {
    if (!(x.left is Node<Key,Value>)) {
      return x;
    } else {
      return minWithNode(x.left);
    }
  }
  
  Key max() {
    if (isEmpty()) {
      return null;
    } else {
      return maxWithNode(root).key;
    }
  }
  
  Node<Key,Value> maxWithNode(Node<Key,Value> x) {
    if (!(x.right is Node<Key,Value>)) {
      return x;
    } else {
      return maxWithNode(x.right);
    }
  }
  
  Key floor(Key key) {
    Node<Key,Value> x = floorWithNode(root, key);
    if (!(x is Node<Key,Value>)) {
      return null;
    } else {
      return x.key;
    }
  }
  
  Node<Key,Value> floorWithNode(Node<Key,Value> x, Key key) {
    if (!(x is Node<Key,Value>)) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);
    if (cmp == 0) {
      return x;
    }
    
    if (cmp < 0) {
      return floorWithNode(x.left, key);
    }
    
    Node<Key,Value> t = floorWithNode(x.right, key);
    
    if (t is Node<Key,Value>) {
      return t;
    } else {
      return x;
    }
  }
  
  Key ceiling(Key key) {
    Node<Key,Value> x = ceilingWithNode(root, key);
    if (!(x is Node<Key,Value>)) {
      return null;
    } else {
      return x.key;
    }
  }
  
  Node<Key,Value> ceilingWithNode(Node<Key,Value> x, Key key) {
    if (!(x is Node<Key,Value>)) {
      return null;
    }
    
    int cmp = key.compareTo(x.key);
    if (cmp == 0) {
      return x;
    }
    
    if (cmp < 0) {
      Node<Key,Value> t = ceilingWithNode(x.left, key);
      if (t is Node<Key,Value>) {
        return t;
      } else {
        return x;
      }
    }
    
    return ceilingWithNode(x.right, key);
  }
  
  /////////////////////
  // Rank and selection
  // 
  Key select(int k) {
    if (k < 0 || k >= sizeRoot()) {
      return null;
    } 
    
    Node<Key,Value> x = selectWithNode(root, k);
    return x.key;
  }
  
  Node<Key,Value> selectWithNode(Node<Key,Value> x, int k) {
    if (!(x is Node<Key,Value>)) {
      return null;
    }
    
    int t = size(x.left);
    
    if (t > k) {
      return selectWithNode(x.left, k);
    } else if (t < k) {
      return selectWithNode(x.right, k-t-1);
    } else {
      return x;
    }
  }
  
  rank(Key key) {
    return rankWithNode(key, root);
  }
  
  rankWithNode(Key key, Node<Key,Value> x) {
    if (!(x is Node<Key,Value>)) {
      return 0;
    }
    
    int cmp = key.compareTo(x.key);
    
    if (cmp < 0) {
      return rankWithNode(key, x.left);
    } else if (cmp > 0) {
      return 1 + size(x.left) + rankWithNode(key, x.right);
    } else {
      return size(x.left);
    }
  }
  
  /////////////////////
  // Range count and range search
  // 
  Collection<Key> keys() {
    return keysWithHighLow(min(), max());
  }
  
  Collection<Key> keysWithHighLow(Key lo, Key hi) {
    Queue<Key> queue = new Queue<Key>();
    keysWithNodeAndQueue(root, queue, lo, hi);
    return queue;
  }
  
  keysWithNodeAndQueue(Node<Key,Value> x, Queue<Key> queue, Key lo, Key hi) {
    if (!(x is Node<Key,Value>)) {
      return;
    }
    
    int cmplo = lo.compareTo(x.key);
    int cmphi = hi.compareTo(x.key);
    
    if (cmplo < 0) {
      keysWithNodeAndQueue(x.left, queue, lo, hi);
    }
    
    if (cmplo <= 0 && cmphi >= 0) {
      queue.add(x.key);
    }
    
    if (cmphi > 0) {
      keysWithNodeAndQueue(x.right, queue, lo, hi);
    }
  }
  
  sizeWithKeys(Key lo, Key hi) {
    if (lo.compareTo(hi) > 0) {
      return 0;
    }
    
    if (containsWithKey(hi)) {
      return rank(hi) - rank(lo) + 1;
    } else {
      return rank(hi) - rank(lo);
    }
  }
  
  // height of this BST (one-node tree has high 0)
  height() { 
    return heightWithNode(root);
  }
  
  heightWithNode(Node<Key,Value> x) {
    if (!(x is Node<Key,Value>)) {
      return -1;
    } else {
      return 1 + Math.max(heightWithNode(x.left), heightWithNode(x.right));
    } 
  }
  
  /////////////////////
  // Check integrity of BST data structure
  // 
  check() {
    //print("check being called");
    if (!isBST()) {
      print("Not in symmetric order");
    }
    
    if (!isSizeConsistent()) {
      print("Subtree counts not consistent");
    }
    
    if (!isRankConsistent()) {
      print("Ranks not consistent");
    }
    
    return isBST() && isSizeConsistent() && isRankConsistent();
  }
  
  // does this binary tree satisfy symmetric order?
  // Node: this test also ensures that data structure is a binary tree since order is strict
  bool isBST() {
    return isBSTWithNode(root, null, null);
  }
  
  // is the tree rooted at x a BST with all keys strictly between min and max
  // (if min or max is null, trest as empty constraint)
  bool isBSTWithNode(Node<Key,Value> x, Key _min, Key _max) {
    if (!(x is Node<Key,Value>)) {
      return true;
    }
    
    if (_min is Key && x.key.compareTo(_min) <= 0) {
      return false;
    }
    
    if (_max is Key && x.key.compareTo(_max) >= 0) {
      return false; 
    }
    
    return isBSTWithNode(x.left, _min, x.key) && isBSTWithNode(x.right, x.key, _max);
  }
  
  // are the size fields correct?
  bool isSizeConsistent() { 
    return isSizeConsistentWithNode(root);
  }
  
  bool isSizeConsistentWithNode(Node<Key,Value> x) {
    if (!(x is Node<Key,Value>)) {
      return true;
    }
    
    if (x.N != (size(x.left) + size(x.right) + 1)) {
      return true;
    }
    
    return isSizeConsistentWithNode(x.left) && isSizeConsistentWithNode(x.right);
    
  }
  
  bool isRankConsistent() {
    for (int i=0; i<sizeRoot(); i++) {
      if (i != rank(select(i))) {
        return false;
      }
    }
    
    for(Key key in keys()) {
      if (key.compareTo(select(rank(key))) != 0) {
        return false;
      }
    }
    
    return true;
  }
  
}
