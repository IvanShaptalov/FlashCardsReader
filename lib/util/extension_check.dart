import 'package:path/path.dart' as p;

String getExtension(String path) {
  return p.extension(path);
}

String getName(String path) {
  return p.basename(path);
}
