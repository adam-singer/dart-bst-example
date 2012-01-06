// http://algs4.cs.princeton.edu/32bst/
#source('Node.dart');
#source('BST.dart');

class BSTExample {

  BSTExample() {
  }
}

void main() {
  String testString = "S E A R C H E X A M P L E";
  
  BST<String, num> bst = new BST<String, num>();
  Expect.equals(0, bst.sizeRoot());
  Expect.equals(true, bst.isEmpty());
  
  var i=0;
  for(var s in testString.split(' ')) {
   
    bst.put(s, i); i++;
    bst.check();
  }
  
  for (var s in bst.keys()) {
    print("key = ${s} , value = " + bst.getValue(s));
  }
}
