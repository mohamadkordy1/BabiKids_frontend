import 'package:get/get.dart';
import '../Models/Progress.dart' as model;
import '../Services/ProgressService.dart';

class ProgressController extends GetxController {
  final ProgressService _service = ProgressService();

  var progresses = <model.Progress>[].obs;
  var isLoading = false.obs;

  Future<void> loadProgressForClass(int classroomId) async {
    try {
      isLoading(true);

      final allProgresses = await _service.fetchProgresses();

      progresses.value = allProgresses
          .where((p) => p.classroomId == classroomId)
          .toList();
    } catch (e) {
      print('Failed to load progresses: $e');
    } finally {
      isLoading(false);
    }
  }
}
