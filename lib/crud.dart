import 'dart:io';
import 'package:library_management_system/book.dart';
import 'package:library_management_system/utils.dart';

class Crud {
  static List<Book> books = [];
  static List<Book> unsaveBooks = [];
  static int itemsPerPage = 2;
  static int currentPage = 1;
  static int totalPages = 1;

  static int calculateTotalPages() {
    return (books.length / itemsPerPage).ceil();
  }

  static void addBook(Book book) {
    book.setId = books.length + 1;
    books.add(book);
    totalPages = calculateTotalPages();
  }

  static void addUnSaveBook(Book book) {
    book.setId = unsaveBooks.length + 1;
    unsaveBooks.add(book);
  }

  static void initializeBooks() {
    if (books.isEmpty) {
      addBook(Book('The Pilgrim’s Progress​', 'John Bunyan', false));
      addBook(Book('Robinson Crusoe', 'Daniel Defoe', false));
      addBook(Book('Gulliver’s Travels', 'Jonathan Swift', false));
      addBook(Book('Tom Jones', 'Henry Fielding ', false));
      totalPages = calculateTotalPages();
    }
  }

  static writeBook() {
    initializeBooks();
    Book newBook = Utils.getInputFromUser();
    bool existsInBooks = books.any((existingBook) =>
        existingBook.getTitle == newBook.getTitle &&
        existingBook.getAuthor == newBook.getAuthor);
    bool existsInUnsaveBooks = unsaveBooks.any((existingBook) =>
        existingBook.getTitle == newBook.getTitle &&
        existingBook.getAuthor == newBook.getAuthor);

    if (existsInBooks || existsInUnsaveBooks) {
      Utils.printError(
          "Book with title '${newBook.getTitle}' by ${newBook.getAuthor} already exists in the library.");
    } else {
      addUnSaveBook(newBook);
      if (unsaveBooks.isNotEmpty) {
        Utils.printSuccess(
            "Insert has been save to the temporary list choose \"Save\" Option to Save!");
      }
    }
  }

  static saveBook() {
    if (unsaveBooks.isEmpty) {
      Utils.printError("Can't Insert new book because unsave list is empty!");
      return;
    }

    int newBookCount = unsaveBooks.length;

    for (int i = 0; i < unsaveBooks.length; i++) {
      unsaveBooks[i].setId = books.length + i + 1;
    }

    books.addAll(unsaveBooks);

    unsaveBooks.clear();

    totalPages = calculateTotalPages();

    Utils.printSuccess(
        "$newBookCount new product${newBookCount == 1 ? '' : 's'} inserted successfully!");
  }

  static readUnsaveBook() {
    Utils.createBookTable(unsaveBooks);
  }

  static void readBooks() {
    initializeBooks();

    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= books.length) {
      currentPage = 1;
      start = (currentPage - 1) * itemsPerPage;
      end = start + itemsPerPage;
    }

    List<Book> pageItems = books.sublist(
      start,
      end > books.length ? books.length : end,
    );

