import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'loginPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
 // final token;
 // const Dashboard({}) : super();
  final token;
  const Dashboard({@required this.token,Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late String userId;
 late String testId;
 late String _selectedItem;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
    TextEditingController _controller = TextEditingController();

  List? itemsnew;
  List? items;
  String? _selectedValue;
  List<dynamic> _responseData = [];
  List<dynamic> _tableData = [
    // {'StationName': 'John', 'Amount': 5,"DateTime":"2023-03-23T12:29:00.000Z","Status":"REQUESTED"},
    // {'StationName': 'Alice', 'Amount': 3,"DateTime":"2023-03-25T12:29:00.000Z","Status":"REQUESTED"},
    // {'StationName': 'Bob', 'Amount': 2,"DateTime":"2023-03-236T12:29:00.000Z","Status":"REQUESTED"},
    // {'StationName': 'Jane', 'Amount': 5,"DateTime":"2023-03-25T12:29:00.000Z","Status":"REQUESTED"},
  ];
   int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    print("init statae click");
    print(widget.token);
   // userId = jwtDecodedToken['_id'];
   testId = widget.token;
    getTodoList();
    getAllRequests();
  }

  void addTodo() async{
     print('new data new');
     print(_todoTitle.text);
     print('new data new');
     print(_controller.text);
      print('new data new');
     print(_selectedValue);
    if(_todoTitle.text.isNotEmpty && _controller.text.isNotEmpty){
      print('new data new111');
        final inputString = _controller.text;
        final inputDateFormat = DateFormat('yyyy-MM-dd h:mm a');
        final inputDate = inputDateFormat.parse(inputString);
        final outputDateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
        final formattedDate = '${outputDateFormat.format(inputDate)}Z';
        //final dateString = '2023-03-08T04:20:00.000.000Z';
     //   final date = DateTime.parse(dateString);
     //  final formattedDate1 = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(date);
       print(formattedDate); // Output: "2023-03-08T04:20:00.000Z"
     //   print(formattedDate1); // Output: 2023-03-08T14:54:00.000Z
      // var regBody = {
      //   //"userId":userId,
      //   "amount":_todoTitle.text,
      //   "date":formattedDate,
      //   "station":_selectedValue
      // };
      var regBody ={
    "amount":int.parse( _todoTitle.text),
    "date": formattedDate,
    "station": _selectedValue
};
      print('new data new');
      print(regBody);
       print('new data new');
      var response = await http.post(Uri.parse(addtodo + testId),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse);

      if(jsonResponse['status'] == 'REQUESTED'){
        print("sucessssssssss");
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList();
        getAllRequests();
      }else{
        print("SomeThing Went Wrong");
      }
    }
  }

  void getTodoList() async {
    // var regBody = {
    //   "userId":userId
    // };

    var response = await http.get(Uri.parse(getToDoList),
        headers: {"Content-Type":"application/json"},
        //body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    itemsnew = jsonResponse['data'];
    
    print(itemsnew);
    setState(() {
      _responseData = jsonResponse['data'];
    });
  }
    void getAllRequests() async {
    // var regBody = {
    //   "userId":userId
    // };

    var response = await http.get(Uri.parse(getALLUserStations + testId),
        headers: {"Content-Type":"application/json"},
        //body: jsonEncode(regBody)
    );
  //  final datanew = jsonDecode(response.body) as List<Map<String, dynamic>>;
    var jsonResponse = jsonDecode(response.body);
   // itemsnew = jsonResponse['data'];
    print("all data");
    print(jsonResponse);
    setState(() {
      _tableData = jsonResponse['data'];
    });
  }

  void deleteItem(id) async{
    var regBody = {
      "id":id
    };

    // var response = await http.post(Uri.parse(deleteTodo),
    //     headers: {"Content-Type":"application/json"},
    //     body: jsonEncode(regBody)
    // );

    // var jsonResponse = jsonDecode(response.body);
    // if(jsonResponse['status']){
    //   getTodoList(userId);
    // }

  }
Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
      if (pickedTime != null) {
        final DateTime dateTime = DateTime(picked.year, picked.month, picked.day,
            pickedTime.hour, pickedTime.minute);
        setState(() {
          _controller.text = '${dateTime.toLocal()}'.split(' ')[0] + ' ${pickedTime.format(context)}';
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 CircleAvatar(
                  child: Icon(Icons.list,size: 30.0,),
                  backgroundColor: const Color(0XFFF95A3B),
                  //backgroundColor: Colors.white,
                  radius: 30.0,),
                 SizedBox(height: 10.0),
                 Text('Fuel Management System User Dashboard',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700),),
                 SizedBox(height: 8.0),
                 Text('Fuel Requests',style: TextStyle(fontSize: 20),),

               ],
             ),
           ),
           Expanded(
               child: SingleChildScrollView(
              child: DataTable(
          columns: [
            DataColumn(label: Text('Station Name')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date Time')),
            DataColumn(label: Text('Status')),
          ],
          rows: _tableData.map((data) => DataRow(
            cells: [
              DataCell(Text(data['station'])),
              DataCell(Text(data['amount'].toString())),
              DataCell(Text(data['date'].toString())),
              DataCell(Text(data['status'].toString())),
            ],
          )).toList(),
         dividerThickness: 1, // thickness of the divider lines
            // dividerColor: Colors.grey[400], // color of the divider lines
            columnSpacing: 16, // spacing between columns
            //: MaterialStateColor.resolveWith((states) => Colors.grey[300]), // color of the header row
          //  dataRowColor: MaterialStateColor.resolveWith((states) {
           //   int rowIndex = _tableData.indexWhere((element) => element['Status'] == 'Rejected');
             // return rowIndex != -1 && rowIndex % 2 == 0 ? Colors.grey[100] : Colors.transparent;
            //}), // color of the rows
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold), // style of the header text
            dataTextStyle: TextStyle(fontSize: 14), // style of the data text
        ),
      ),
    )
            
          
         ],
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_displayTextInputDialog(context) ,
         backgroundColor: const Color(0XFFF95A3B), // set background color
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',

      ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
          },
          child: Container(
              height: 25,
              color: const Color(0XFFF95A3B),
              child: Center(child: "Logout here..! Logout".text.white.makeCentered())),
        ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 250, 250, 250),
            title: Text('Add To-Do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Amount",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                // TextField(
                //   controller: _todoDesc,
                //   keyboardType: TextInputType.text,
                //   decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Colors.white,
                //       hintText: "Description",
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                // ).p4().px8(),
                TextField(
                  readOnly: true,
                  controller: _controller,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Select date and time",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                              onTap: () => _selectDateTime(context),
                ).p4().px8(),
                 Text(
            'Select station:',
            style: TextStyle(fontSize: 16.0),
          ).p4().px8(),   
                  DropdownButton<String>(
            isExpanded: true,
            value: _selectedValue,
            items: _responseData.map<DropdownMenuItem<String>>((dynamic item) {
              return DropdownMenuItem<String>(
                value: item['_id'],
                child: Text(item['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          SizedBox(height: 16.0).p4().px8(),
         ElevatedButton(
  onPressed: (){
    addTodo();
  },
  child: Text("Add"),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0XFFF95A3B), // Change the color here
  ),
)

        

                // ElevatedButton(onPressed: (){
                //   addTodo();
                //   }, child:
                //   Text("Add")),
                  
              ],
            )
          );
        });
  }
}