import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage{

  static final stor = new FlutterSecureStorage();

  static void storeUser(String user, String pass, String fname, String lname, String tname, String email, String tel){
    stor.write(key:"user", value:user);
    stor.write(key:"pass", value:pass);
    stor.write(key:"firstName", value:fname);
    stor.write(key:"lastName", value:lname);
    stor.write(key:"teamName", value:tname);
    stor.write(key:"email", value:email);
    stor.write(key:"tel", value:tel);
  }

  static Future<List<String>> getUserData() async{
    List<String> data = [];

    data.add(await stor.read(key: "firstName"));
    data.add(await stor.read(key: "lastName"));
    data.add(await stor.read(key: "teamName"));
    data.add(await stor.read(key: "email"));
    data.add(await stor.read(key: "tel"));
    data.add(await stor.read(key:"pass"));

    return new Future(() => data);
  }

  static void logoutUser(){
    stor.write(key:"user", value:null);
    stor.write(key:"pass", value:null);

  }

//  static void storePlace(List<String> answer){
//    stor.write(key: "answers", value: );
//  }

  static Future<String> getUser(){
    return stor.read(key:"user");
  }

  static Future<String> getPass(){
    return stor.read(key:"pass");
  }

}