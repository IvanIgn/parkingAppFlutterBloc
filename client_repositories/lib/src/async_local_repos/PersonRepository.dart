import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_server_stuff.dart';

class PersonRepository {
  static final PersonRepository instance = PersonRepository._();
  PersonRepository._();

  final Box<Person> personBox = ServerConfig.instance.store.box<Person>();

  Future<Person?> add(Person item) async {
    personBox.put(item, mode: PutMode.insert);

    // above command did not error
    return item;
  }

  Future<Person?> getById(int id) async {
    return personBox.get(id);
  }

  Future<List<Person>?> getAll() async {
    return personBox.getAll();
  }

  Future<Person?> update(int id, Person item) async {
    personBox.put(item, mode: PutMode.update);
    return item;
  }

  Future<Person?> delete(int id) async {
    Person? item = personBox.get(id);

    if (item != null) {
      personBox.remove(id);
    }

    return item;
  }
}
