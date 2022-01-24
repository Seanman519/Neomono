import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/assistantMethods/cart_item_counter.dart';
import 'package:users_food_app/global/global.dart';

//returns items id(specific keys without quantity)
separateItemIDs() {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    //this format => 34567654:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //to this format => 34567654
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

//returns items quantity without item id(specific keys)
separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;

//get cart list and sing it
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    //this format => 34567654:7
    String item = defaultItemList[i].toString();

    //to this format => 7
    List<String> listItemCharacters = item.split(":").toList();

    //converting to int
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is Quantity Number = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber);
  }

  print("\nThis is Items Quantity List now = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

//item count
addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter"); //this format = 34567654:7

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update(
    {
      "userCart": tempList,
    },
  ).then(
    (value) {
      Fluttertoast.showToast(msg: "Item Added Successfully");

      sharedPreferences!.setStringList("userCart", tempList);

      //update the badge
      Provider.of<CartItemCounter>(context, listen: false)
          .displayCartListItemsNumber();
    },
  );
}
