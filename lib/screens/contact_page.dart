import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/email_svc.dart';
import 'package:pelita_app/widgets/app_bar.dart';
import 'package:pelita_app/widgets/app_drawer.dart';
import 'package:pelita_app/widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name, _email, _subject, _text;

  Color _inputColor = Color(0xffF37224);

  String _isEmpty(String value) => (value.isEmpty) ? 'the field is required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PelitaAppBar(screenTitle: "Kontak Form", screenType: ScreenType.pelita_youth),
        endDrawer: AppDrawer(),
        bottomNavigationBar: PelitaBottomNavBar(selectedIndex: 2),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: RichText(
                  text: TextSpan(
                         style: Theme.of(context).textTheme.subtitle1,
                         children: [
                           TextSpan(text: 'Jika anda ingin menghubungi kami, silahkan untuk mengirimkan email ke '),
                           TextSpan(text: 'info@pelita.net ', style: TextStyle(color: _inputColor), 
                             recognizer: TapGestureRecognizer()
                                         ..onTap = () async => await launch('mailto:info@pelita.net') ),
                           TextSpan(text: 'atau dapat mengisi form di bawah ini.'),
                  ]))
                ),
                ListTile(
                  leading: Icon(Icons.person, color: _inputColor),
                  title: TextFormField(
                    validator: (value) => _isEmpty(value),
                    onChanged: (value) => _name = value,
                    decoration: InputDecoration(
                        hintText: "Nama \*",
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _inputColor))),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: _inputColor),
                  title: TextFormField(
                    onChanged: (value) => _email = value,
                    validator: (value) {
                      String errorMsg = _isEmpty(value);
                      return errorMsg != null ? errorMsg : (isEmail(value) ? null : 'not valid email');
                    },
                    decoration: InputDecoration(
                        hintText: "Email \*",
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _inputColor))),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.subject, color: _inputColor),
                  title: TextFormField(
                    onChanged: (value) => _subject = value,
                    validator: (value) => _isEmpty(value),
                    decoration: InputDecoration(
                        hintText: "Subjek \*",
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _inputColor))),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.comment, color: _inputColor),
                  title: TextFormField(
                    onChanged: (value) => _text = value,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Pesan (opsional)",
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _inputColor))),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.send, color: _inputColor),
                    title: const Text("KIRIM", style: TextStyle(color: Color(0xffF37232), fontWeight: FontWeight.bold)),
                    //subtitle: const Text('Kirim Feedback', style: TextStyle(color: Color(0xffF37232))),
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.

                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Mengirim Pesan')));

                        await svc<EmailService>().sendFeedback(name: _name, subject: _subject, from: _email, text: _text);
                       
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Pesan sudah berhasil di kirim'), backgroundColor: Colors.green[900],));
                         _formKey.currentState.reset();
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
