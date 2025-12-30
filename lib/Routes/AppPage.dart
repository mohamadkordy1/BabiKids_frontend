import 'package:get/get.dart';
import '../Bindings/UserBinding.dart';
import 'AppRoute.dart';
import '../Views/Login.dart';
import '../Bindings/LoginBinding.dart';
import '../Views/Registration.dart';
import '../Bindings/RegistrationBinding.dart';
import '../Views/Parent/parent_home.dart';
import 'package:frontend/Views/Parent/parent_shell.dart';
import 'package:frontend/Views/Teacher/Teacher_Home.dart';
import 'package:frontend/Views/Admin/SelectParentPage.dart';
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

  GetPage(
    name: AppRoute.home,
    page: () => ParentHome(),
    binding: UserBinding(),
  ),GetPage(
    name: AppRoute.admin,
    page: () => SelectParentPage(),
    binding: UserBinding(),
  ),
  GetPage(
    name: AppRoute.parentShell,
    page: () => ParentShell(),
  ),
  GetPage(
    name: AppRoute.teacherDashboard,
    page: () => const TeacherDashboardPage(),
  ),
]
;
}