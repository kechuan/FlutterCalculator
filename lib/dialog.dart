import 'package:flutter/material.dart';

Future<bool?> showBasicAlertDialog(BuildContext context) {
  return showDialog<bool>(
        context: context,
        barrierLabel: "testLabel",
        builder: (context) {
          return AlertDialog(
            title: Text("Dialog"),
            content: Text("It is a Dialog Text."),
            actions: <Widget>[
               ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("确认"),
              ),
               ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
            ],

            
          );
        });
  
}


void showSimpleDialog(BuildContext context, List<String?> historyResult) async {
  String? copychoice = await showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("History Result"),
            children: <Widget>[
				SimpleDialogOption(
					onPressed: ()=> Navigator.pop(context, historyResult[0]),
					child: Padding(
						padding: const EdgeInsets.symmetric(vertical: 6),
						child:  Text("${historyResult[0]}"),
					),

				),

				SimpleDialogOption(
					onPressed: ()=> Navigator.pop(context, historyResult[1]),
					child: Padding(
						padding: const EdgeInsets.symmetric(vertical: 6),
						child: Text("${historyResult[1]}"),
					),

				),
			]
          );
    });

	if(copychoice != null){
		print("copychoice:$copychoice");
	}

}

//void showListview(Key? key,List<String?> historyCalculated,List<String?> historyResult) async {
void showListview({required BuildContext context,Key? key,List<String?>? historyCalculated,List<String?>? historyResult}) async {


  //print("key:${key}"); //flutter: key:[LabeledGlobalKey<_MyHomePageState>#bf177]

  //...不过很可惜这个key基本什么都做不了 因为它不处在拥有state的class范围内
  //唯一的作用 估计就真的只是一个key密钥 而不是key钥匙了

  //不过这种传参方式也挺有意思的
  
 

	Widget dynamicContentShow = 
		Expanded(
			child: ListView.builder( 
				//Listview.builder需要一个明确的大小约束来布局 否则会提示缺失Size信息导致崩溃
				//那么最简单的就是用Expanded了
				itemCount: 6,
				itemBuilder: (BuildContext itemContext,int index){
					return ListTile(
						
						title: Row(
							mainAxisAlignment: MainAxisAlignment.spaceAround,
							children: [
								Text("${historyCalculated?[index]} = "),
								Text("${historyResult?[index]}"),
							],
						),
						onTap: () => Navigator.of(context).pop(historyResult?[index]),
					);	
				}	
			),
		);

	if(historyResult?[0]==null){
		dynamicContentShow = Expanded(child: Container(alignment: Alignment.center,child:const Text("No Result Recorded.")),);
	}

  String? copychoice = await showDialog<String>(	
        context: context,
        builder: (context) {
			var columnChild = Container( //root widget必须不能是指定大小的 毕竟会等效Expanded
      
				child: SizedBox(
					width: 400,
					height: 400,
					child: Column(
						children: <Widget>[
              				//未解之谜 为什么一设置了leading 它就会空出一个固定的空间出来。我寻思我Column啥也没设置啊??
							ListTile(title: const Text("History result",style: TextStyle(fontSize: 18),)),
							//猜想1 尽管ListTitle的 contentPadding 未声明 但设置其强制为0后 其padding消失了 如果不是ListTitle所为 那就是parent的Column所致

							dynamicContentShow
						]),),
			);
			
			return Dialog(child: columnChild); 
      //??? 为什么要特地return Dialog? 
      //而不是往常一样return column完事 因为listview吗? 还真是
    	});

	if(copychoice != null){
		print("copychoice:$copychoice");
	}

}


showToaster(BuildContext context) {

  showDialog(
        context: context,
        //barrierLabel: "testLabel",
        builder: (context) {
          return AlertDialog(
            title: Text("Dialog"),
            content: Text("It is a Dialog Text."),
            actions: <Widget>[
               ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("确认"),
              ),
               ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
            ],
          );
        });
  
}