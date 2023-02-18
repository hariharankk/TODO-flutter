import 'package:flutter/material.dart';
import 'package:todolist/ui/pages/authenticate/alreadyhaveaaccount.dart';
import 'package:todolist/ui/pages/authenticate/login_page.dart';
import 'package:todolist/ui/pages/authenticate/validate.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/main.dart';

class register extends StatefulWidget {

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  late String _email;
  late String _password;
  late String _phoneNumber;
  late String _username;
  late String _errorMessage = '';
  late bool _isLoading = false;

  Future get _attemptSignUp async {
    userBloc
        .registerUser(
        _email,_password,_phoneNumber,_username
        )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "வெற்றிகரமான பதிவு",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, Splash.routeName);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              userInput(),
              showEmailInput(),
              showPasswordInput(),
              showPhoneInput(),
              SizedBox(
                height: 20.0,
              ),
              showErrorMessage(_errorMessage),
              showPrimaryButton(),
              SizedBox(
                height: 30.0,
              ),
              AlreadyHaveAnAccountCheck(login: false,
                press: () async{
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )
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

  Widget showLogo() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.jpg'),
        ),
    );
  }

  Widget showErrorMessage(String text) {
    if (text.length > 0 && text != null) {
      return new Text(
        text,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }


  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்",
          icon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
        value!.isEmpty
            ? 'எண் காலியாக இருக்கக்கூடாது' //Number can\'t be empty
            : new Validate().verfiyMobile(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'தங்கள் கடவு சொல்லை பதிவு செய்யவும்', //Please enter your Password
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'கடவுச்சொல் காலியாக இருக்கக்கூடாது' : null, //Password can\'t be empty
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'தயவுசெய்து உங்கள் மின்னஞ்சலை உள்ளிடவும்', //Please enter your Email
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'மின்னஞ்சல் காலியாக இருக்கக்கூடாது' : null, //Email can\'t be empty
        onChanged: (value) => _email = value.trim(),
      ),
    );
  }

  Widget userInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: 'உங்கள் பயனர்பெயரை உள்ளிடவும்', //Please enter your Email
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'பயனர் பெயர் காலியாக இருக்கக்கூடாது' : null, //Email can\'t be empty
        onChanged: (value) => _username = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new ElevatedButton(
          // elevation: 5.0,
          // shape: new RoundedRectangleBorder(
          //     borderRadius: new BorderRadius.circular(30.0)),
          // color: Colors.blue,
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)
              )
          ),
          child: new Text('பதிவு', //Register
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: ()=> _attemptSignUp
        ),
      ),
    );
  }
}