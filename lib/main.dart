import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class ThreadSummary {
  final String sender;
  final String subject;
  final String snippet;
  final List<String> attachments;
  final String avatarUrl;
  bool star;
  final DateTime time;

  ThreadSummary(
    this.sender,
    this.subject,
    this.snippet,
    this.attachments,
    this.avatarUrl,
    this.star,
    this.time,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gmail'),
    );
  }
}

var threads = <ThreadSummary>[
    ThreadSummary(
      '鰓魚龍',
      'test',
      'snippet',
      ['attachment1', 'attachement2'],
      'images/2.jpg',
      true,
      DateTime.now(),
    ),
    ThreadSummary(
      '快龍',
      'test test test',
      'snippet',
      [],
      'images/3.jpg',
      true,
      DateTime.now(),
    ),
    ThreadSummary(
      '耿鬼',
      'hello world',
      'snippet',
      ['attachment1'],
      'images/4.jpg',
      true,
      DateTime.now(),
    ),
  ];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String getCurrentTimeAsString(DateTime now) {
    final formatter = DateFormat('MM月dd日');
    return formatter.format(now);
  }

class _MyHomePageState extends State<MyHomePage> {
  
  var _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        titleSpacing: 0,  
        elevation: 0,
        title: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜尋...',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search,color:Colors.white),
                //border: OutlineInputBorder(),
              ),
            ),
          ),
        actions: [ 
          
          CircleAvatar(
              backgroundImage: AssetImage('images/1.jpg'),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
        // drawerHeader,
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              title: Text(
                "Gmail",
                style: TextStyle(fontSize: 30),
              ),
              textColor: Colors.red,
            ),
            Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            ListTile(
              title: Text("收件匣"),
              leading: const Icon(Icons.inbox),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("已加星號"),
              leading: const Icon(Icons.star_border),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("已延後"),
              leading: const Icon(Icons.access_time_outlined),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changepage,
        currentIndex: _page,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            label: ' ',
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(itemBuilder:_itemBuilder, itemCount:threads.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {print('there');},
        child: Icon(Icons.edit),
      ),
      
    );
    
  }
  void _changepage(index){
    setState(() {
      _page = index; //state切換
    });
  }

  Widget _itemBuilder(BuildContext context, int index)
  {
    final thread = threads[index]; 
    IconData icon;
    icon = thread.star ? Icons.favorite : Icons.favorite_border;
    return Card( 
        elevation: 0,
        child: InkWell(
            onTap: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MailPage(mail: thread)),
              );
              setState((){});
              print('state refresh');
            },
            child: 
            ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(thread.avatarUrl),
              ),
            title: Text(
              thread.sender,
              style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
              ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thread.subject,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(thread.snippet),
                SizedBox(height: 8,),
                Row(
                  children: thread.attachments.map(_buildAttachmentButton).toList(),
                ),
              ],
            ),
          trailing: Column(
            children: [
              Text(getCurrentTimeAsString(threads[index].time).toString()),
              Expanded(
                        child: IconButton(icon: threads[index].star
                          ?Icon(Icons.star)
                          :Icon(Icons.star_border),
                          onPressed: () => setState((){threads[index].star = !threads[index].star;})
                          ),
                      ),          
              ],
            ),
          ),
        ),  
    );
  }

  // String getCurrentTimeAsString(DateTime now) {
  //   final formatter = DateFormat('MM月dd日');
  //   return formatter.format(now);
  // }

  Padding _buildAttachmentButton(String attachment){
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: OutlinedButton(
            onPressed: () => print('pressed2'),
            child: Text(attachment),
          ),
      );
    }
}

class MailPage extends StatefulWidget {
    ThreadSummary mail;
    MailPage({
      super.key,
      required this.mail,
    });

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Route'),
          actions: [ 
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.mail),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: [
        // drawerHeader,
            ListTile(
              //contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              title: Text(
                widget.mail.subject,
                style: TextStyle(fontSize: 20),
              ),
              textColor: Colors.red,
              trailing: IconButton(icon: widget.mail.star
                          ?Icon(Icons.star)
                          :Icon(Icons.star_border),
                          onPressed: () => setState((){widget.mail.star = !widget.mail.star;})
                          ),
            ),
            Divider(
              color: Color.fromARGB(255, 240, 236, 236),
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.mail.avatarUrl),
              ),
              title: Row(
                children: [
                  Text(widget.mail.sender),
                  SizedBox(width:10),
                  Text(
                    getCurrentTimeAsString(widget.mail.time).toString(),
                     style: TextStyle(fontSize: 10, color: Colors.grey),
                     )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  SizedBox(height: 8),
                  Text('To me'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.reply),
                  Icon(Icons.more_vert),
                ],
              ),
            ),
            Card(
              color:Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:50),
                  Text(widget.mail.snippet),
                ]
              )
            ),
            ListTile(
              title: Text("已延後"),
              leading: const Icon(Icons.access_time_outlined),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
}
