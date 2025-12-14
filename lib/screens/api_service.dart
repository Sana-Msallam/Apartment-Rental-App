import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://github.com/Hala-Erksousi/Sakani.git',//الرابط تبع السيرفر
      connectTimeout: const Duration(seconds: 5),    // إذا حاول التطبيق الاتصال بالسيرفر ولم يرد السيرفر خلال 5 ثوانٍ، سيعتبر أن الاتصال فشل
     //  (مفيد جداً إذا كان الإنترنت ضعيفاً) الزمن يلي حيطلع فيه الطلب
      receiveTimeout: const Duration(seconds: 5),   //الزمن يلي حيرجع فيه الرد (التوكن)
      //: إذا اتصل التطبيق وبدأ السيرفر يرسل بيانات لكنه تأخر أكثر من 3 ثوانٍ في إكمال الإرسال، سيتم قطع العملية (للحفاظ على أداء التطبيق).
    ),
  );
  Future<Response?> login(String phone, String password) async {
    try {
      Response response = await _dio.post(
        'login',//end point
        data: {'password': password, 'phone': phone},
      );
      if (response.statusCode == 200) {
        return response.data; // هذا عادة يحتوي على التوكن (Token) ومعلومات المستخدم
      }
      return null; // نرجع null إذا كان Status Code غير 200 (مثل 401: Unauthorized)

    } on DioException catch (e) {
      // 💡 معالجة أخطاء Dio (مثل Timeouts أو أخطاء 400/500)
      print("Dio Error: ${e.message}");
      return null;
    } catch (e) {
      print("General Error: $e");
      return null;
    }
}
  Future<Response?> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String dateOfBirth,
    required File personalImage,
    required File idImage,
    required Function(int sent, int total) onProgressUpdate,
  }) async {
    try {
      //  إعداد بيانات الصور كـ MultipartFile
      String personalFileName = personalImage.path.split('/').last;
      String idFileName = idImage.path.split('/').last;

      // تجميع كل البيانات في FormData
      FormData formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'date_of_birth': dateOfBirth,
        // يتم إرسال الملفات باستخدام MultipartFile
        'personal_image': await MultipartFile.fromFile(
          personalImage.path,
          filename: personalFileName,
        ),
        'id_image': await MultipartFile.fromFile(
          idImage.path,
          filename: idFileName,
        ),
      });

      // إرسال الطلب POST
      Response response = await _dio.post(
        'register', // end point
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response; // إذا نجح التسجيل (عادة 200 أو 201)
      }
      return null;
    } on DioException catch (e) {
      print("Dio Error during registration: ${e.message}");
      // إذا كان الخطأ هو خطأ من السيرفر (مثل رقم الهاتف موجود بالفعل)
      if (e.response != null) {
        print("Server response data: ${e.response!.data}");
        return e.response; // إرجاع الرد لمعالجته في RegisterPage
      }
      return null;
    } catch (e) {
      print("General Error during registration: $e");
      return null;
    }
  }
}
