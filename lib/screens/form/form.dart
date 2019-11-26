import 'package:candi/services/services.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {

  FormPage();

  @override
  State<StatefulWidget> createState() => new _WishPageState();
}

// Shared Data
class WhishState with ChangeNotifier {
  double _progress = 0;
  Option _selected;
  bool _isLoading;
  String _errorMessage;

  final PageController controller = PageController();

  get progress => _progress;
  get selected => _selected;

  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  set selected(Option newValue) {
    _selected = newValue;
    notifyListeners();
  }

  void nextPage() async {
    await controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
  }

  // Perform login or signup
  void validateAndSubmit() async {
    //
    }
}

class _WishPageState extends State<FormPage> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _lastName;
  String _firstName;
  String _errorMessage;
  bool _isLoginForm;
  bool _isLoading;
  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          //userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          //userId = await widget.auth.signUp(_email, _password, _firstName, _lastName);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null) {
         // widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*appBar: AppBar(
              backgroundColor: Colors.blueGrey[900],
              title: Text('Evènements'),
              actions: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.userCircle,
                      color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
            ),*/
        body: _showForm()
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //showLogo(),
              showFirstNameInput(),
              showLastNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              //showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          //child: Image.asset('assets/covers/angular.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          hintText: 'Nom du projet',
          //helperText: 'Nom du projet',
          labelText: 'Nom du projet'
          ),
        validator: (value) => value.isEmpty ? 'Email est manquant' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showLastNameInput() {
    if (!_isLoginForm){
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
            border: UnderlineInputBorder(),
          filled: true,
          hintText: 'Description',
          //helperText: 'Nom du projet',
          labelText: 'Description'
          ),
          validator: (value) => value.isEmpty ? 'Nom est manquant' : null,
          onSaved: (value) => _lastName = value.trim(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showFirstNameInput() {
    if (!_isLoginForm){
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
              hintText: 'Prénom',
              icon: new Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Prénom est manquant' : null,
          onSaved: (value) => _firstName = value.trim(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            border: UnderlineInputBorder(),
          filled: true,
          hintText: 'Description',
          //helperText: 'Nom du projet',
          labelText: 'Description'
          ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Créer un compte' : 'Avez-vous déjà un compte? Connexion',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }
  
  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(40.0, 45.0, 40.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: 30.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Valider' : 'Créer un compte',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}