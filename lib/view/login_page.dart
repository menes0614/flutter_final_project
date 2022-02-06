import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/view/doctor/doctor_home_page.dart';
import 'package:flutter_final_project/view/patient/patient_home_page.dart';
import 'package:flutter_final_project/view/sign_up.dart';

class LoginIslemleri extends StatefulWidget {
  LoginIslemleri({Key? key}) : super(key: key);

  @override
  State<LoginIslemleri> createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController sifrecontroller = TextEditingController();
  String _email = "";
  String _password = "";
  var girisKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.pink.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: girisKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              // Container(
              //   width: 200,
              //   height: 150,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //     image: AssetImage("assets/images/partnership.png"),
              //   )),
              // ),
              Text(
                "Doktor Hasta Haberleşme Sistemi",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'LoginFont', fontSize: 30, color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              //Email giriş
              TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "E mail",
                  labelText: "E mail",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onSaved: (girilenEmail) {
                  if (girilenEmail!.isEmpty) {
                    debugPrint("durum if e düstü!!!!");
                    //_showDialog();
                  }
                  _email = girilenEmail;
                },
              ),
              SizedBox(height: 10),
              //Şifre Giriş
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Colors.white,
                  hintText: "Şifre",
                  labelText: "Şifre",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onSaved: (girilenSifre) {
                  _password = girilenSifre!;
                },
              ),
              SizedBox(height: 10),
              // GirişButonu
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.purple),
                ),
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                label: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.purple,
                onPressed: _emailSifreKullaniciGirisyap,
              ),
              //Üye ol Butonu
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    side: BorderSide(color: Colors.purple),
                  ),
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Üye Ol",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UyeOl(_auth)));
                  }),
              // cıkıs yap
            ],
          ),
        ),
      ),
    );
  }

  void _emailSifreKullaniciGirisyap() async {
    // girilen degerler degiskenlere save methodu ile atanır.
    girisKey.currentState!.save();
    try {
      // Yönetici kontolü
      _firebaseFirestore.collection("Doktorlar").get().then((gelenVeri) async {
        for (int i = 0; i < gelenVeri.docs.length; i++) {
          if ((gelenVeri.docs[i].data()['Email']) == _email) {
            User _oturumAcanYonetici = (await _auth.signInWithEmailAndPassword(
                    email: _email, password: _password))
                .user!;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorHomePage(),
              ),
            );
          }
        }
      });

      // Uye kontrolü
      _firebaseFirestore.collection("Hastalar").get().then((gelenVeri) async {
        for (int i = 0; i < gelenVeri.docs.length; i++) {
          if (gelenVeri.docs[i].data()['Email'] == _email) {
            User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
                    email: _email, password: _password))
                .user!;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatientHomePage()),
            );
          }
        }
      });
    } catch (e) {
      debugPrint("Oturum Açarken HATA!:" + e.toString());
    }
  }

  void _cikisYap() async {
    try {
      // sistemde kullanıcı varsa çıkış yapılır
      if (_auth.currentUser != null) {
        debugPrint("${_auth.currentUser!.email} sistemden çıkıyor");
        await _auth.signOut();
      } else {
        // sistemde zaten bir kullanıcı yoksa sorun yok
        debugPrint("Zaten oturum açmış bir kullanıcı yok");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
