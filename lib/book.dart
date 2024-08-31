
class Book {

  int? _id;
  String? _title;
  String? _author;
  bool? _isBorrowed;
  String? _date;

  Book(
    this._title,
    this._author,
    this._isBorrowed
  )   : _id = 0,
        _date = DateTime.now().toString();

  // Getters
  get getId => _id;
  get getTitle => _title;
  get getAuthor => _author;
  get getIsBorrowed => _isBorrowed;
  get getDate => _date;

  // Setters
  set setId(int? id) {
    _id = id;
  }

  set setTitle(String? title) {
    _title = title;
  }

  set setAuthor(String? author) {
    _author = author;
  }

  set setIsBorrowed(bool? isBorrowed) {
    _isBorrowed = isBorrowed;
  }

}

class Test() {
  
}