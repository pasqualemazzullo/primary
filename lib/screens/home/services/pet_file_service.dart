import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:watcher/watcher.dart';

class PetFileService {
  late File _file;
  late FileWatcher _fileWatcher;
  bool _isRefreshing = false;

  Future<void> initFileWatcher({required Function() onFileChanged}) async {
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/pet_data.json');

    _fileWatcher = FileWatcher(_file.path);
    _fileWatcher.events.listen((event) {
      if (event.type == ChangeType.MODIFY) {
        onFileChanged();
      }
    });
  }

  Future<List<Map<String, dynamic>>> loadPetsFromFile() async {
    if (_isRefreshing) return [];

    _isRefreshing = true;

    try {
      if (await _file.exists()) {
        final String fileData = await _file.readAsString();
        final List<dynamic> jsonData = jsonDecode(fileData);

        _isRefreshing = false;

        final pets = List<Map<String, dynamic>>.from(jsonData);

        pets.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        return pets;
      } else {
        _isRefreshing = false;
        return [];
      }
    } catch (e) {
      _isRefreshing = false;
      return [];
    }
  }

  File get file => _file;

  Future<bool> fileExists() async {
    return await _file.exists();
  }
}
