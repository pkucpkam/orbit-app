import 'package:quy_dao/bootstrap.dart';
import 'package:quy_dao/firebase/firebase_options_dev.dart';

void main() {
  bootstrap(
    environment: AppEnvironment.dev,
    optionsBuilder: () => FirebaseOptionsDev.currentPlatform,
  );
}
