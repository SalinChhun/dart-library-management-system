import 'dart:io';

askOption() {
  print("*)Display");
  print("|| W).Write\t\t| R).Read\t\t| U).Update\t\t| D).Delete\t\t| S).Search   ||");
  print("|| F).First\t\t| P).Previous\t\t| N).Next\t\t| L).Last\t\t| G).Goto     ||");
  print("|| Sa).Save\t\t| Un).Unsave\t\t| Al).All\t\t| Se).Set Row\t\t| E).Exit     ||");
  print("|| B).Borrow\t\t| Re).Return");
  stdout.write("Enter option : ");
  
  String? input = stdin.readLineSync();
  return input?.toLowerCase() ?? '';
}
