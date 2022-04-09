import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "CONTACT";
final String idColumn = 'ID_COLUMN';
final String nameColumn = 'NAME_COLUMN';
final String emailColumn = 'EMAIL_COLUMN';
final String telefoneColumn = 'TEL_COLUMN';
final String imgColumn = 'IMG_COLUMN';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null)
      return _db;
    else
      _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, "
          "$telefoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database database = await db;
    contact.id = await database.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database database = await db;

    List<Map> maps = await database.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, telefoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteContact(int id) async {
    Database database = await db;
    return await database
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database database = await db;
    return await database.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> listContacts() async { 
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database database = await db;
    return Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT (*) FROM $contactTable"));
  }

  Future close() async {
    Database database = await db;
    database.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String telefone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img
    };
    if (id != null) map[idColumn] = id;
    return map;
  }

  @override
  String toString() {
    return "Contact($id | $name | $email | $telefone | $img)";
  }
}
