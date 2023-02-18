import 'package:todolist/ui/pages/authenticate/validate.dart';
import 'package:flutter/material.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/ui/pages/authenticate/alreadyhaveaaccount.dart';
import 'package:todolist/ui/pages/authenticate/signup_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String _email;
  late String _password;
  late String _phoneNumber;
  late String _smsCode;
  late String _errorMessage;

  late bool _isLoading;
  late bool _isPhone;
  late bool _codeSent = false;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _codeSent = false;
    _isPhone = true;
    super.initState();
  }

  void toggleEmailAndPhone() {
    setState(() {
      _isPhone = !_isPhone;
    });
  }

  Future get _attemptLogin async {
    try {
      await userBloc.signinUser(_email, _password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "வெற்றிகரமான உள்நுழைவு",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      await  Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  @override
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
              !_isPhone ? showEmailInput() : Container(),
              !_isPhone ? showPasswordInput() : Container(),
              _isPhone ? showPhoneInput() : Container(),
              SizedBox(
                height: 20.0,
              ),
              showErrorMessage(),
              showPrimaryButton(),
              SizedBox(
                height: 30.0,
              ),
              _codeSent ? Container() : showSecondaryButton(),
              SizedBox(
                height: 20.0,
              ),
              AlreadyHaveAnAccountCheck(login: false,
                press: () async{
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return register();
                      },
                    ),
                  );
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ));
  }

  Widget showLogo() {
    return  Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.jpg'),
        ),
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

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
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


  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child:  TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'மின்னஞ்சல்', //Email
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'மின்னஞ்சல் காலியாக இருக்கக்கூடாது': null, //'Email can\'t be empty'
        onChanged: (value) => _email = value.trim(),
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
          hintText: 'கடவுச்சொல்', //'Password'
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'கடவுச்சொல் காலியாக இருக்க முடியாது' : null, //'Password can\'t be empty'
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPhoneInput() {
    return _codeSent
        ? showSmsCodeInput()
        : Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "தொலைபேசி எண்",
          icon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty
            ? 'எண் காலியாக இருக்கக்கூடாது' //Number can\'t be empty
            : new Validate().verfiyMobile(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showSmsCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "OTP ஐ உள்ளிடவும்",
          icon: Icon(
            Icons.keyboard,
            color: Colors.grey,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty
            ? 'எண் காலியாக இருக்கக்கூடாது' //Number can\'t be empty
            : new Validate().verifyOTP(value),
        onChanged: (value) => _smsCode = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)
              )),
          // elevation: 5.0,
          // shape: new RoundedRectangleBorder(
          //     borderRadius: new BorderRadius.circular(30.0)),
          // color: Colors.blue,
          child: new Text(
            _isPhone ? (_codeSent ? 'உள்நுழைய' : 'தொலைபேசியைச் சரிபார்க்கவும்') : 'உள்நுழைய',
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: () => _attemptLogin
          ,
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return InkWell(
      onTap: toggleEmailAndPhone,
      child: Center(
        child: _isPhone
            ? Text(
          "மின்னஞ்சலில் உள்நுழைக", //"Sign in with Email"
          textScaleFactor: 1.1,
        )
            : Text(
          "தொலைபேசி எண்ணுடன் உள்நுழைக", //"Sign in with Phone Number"
          textScaleFactor: 1.1,
        ),
      ),
    );
  }
}