    Utils.createBookTable(pageItems,
        currentPage: currentPage, totalPages: totalPages);
  }

  static getAllBooks() {
    initializeBooks();
    Utils.createBookTable(books);
  }

  static bool deleteBook() {
    while (true) {
      int deleteId = Utils.validateBookId('DELETE');

      try {
        int index = books.indexWhere((book) => book.getId == deleteId);

        if (index == -1) {
          Utils.printError("Book with ID $deleteId is not found.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return false;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return false;
          }
        }

        // Ask for confirmation
        Utils.printWarning(
            "Are you sure you want to delete the product with ID $deleteId? (yes/no): ");
        String? confirmation = stdin.readLineSync()?.toLowerCase();

        if (confirmation == 'yes') {
          totalPages = calculateTotalPages();
          books.removeAt(index);
          Utils.printSuccess("Product deleted successfully!");
          return true;
        } else {
          Utils.printError("Product deletion cancelled.");
          return false;
        }
      } catch (e) {
        Utils.printError("Error: ${e.toString()}");
        return false;
      }
    }
  }

  static bool updateBook() {
    while (true) {
      int updateId = Utils.validateBookId('UPDATE');

      try {
        int index = books.indexWhere((book) => book.getId == updateId);
        if (index == -1) {
          Utils.printError("Book with ID $updateId is not found.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return false;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return false;
          }
        }

        Book newBook = Utils.getInputFromUser();

        newBook.setId = updateId;

        books[index] = newBook;

        Utils.printSuccess("Product updated successfully!");
        return true;
      } catch (e) {
        Utils.printError("Error: ${e.toString()}");
        false;
      }
    }
  }

  static void searchBook() {
    stdout.write("Enter search value: ");
    String? searchValue = stdin.readLineSync()?.toLowerCase();

    if (searchValue != null && searchValue.isNotEmpty) {
      List<Book> results = books.where((book) {
        return book.getTitle.toLowerCase().contains(searchValue) ||
            book.getAuthor.toLowerCase().contains(searchValue);
      }).toList();

      if (results.isNotEmpty) {
        Utils.printSuccess("Found ${results.length} book(s).");
        Utils.createBookTable(results);
      } else {
        Utils.printError("No products found matching '$searchValue'.");
      }
    } else {
      Utils.printError("Invalid input. Returning to the main menu.");
    }
  }

  static void _showCurrentPage() {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (end > books.length) {
      end = books.length;
    }

    List<Book> pageItems = books.sublist(
      start,
      end > books.length ? books.length : end,
    );

    Utils.createBookTable(pageItems,
        currentPage: currentPage, totalPages: totalPages);
  }

  static void next() {
    if (currentPage < totalPages) {
      currentPage++;
    } else {
      Utils.printError("Already on the last page.");
    }
    _showCurrentPage();
  }

  static void first() {
    currentPage = 1;
    _showCurrentPage();
  }

  static void previous() {
    if (currentPage > 1) {
      currentPage--;
    } else {
      Utils.printError("Already on the first page.");
    }
    _showCurrentPage();
  }

  static void last() {
    currentPage = totalPages;
    Utils.printSuccess("Last page.");
    _showCurrentPage();
  }

  static void gotoPage() {
    stdout.write("Enter page number (1 to $totalPages): ");
    String? pageInput = stdin.readLineSync();
    int? pageNumber = int.tryParse(pageInput ?? '');

    if (pageNumber != null && pageNumber > 0 && pageNumber <= totalPages) {
      currentPage = pageNumber;
    } else {
      Utils.printError("Invalid page number.");
    }
    _showCurrentPage();
  }

  static void setRows() {
    stdout.write("Enter the number of items per page: ");
    String? input = stdin.readLineSync();
    int? newItemsPerPage = int.tryParse(input ?? '');

    if (newItemsPerPage != null && newItemsPerPage > 0) {
      itemsPerPage = newItemsPerPage;
      totalPages = calculateTotalPages();
      Utils.printSuccess("Items per page set to $itemsPerPage.");
    } else {
      Utils.printError("Invalid number. Please enter a positive integer.");
    }

    currentPage = 1;
    readBooks();
  }

  static void borrowBook() {
    initializeBooks();

    if (books.isEmpty) {
      Utils.printError("No books available in the library.");
      return;
    }

    while (true) {
      Utils.createBookTable(books);

      int id = Utils.validateBookId('BORROW');

      try {
        int index = books.indexWhere((book) => book.getId == id);

        if (index == -1) {
          Utils.printError("Book with ID $id is not found.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return;
          }
        }

        Book bookToBorrow = books[index];

        if (bookToBorrow.getIsBorrowed) {
          Utils.printError("Book with ID $id is already borrowed.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return;
          }
        }

        bookToBorrow.setIsBorrowed = true;
        Utils.printSuccess("Book with ID $id has been borrowed successfully.");
        return;
      } catch (e) {
        Utils.printError("Error: ${e.toString()}");
      }
    }
  }

  static void returnBook() {
    initializeBooks();

    if (books.isEmpty) {
      Utils.printError("No books available in the library.");
      return;
    }

    while (true) {
      Utils.createBookTable(books);

      int id = Utils.validateBookId('RETURN');

      try {
        int index = books.indexWhere((book) => book.getId == id);

        if (index == -1) {
          Utils.printError("Book with ID $id is not found.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return;
          }
        }

        Book bookToReturn = books[index];

        if (!bookToReturn.getIsBorrowed) {
          Utils.printError("Book with ID $id is not borrowed.");
          print("Choose an option: (1) Next (2) Go Back");
          String? choice = stdin.readLineSync()?.toLowerCase();

          if (choice == '1' || choice == 'next') {
            continue;
          } else if (choice == '2' || choice == 'back') {
            print("Going back to the main menu.");
            return;
          } else {
            Utils.printError("Invalid choice. Returning to the main menu.");
            return;
          }
        }

        bookToReturn.setIsBorrowed = false;
        Utils.printSuccess("Book with ID $id has been returned successfully.");
        return;
      } catch (e) {
        Utils.printError("Error: ${e.toString()}");
      }
    }
  }
}
