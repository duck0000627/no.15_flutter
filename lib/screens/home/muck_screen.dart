import 'package:flutter/material.dart';

import 'home_screen.dart';

class MuckScreen extends StatefulWidget{
  const MuckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MuckScreenState();
}

class _MuckScreenState extends State<MuckScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('肥料資材使用紀錄'), backgroundColor: Colors.green),
      drawer: Drawer(
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Text('選單')
              ),
              ListTile(
                title: Text('農場工作紀錄'),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('肥料資材使用紀錄'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MuckScreen()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          //標題
          Container(
            color: Colors.green[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    '日期',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '資材名稱',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '施肥別',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      //新增按鈕
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

        },
        child: FittedBox(
          child: Image.asset('assets/pen.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

}

