import 'dart:io';
import 'package:library_management_system/crud.dart';
import 'package:library_management_system/option.dart';
import 'package:library_management_system/utils.dart';

void main(List<String> arguments) {
  String option;

  do {
    option = askOption();

    if (option.isEmpty) {
      Utils.printError("Option cannot be empty. Please try again.");
      continue;
    }

    switch (option) {
      case "w":
        {
          Crud.writeBook();
          Crud.getAllBooks();
          break;
        }
      case "r":
        {
          Crud.readBooks();
          break;
        }
      case "u":
        {
          Crud.updateBook();
          Crud.getAllBooks();
          break;
        }
      case "d":
        {
          Crud.deleteBook();
          Crud.getAllBooks();
          break;
        }
      case "s":
        {
          Crud.searchBook();
          break;
        }
      case "f":
        {
          Crud.first();
          break;
        }
      case "p":
        {
          Crud.previous();
          break;
        }
      case "n":
        {
          Crud.next();
          break;
        }
      case "l":
        {
          Crud.last();
          break;
        }
      case "g":
        {
          Crud.gotoPage();
          break;
        }
      case "sa":
        {
          Crud.saveBook();
          Crud.getAllBooks();
          break;
        }
      case "un":
        {
          Crud.readUnsaveBook();
          break;
        }
      case "al":
        {
          Crud.getAllBooks();
          break;
        }
      case "se":
        {
          Crud.setRows();
          break;
        }
      case "b":
        {
          Crud.borrowBook();
          Crud.getAllBooks();
        }
      case "re":
        {
          Crud.returnBook();
          Crud.getAllBooks();
        }
      case "e":
        {
          print("Exiting program...");
          exit(0);
        }
      default:
        Utils.printError("Invalid option! Please try again.");
    }
  } while (true);
}
