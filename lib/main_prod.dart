import 'package:quy_dao/bootstrap.dart';
import 'package:quy_dao/firebase/firebase_options_prod.dart';

void main() {
  bootstrap(
    environment: AppEnvironment.prod,
    optionsBuilder: () => FirebaseOptionsProd.currentPlatform,
  );
}
