//#import('dart:html', prefix:'html');
#source('RedBlackBST.dart');
#source('Node.dart');


class RedBlackBSTExample {

  RedBlackBSTExample() {
  }

  void run() {
    print("Hello World!");
    List<String> s = "SEARCHEXAMPLE".splitChars();
    
    RedBlackBST<String, num> st = new RedBlackBST<String, num>();

    for (int i=0; i<s.length; i++) {
      st.put(s[i], i);
    }
    
    for(String sk in st.keys()) {
      print(sk + " " + st.getValue(sk));
    }

    Expect.equals(8,  st.getValue('A'));
    Expect.equals(4,  st.getValue('C'));
    Expect.equals(12, st.getValue('E'));
    Expect.equals(5,  st.getValue('H'));
    Expect.equals(11, st.getValue('L'));
    Expect.equals(9,  st.getValue('M'));
    Expect.equals(10, st.getValue('P'));
    Expect.equals(3,  st.getValue('R'));
    Expect.equals(0,  st.getValue('S'));
    Expect.equals(7,  st.getValue('X'));
    print("Goodbye World!");
  }
}

void main() {
  new RedBlackBSTExample().run();
}
