import 'dart:io';
import 'package:cli_table/cli_table.dart';
import 'package:library_management_system/book.dart';

class Utils {
  static void printError(String message) {
    print("\x1B[31m$message\x1B[0m");
  }

  static void printSuccess(String message) {
    print("\x1B[32m$message\x1B[0m");
  }

  static void printWarning(String message) {
    print("\x1B[33m$message\x1B[0m");
  }

  static createBookTable(List<Book> books,
      {int? currentPage, int? totalPages}) {
    final table = Table(
      style: TableStyle(
        border: ['green'],
        header: [
          'green',
        ],
      ),
      header: ['ID', 'Title', "Author", "Borrowed Status", "Import Date"],
      columnWidths: [10, 20, 20, 30, 30],
    );

    if (books.isEmpty) {
      table.addAll([
        [
          {
            'colSpan': 5,
            'content': 'Empty List',
            'hAlign': VerticalAlign.center
          }
        ],
      ]);
    } else {
      for (var book in books) {
        table.add([
          book.getId.toString(),
          book.getTitle,
          book.getAuthor,
          book.getIsBorrowed == true ? 'Unavailable' : 'Available',
          book.getDate,
        ]);
      }
    }

    if (currentPage != null && totalPages != null) {
      table.add([
        {
          'colSpan': 5,
          'content':
              'Page ${currentPage == 0 ? 1 : currentPage} of $totalPages',
          'hAlign': VerticalAlign.center
        }
      ]);
    } else {
      if (books.isNotEmpty) {
        table.add([
          {'colSpan': 5, 'content': 'All Pages', 'hAlign': VerticalAlign.center}
        ]);
      }
    }
    print(table.toString());
  }

  static Book getInputFromUser() {
    stdout.write("Enter title: ");
    String title = stdin.readLineSync() ?? '';
    stdout.write("Enter author: ");
    String author = stdin.readLineSync() ?? '';
    DateTime date = DateTime.now();
    print('Import Date: $date');

    return Book(
      title,
      author,
      false,
    );
  }

  static int validateBookId(String type) {
    bool isNumber;
    int id = 0;
    do {
      stdout.write(
          "Enter ID to ${type == 'UPDATE' ? 'Update:' : type == 'BORROW' ? 'Borrow:' : type == 'RETURN' ? 'Return:' : 'Delete:'} ");
      String? input = stdin.readLineSync();
      if (input != null) {
        try {
          id = int.parse(input);
          isNumber = true;
        } catch (e) {
          print('Your id must be a number!');
          isNumber = false;
        }
      } else {
        print('Invalid input!');
        isNumber = false;
      }
    } while (!isNumber);

    return id;
  }
}
