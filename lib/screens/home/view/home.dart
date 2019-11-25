import 'package:candi/screens/screens.dart';
import 'package:candi/services/services.dart';
import 'package:candi/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {

  @override
  _FutureBuilderWidgetState createState() => _FutureBuilderWidgetState();
}

class _FutureBuilderWidgetState extends State<HomePage> {

  PanelController pcontainer = new PanelController();

   @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24), topRight: Radius.circular(24)
    );
    
    return FutureBuilder(
      future: Global.topicsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Topic> topics = snap.data;
          return Scaffold(
           body: 
           SlidingUpPanel(
            defaultPanelState: PanelState.CLOSED,
            controller: pcontainer,
            minHeight: 0,
            maxHeight: 730,
            backdropEnabled: true,
            backdropOpacity: 0.7,
            borderRadius: radius,
            panel: Center(child: FormPage()),
            collapsed: Container(decoration: BoxDecoration(color: Colors.blue, borderRadius: radius),
            child: Center(child: Text('Ajouter un projet', style: TextStyle(color: Colors.blue),),),
            ),
            body: 
            Scaffold(
              appBar: AppBar(
              backgroundColor: Colors.blueGrey[900],
              title: Text('Evènements'),
              actions: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.userCircle,
                      color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
            ),
              drawer: TopicDrawer(topics: snap.data),
              body: ListView(
                primary: false,
                padding: const EdgeInsets.all(30.0),
                children: topics.map((topic) => TopicItem(topic: topic)).toList(),
              ),
              bottomNavigationBar: AppBottomNav(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                    //Navigator.of(context).push(_createRoute());
                  //showFancyCustomDialog(context);
                    if (pcontainer.isPanelClosed()){
                      pcontainer.open();
                    } else {
                      pcontainer.close();
                    }
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
                backgroundColor: Colors.blueGrey[900],
                mini: false,
                isExtended: true,
              ),
            )
          ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
void swipeUp(PanelController state) {
  if (state.isPanelClosed()){
    state.open();
  } else {
    state.close();
  }
}
void showFancyCustomDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child:  Scaffold(
            appBar: new AppBar(
                title: new Text('Ajouter un projet'),
            ),
            body: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    new Expanded(
                        child: new Material(
                            color: Colors.red,
                            child: new Container(
                              color: Colors.white,
                              padding: new EdgeInsets.all(40.0),
                              child: new ListView(children: <Widget>[ 
                                TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: new InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Nom du projet',
                                    hintText: 'Nom du projet',
                                    ),
                                validator: (value) => value.isEmpty ? 'Prénom est manquant' : null,
                                //onSaved: (value) => _firstName = value.trim(),
                              ),
                              TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                decoration: new InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Description',
                                    hintText: 'Description',
                                    ),
                                validator: (value) => value.isEmpty ? 'Prénom est manquant' : null,
                                //onSaved: (value) => _firstName = value.trim(),
                              )
                              ]),
                            ),
                        ),
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 00.0, 0.0),
                      child: SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: new RaisedButton(
                          elevation: 5.0,
                          color: Colors.blue,
                          child: new Text('Valider',
                              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                          onPressed: _createRoute,
                        ),
                      ))
                ],
            ),
        )
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
 }
void showPageSwipUp(BuildContext context) {
  @override
  Widget build(BuildContext context){
    return Material(
      child: SlidingUpPanel(
        backdropEnabled: true,
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: Scaffold(
          appBar: AppBar(
            title: Text("SlidingUpPanelExample"),
          ),
          body:  Center(
            child: Text("This is the Widget behind the sliding panel"),
          ),
        ),
      ),
    );
  }
}
//Motor of enter/exit modal
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => FormPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Page Title'),
      ),
      body: Center(
        child: Text('Page 2'),
      ),
    );
  }
}
class MyWiget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text('Proposer votre souhait'),
        actions: <Widget>[
           new IconButton(
             alignment: Alignment.topLeft,
             icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
           ),
         ],
        leading: new Container(),
      ),
        body: Screen2(),
        );
  }
}
class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16.0),
          //key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLastNameInput(),
            ],
          ),
        );
  }
}
Widget showLastNameInput() {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
               Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.album),
                        title: Text('The Enchanted Nightingale'),
                        subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                      ),
                      ButtonTheme.bar( // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('BUY TICKETS'),
                              onPressed: () { /* ... */ },
                            ),
                            FlatButton(
                              child: const Text('LISTEN'),
                              onPressed: () { /* ... */ },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
  )
            ],
          ),
        );
  }
//Motor of short route
class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
               FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}

class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({Key key, this.topic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: topic.img,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => TopicScreen(topic: topic),
                ),
              );
            },
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/covers/${topic.img}',
                  fit: BoxFit.cover,
                  height: 160,
                  width: 500,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 0),
                        child: Text(
                          topic.title,
                          style: TextStyle(
                              height: 1.5, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
                    // Text(topic.description)
                  ],
                ),
                // )
                TopicProgress(topic: topic),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class TopicScreen extends StatelessWidget {
  final Topic topic;
  TopicScreen({this.topic});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: topic.img,
          child: Image.asset('assets/covers/${topic.img}',
              width: MediaQuery.of(context).size.width),
        ),
        Text(
          topic.title,
          style:
              TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        QuizList(topic: topic)
      ]),
    );
  }
}
class QuizList extends StatelessWidget {
  final Topic topic;
  QuizList({Key key, this.topic});
  @override
  Widget build(BuildContext context) {
    return Column(
        children: topic.quizzes.map((quiz) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0.2,
        margin: EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                quiz.title,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                quiz.description,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.subhead,
              ),
              leading: QuizBadge(topic: topic, quizId: quiz.id),
            ),
          ),
        ),
      );
    }).toList());
  }
}
class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  TopicDrawer({Key key, this.topics});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: topics.length,
          itemBuilder: (BuildContext context, int idx) {
            Topic topic = topics[idx];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1, left: 10),
                  child: Text(
                    topic.title,
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                QuizList(topic: topic)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int idx) => Divider()),
    );
  }
}