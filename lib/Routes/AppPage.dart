import 'package:get/get.dart';
import 'AppRoute.dart';
import '../Views/Login.dart';
import '../Bindings/LoginBinding.dart';
import '../Views/Registration.dart';
import '../Bindings/RegistrationBinding.dart';
class AppPage {


static final List<GetPage> pages =[
  GetPage(
name: AppRoute.login,
page: () => Login(),
binding: Loginbinding(),

),
GetPage(
name: AppRoute.registrater,
page: () => Registration(),
binding: RegistrationBinding(),
),



]
;
}