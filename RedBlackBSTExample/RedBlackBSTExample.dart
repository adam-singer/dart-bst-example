//#import('dart:html', prefix:'html');
#source('Node.dart');
#source('RedBlackBST.dart');

class RedBlackBSTExample {

  RedBlackBSTExample() {
  }

  void run() {
    write("Hello World!");
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    //html.document.query('#status').innerHTML = message;
  }
}

void main() {
  new RedBlackBSTExample().run();
}
