import 'package:flutter/cupertino.dart';
import 'package:wirevviewer/datamodel/wireviewer_datamodel.dart' as dmodel;

class DataListProvider extends ChangeNotifier{
  late List<dmodel.RelatedTopics> datalist;
  late List<dmodel.RelatedTopics> tdatalist;
   updateDataList(List<dmodel.RelatedTopics> val){
     datalist = val;
     tdatalist = val;
     notifyListeners();
   }

   updateQuery(String searchText){
     datalist = tdatalist.where((element) => element.text!.contains(searchText)).toList();
     notifyListeners();
   }
}