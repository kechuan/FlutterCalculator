import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './dialog.dart';



void main() => runApp(new MyApp());


void ToasterTest(){
 Fluttertoast.showToast(
    msg: "this is a sample toaster.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER, //center? 右上角??
    timeInSecForIosWeb: 1,
    //backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

//override showBasicAlertDialog 需求传入 context 来明确自己在widgetTree的哪里

//但是不要重复build!


class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
		title: 'Flutter Demo',
		theme: ThemeData(
			colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 125, 190, 243),), 
			//useMaterial3: true
		),
		home: Focus(child: new MyHomePage(title: 'Calculator')), //Fpcus部署
		
		);
	}
}

//void test(){
//	final GlobalKey<_MyHomePageState> key = GlobalKey<_MyHomePageState>();
//	print(key.currentState?.num1);
//}



class MyHomePage extends StatefulWidget {
	//MyHomePage 原生需求key和required需求 title title上面已经提供了'Calculator'
	MyHomePage({Key? key, required this.title}) : super(key: key);

	final String title; //这里的数据 疑似可以直接在state中通过 widget.xxx调用?
	//final GlobalKey<MyHomePage> HomePageKey = GlobalKey<MyHomePage>();
	final String testText = "test";

	

	@override
	_MyHomePageState createState() => new _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {
  	//final test = UnmodifiableListView; //An unmodifiable [List] view of another List.
  
	final historyCalculated = List<String?>.filled(6, null);
	final historyResult = List<String?>.filled(6, null);

	final num1LabelFocus = FocusNode();

	//final GlobalKey<State<StatefulWidget>> HomePageKey = GlobalKey<State<StatefulWidget>>();

	final GlobalKey<_MyHomePageState> HomePageKey = GlobalKey<_MyHomePageState>();
	

  	final label_num1Key = UniqueKey();

	
	//构造函数
	_MyHomePageState(){
		RawKeyboard.instance.addListener(handleKeyPress);
		num1LabelFocus.addListener((){
			print(num1LabelFocus.hasFocus); 
			//FocusScope.of(context).unfocus();
		});

	}

	bool CalculatingFlag = true;
	

	String tempStorage = "0";

	String num1_display = "num1_display";
	String num2_display = "num2_display";
    String operand = "";


	bool num1InputFlag = true;

	num num1 = 0;
	num num2 = 0;
	num result = 0;
	

	int historyWriteCount = 0;

	

  	//Fluttertoast flutterToaster = Fluttertoast();

	

	void calculate(){

		//从字符串中重新 解析num1/num2

		if(num1_display.isEmpty&&num2_display.isEmpty) return;

		num1_display.isEmpty?num1=0:null;

		if(num1_display.isEmpty){
			num1 = 0;
		}

		else if(num1_display.toString().contains(".")){
			num1 = double.parse(num1_display); //将输入的String 重新转换为Double
		}

		else{
			num1 = int.parse(num1_display); //将输入的String 重新转换为Double
		}
		


		if(num2_display.isEmpty){
			num2 = 0;
		}

		else if(num2_display.toString().contains(".")){
			num2 = double.parse(num2_display); //将输入的String 重新转换为Double
		}

		else{
			num2 = int.parse(num2_display); //将输入的String 重新转换为Double
		}

			

		switch(operand){
			case "+": result = num1 + num2; break;
			case "-": result = num1 - num2; break;
			case "X": result = num1 * num2; break;
			case "/": result = num1 / num2; break;

			default: result = num2 == 0?num1:num2;
		}

		bool idleFlag = historyResult.any((element) => element==null?true:false);
			

		//result Handler
		if(result.toString().contains(".")){
				if(result.toString().lastIndexOf(".") == result.toString().length-2){
					//print("ends with .X");
					if(result.toString().lastIndexOf("0")==result.toString().length-1) {
						result = result.toInt();
						//print("ends with 0");
					}
				
				}

				else{
					result = double.parse(result.toStringAsFixed(6));
				}
			
		}

		

		if(idleFlag) {
			for(int index = 0; index< historyResult.length; ++index){
				if(historyResult[index] == null){
					historyResult[index] = tempStorage;
					print("idleFlag:${historyResult[index]}");
					break;
				}

				print("idleFlag:${historyResult[index]}");
				
			}
		}

		else{
			print("historyResult is full");
			historyResult[historyWriteCount%historyResult.length] = tempStorage;
			print("historyWriteCount%historyResult.length:${historyWriteCount%historyResult.length}");

			historyResult.forEach((element) {print("historyResult:$element");});
		}


		print("result:${result},已存储到下标${historyWriteCount%historyCalculated.length}");tempStorage = "$result";

		historyCalculated[historyWriteCount%historyCalculated.length] = "${num1_display} $operand ${num2_display}";
		historyResult[historyWriteCount%historyResult.length] = "$result";

		CalculatingFlag = false;
		num1InputFlag = true;

		historyWriteCount++;

		setState((){});

	}


	void currentInputNumber(String modifiedNumber){

		if(CalculatingFlag){
			if(num1InputFlag){
				if(num1_display=="0") num1_display=modifiedNumber;
				else num1_display+=modifiedNumber;
			}

			else{
				if(num2_display=="0") num2_display=modifiedNumber;
				else num2_display+=modifiedNumber;
			}
		}

		//重新按下数值时 你应当是正在计算状态 不过在此之前应该把result先给到num1上
		else{
			num1_display = result.toString();
			//num1 = result;
			num2_display = "";
			operand = "";
			result = 0;

			CalculatingFlag = true;
		}

	}

	void currentInputOperand(String modifiyOperand){
		operand=modifiyOperand;
		num1InputFlag=!num1InputFlag;

		if(!CalculatingFlag){
			num1_display = result.toString();
			num2_display = "";
			result = 0;
			CalculatingFlag = true;	
		}
	}
		
	void handleKeyPress(RawKeyEvent event) {

		if (event is RawKeyDownEvent) {

			if(num1_display=="num1_display"&&num2_display=="num2_display"){
				num1_display = "";num2_display = "";
			}


			switch(event.logicalKey.keyLabel){
				case "0":
				case "Numpad 0":{
					if(num1InputFlag&&num1_display=="0") return;
					if(!num1InputFlag&&num2_display=="0") return;
					num1InputFlag?num1_display += "0":num2_display+="0";
					break;
				}
				
				case "1":
				case "Numpad 1":{
					currentInputNumber("1");
					break;
				}
				
				case "2":
				case "Numpad 2":{
					currentInputNumber("2");break;
				}
				
				case "3":
				case "Numpad 3":{
					currentInputNumber("3");break;
				}
				
				case "4":
				case "Numpad 4":{
					currentInputNumber("4");break;
				}
				
				case "5":
				case "Numpad 5":{
					currentInputNumber("5");break;
				}
				
				case "6":
				case "Numpad 6":{
					currentInputNumber("6");break;
				}
				
				case "7":
				case "Numpad 7":{
					currentInputNumber("7");break;
				}
				
				case "8":
				case "Numpad 8":{
					currentInputNumber("8");break;
				}
				
				case "9":
				case "Numpad 9":{
					currentInputNumber("9");break;
				}

				case "+": {
					currentInputOperand("+");break;
				}

				case "-": {
					currentInputOperand("-");break;
				}

				case "*": {
					currentInputOperand("X");break;
				}

				case "/": {
					currentInputOperand("/");break;
				}

				case " ": num1InputFlag=!num1InputFlag;break;

				case "Backspace":{

					if(num1InputFlag){
						if(num1_display.length == 1){
							num1_display = "0";
						}

						else{
							num1_display = num1_display.substring(0,num1_display.length-1);
						}
					}

					else{
						if(num2_display.length == 1){
							num2_display = "0";
						}

						else{
							num2_display = num2_display.substring(0,num2_display.length-1);
						}
					}
					
					break;

					
				}


				case "Enter": calculate(); return;
				case "Tab": return;

				default:print("event.logicalKey:${event.logicalKey},${num1InputFlag?"num1_display:$num1_display":"num2_display:$num2_display"}");
			}

			setState((){});
		}
	}


	void buttonPressed(String buttonText) async {


		switch(buttonText){
			case "CLEAR":{
				num1InputFlag = true;
				num1 = 0;num2 = 0;result = 0;
				num1_display="";num2_display="";
				operand = "";
				break;
			}

			case "+":case "-":case "/":case "X":
			{
				if(num2_display=="num2_display"){
				num2_display = "";
				}

				if(tempStorage!="0"&&!CalculatingFlag){
					num1_display=tempStorage; //这个是为了在计算完毕状态时 令tempStorage直接变更为num1的
					num2_display = ""; 	  //同时将num2_display记录清除
				}
				
				num1InputFlag = false; //它既可以是原生的num1 也可以是 tempstorage变出来的num1 总之不希望它做更改

				operand = buttonText;
				//num1_display.contains(".")?num1 = double.parse(num1_display):num1 = int.parse(num1_display);

				
				break;
			}

			case ".":{
				if(num1InputFlag){
					if(num1_display.contains(".")){
						print("Already conatains a decimals");
						return;
					}

					else{
						num1_display+=".";
					} 
				}

				else{
					if(num2_display.contains(".")){
						print("Already conatains a decimals");
						return;
					}
					
					else{
						num2_display+=".";
					}
				}

				break;
			}

			case "=":{
				calculate();break;
			}


			case "1":case "2":case "3":case "4":case "5":
			case "6":case "7":case "8":case "9":case "0":case "00":{
				currentInputNumber(buttonText);
				
			}




		}


		
		setState(() {});
			

	}



	List<Widget> labelShow (){

		//full Label Show Mode.	
		List<Widget> Label = [
			Padding(padding: EdgeInsets.symmetric(horizontal: 8)),

			TextButton(

				onPressed: (){
					print("num1:${num1_display}");
					num1InputFlag = true;
					setState(() {});
					
				},

				style: ButtonStyle(
					backgroundColor: MaterialStateColor.resolveWith((states){
						if(CalculatingFlag){
							if(num1InputFlag){
								return Color.fromRGBO(233, 182, 30, 0.703);
							}

							else{
								return Colors.transparent;
							}
						}

						return Colors.transparent;

					})
				),
				

				child:SelectableText(
          			key:label_num1Key,
					"$num1_display",//调用output的数据
					showCursor: true, //展示光标
  					autofocus: true, //响应focus事件变动
					focusNode: num1LabelFocus,
					
         			style: TextStyle(
							color: CalculatingFlag?null:Color.fromRGBO(118, 122, 126, 0.627),
							fontSize: CalculatingFlag?24:18,
							fontWeight: FontWeight.bold,
						),
				),
			),

			Padding(padding: EdgeInsets.symmetric(horizontal: 8)),

			Text(
				operand, //调用output的数据
				style: 
					TextStyle(
						color: CalculatingFlag?null:Color.fromRGBO(118, 122, 126, 0.627),
						fontSize: CalculatingFlag?24:18,
						fontWeight: FontWeight.bold,
					)
			),

			

			Padding(padding: EdgeInsets.symmetric(horizontal: 8)),


			TextButton(
				style: ButtonStyle(
					backgroundColor: MaterialStateColor.resolveWith((states){
						if(CalculatingFlag){
							if(!num1InputFlag){
								return Color.fromRGBO(233, 182, 30, 0.703);
							}

							else{
								return Colors.transparent;
							}
						}

						return Colors.transparent;
						
					})
				),
				onPressed: (){
					print("num2:${num2_display}");
					num1InputFlag = false;
					setState(() {});
			
			
				},
				child:Text(
				"$num2_display", //调用output的数据
				style: 
					TextStyle(
						
						color: CalculatingFlag?null:Color.fromRGBO(118, 122, 126, 0.627),
						fontSize: CalculatingFlag?24:18,
						fontWeight: FontWeight.bold,
					)
				)
			),

			Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
					
	];	
		
		if(CalculatingFlag){
			if(num1InputFlag&&num2_display==""){
				Label.removeRange(Label.length-2, Label.length-1);
			}
		}
		

		return Label;


	} 

	



	
	Widget buildButton(String buttonText) {
	return new Expanded(
		
		child: new OutlinedButton(
		style:ButtonStyle(padding: 
			MaterialStateProperty.all(EdgeInsets.all(23))
		),
		
		child: new Text(buttonText,
			style: TextStyle(
				fontSize: 20.0,
				fontWeight: FontWeight.bold
			),
			),
		onPressed: () => buttonPressed(buttonText),

		
		),
	);
	
	
	}


	@override
		Widget build(BuildContext context) {
			return Scaffold(
			appBar: AppBar(title: Text(widget.title)),
			body: 
				GestureDetector(
					behavior:HitTestBehavior.translucent,
					onTap: (){
						
						print("Tap detectd");
						
					},
					child:
					Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Text("SetState Test:${DateTime.timestamp().toLocal().toString()}"),

						Flexible(
							flex: 1,
							child: Row(
								mainAxisAlignment: MainAxisAlignment.end,
								children: labelShow()
							)
						),

						Flexible(
							flex: 1,
							 //Divide分割
								child:
									Row(
										//[!]为什么row需要这个crossAxisAlignment.end才能 重新flex布局?
										crossAxisAlignment: CrossAxisAlignment.end,
										children: [
											const Text(
												"Result",
												textScaleFactor: 1.1,
												style: TextStyle(
													color: Color.fromARGB(135, 80, 129, 227),
													textBaseline: TextBaseline.alphabetic
												),
											
											),
											
											Expanded(
												flex:20,
												child: Divider(
													thickness: 1,
												),
											)
												
										],
									)
							
							
						),


						Container(
								alignment: Alignment.bottomRight,
								padding:EdgeInsets.symmetric(horizontal: 12,vertical: 24),
								child: Text(
									"$result",
									style:TextStyle(
											fontWeight: FontWeight.bold,
											fontSize: 24,
										)
								)
						),
						
							
						
						Row(
							//[!]为什么row需要这个crossAxisAlignment.end才能 重新flex布局?
							crossAxisAlignment: CrossAxisAlignment.end,

							children: [
								const Text(
									"History",
									textScaleFactor: 1.1,
									style: TextStyle(
										color: Color.fromARGB(222, 228, 153, 48),
										textBaseline: TextBaseline.alphabetic
									),
								
								),

								Expanded(
									flex:20,
									child: Divider(
										thickness: 1,
									),
								)

							],
						),
						

						Flexible(
							flex: 1,
							//fit: FlexFit.tight,
								child:
									TextButton(
										onPressed: ()=>showListview(context:context,historyCalculated:historyCalculated,historyResult:historyResult),
										//onPressed: ()=>context.findAncestorStateOfType(),
										style: ButtonStyle(
											mouseCursor: MaterialStateMouseCursor.clickable
										),
										child:
											Container(
												alignment: Alignment.centerRight,
												padding: EdgeInsets.only( //对称放置padding
													right: 12
												),

												child: 
													Text(
														tempStorage,
														style: TextStyle(
															fontSize: CalculatingFlag?18:24,
															color: CalculatingFlag?Color.fromRGBO(118, 122, 126, 0.627):null
														)
													)

											)
									)
						),

									
						Flexible(			
							flex: 0,
							//fit:
							child:
								Column(
									children: [
									Row(children: [
										buildButton("7"),
										buildButton("8"),
										buildButton("9"),
										buildButton("/")
									]),

									Row(children: [
										buildButton("4"),
										buildButton("5"),
										buildButton("6"),
										buildButton("X")
									]),

									Row(children: [
										buildButton("1"),
										buildButton("2"),
										buildButton("3"),
										buildButton("-")
									]),

									Row(children: [
										buildButton("."),
										buildButton("0"),
										buildButton("00"),
										buildButton("+")
									]),

									Row(children: [
										buildButton("CLEAR"),
										buildButton("="),
									])
								])
						)
				])
		
					,
				)
			

			//child:
				);


	
	 
	}


}
