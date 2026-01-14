import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStrings {
  final bool isAr;
  AppStrings(this.isAr);

  // --- نصوصك القديمة كما هي ---
  String get fieldRequired => isAr ? "هذا الحقل مطلوب" : "Required";
  String get next => isAr ? "التالي" : "NEXT";
  String get cancel => isAr ? "إلغاء" : "Cancel";
  String get myApartments => isAr ? "عقاراتي" : "My Apartments";
  String get addApartment => isAr ? "إضافة شقة جديدة" : "Add New Apartment";
  String get deleteConfirm => isAr
      ? "هل أنت متأكد من حذف هذه الشقة؟"
      : "Are you sure you want to delete this apartment?";
  String get delete => isAr ? "حذف" : "Delete";
  String get startDescription =>
      isAr ? "جد منزلك المثالي بسهولة" : "Find your perfect home easily";
  String get getStarted => isAr ? "ابدأ الآن" : "Get Started";
  String get createAccount => isAr ? "إنشاء حساب" : "Create Account";
  String get firstName => isAr ? "الاسم الأول" : "First Name";
  String get lastName => isAr ? "الاسم الأخير" : "Last Name";
  String get emailAddress => isAr ? "البريد الإلكتروني" : "Email Address";
  String get phoneNumber => isAr ? "رقم الهاتف" : "Phone Number";
  String get birthDate => isAr ? "تاريخ الميلاد" : "Date of Birth";
  String get firstNameHint => isAr ? "أدخل الاسم الأول" : "Enter First Name";
  String get lastNameHint => isAr ? "أدخل الكنية" : "Enter Last Name";
  String get birthDateHint => isAr ? "اختر تاريخ ميلادك" : "Select Birth Date";
  String get requiredField => isAr ? "هذا الحقل مطلوب" : "Required";
  String get emailRequired =>
      isAr ? "البريد الإلكتروني مطلوب" : "Email required";
  String get invalidEmail =>
      isAr ? "يرجى إدخال بريد إلكتروني صحيح" : "Invalid email";
  String get phoneRequired => isAr ? "رقم الهاتف مطلوب" : "Phone required";
  String get phoneInvalid => isAr
      ? "رقم الهاتف يجب أن يكون 10 أرقام على الأقل"
      : "Invalid phone number";
  String get createPassword => isAr ? "إنشاء كلمة مرور" : "Create Password";
  String get passwordInstruction =>
      isAr ? "اختر كلمة مرور قوية لحماية حسابك." : "Choose a strong password.";
  String get password => isAr ? "كلمة المرور" : "Password";
  String get confirmPassword => isAr ? "تأكيد كلمة المرور" : "Confirm Password";
  String get passTooShort => isAr ? "على الأقل 8 أحرف" : "Min 8 characters";
  String get passNotMatch =>
      isAr ? "كلمات المرور غير متطابقة" : "Passwords do not match";
  String get uploadDocuments => isAr ? "رفع المستندات" : "Upload Documents";
  String get uploadInstruction => isAr
      ? "يرجى رفع صورك للتحقق من الحساب."
      : "Upload photos for verification.";
  String get personalPhoto => isAr ? "الصورة الشخصية" : "Personal Photo";
  String get idPhoto => isAr ? "صورة الهوية" : "ID Photo";
  String get finishRegistration =>
      isAr ? "إنهاء التسجيل" : "Finish Registration";
  String get errorUploadBoth =>
      isAr ? "يرجى رفع كلتا الصورتين!" : "Upload both images!";
  String get gallery => isAr ? "المعرض" : "Gallery";
  String get camera => isAr ? "الكاميرا" : "Camera";
  String get recommendation => isAr ? "مقترحاتنا لك" : "Our Recommendation";
  String get search => isAr ? "بحث..." : "Search...";
  String get welcomeBack => isAr ? "مرحباً بعودتك" : "Welcome Back";
  String get phoneLabel => isAr ? "رقم الهاتف" : "Phone Number";
  String get passwordLabel => isAr ? "كلمة المرور" : "Password";
  String get loginButton => isAr ? "تسجيل الدخول" : "LOGIN";
  String get noAccount => isAr ? "ليس لديك حساب؟ " : "Don't Have An Account? ";
  String get registerNow => isAr ? "سجل الآن" : "Register";
  String get noApartments =>
      isAr ? "لا يوجد شقق حالياً." : "No apartments found.";

  // --- نصوص إضافة الشقة ---
  String get apartmentDetails => isAr ? "تفاصيل الشقة" : "Apartment Details";
  String get apartmentPhotos => isAr ? "صور الشقة" : "Apartment Photos";
  String get priceLabel => isAr ? "السعر (\$)" : "Price (\$)";
  String get rooms => isAr ? "الغرف" : "Rooms";
  String get bathrooms => isAr ? "الحمامات" : "Bathrooms";
  String get spaceLabel => isAr ? "المساحة (م²)" : "Space (m²)";
  String get floor => isAr ? "الطابق" : "Floor";
  String get governorate => isAr ? "المحافظة" : "Governorate";
  String get city => isAr ? "المدينة" : "City";
  String get selectGovernorate => isAr ? "اختر المحافظة" : "Select Governorate";
  String get selectCity => isAr ? "اختر المدينة" : "Select City";
  String get selectGovFirst =>
      isAr ? "اختر المحافظة أولاً" : "Select Governorate First";
  String get builtYear => isAr ? "سنة البناء" : "Built Year";
  String get titleDeedType => isAr ? "نوع الطابو" : "Title Deed Type";
  String get greenTabo => isAr ? "طابو أخضر" : "Green Tabo";
  String get courtDecision => isAr ? "قرار محكمة" : "Court Decision";
  String get powerOfAttorney => isAr ? "وكالة" : "Power of Attorney";
  String get description => isAr ? "الوصف" : "Description";
  String get descriptionHint =>
      isAr ? "صف شقتك هنا..." : "Describe your apartment...";
  String get addApartmentButton => isAr ? "إضافة الشقة" : "Add Apartment";
  String get imagesSelected => isAr ? "صور مختارة" : "Images Selected";
  String get uploadPhotos =>
      isAr ? "ارفع صور الشقة" : "Upload apartment photos";
  String get requests => isAr ? "الطلبات" : "requests";

  // --- خرائط الترجمة (للبيانات القادمة من السيرفر) ---

  // 1. خريطة المحافظات والمدن (للعرض في القوائم المنسدلة)
  Map<String, List<String>> get citiesByGovernorate => isAr
      ? {
          'دمشق': ['الميدان', 'المزة', 'عفيف'],
          'حلب': ['السفيرة', 'الباب', 'منبج'],
          'حمص': ['تلكلخ', 'القصير', 'الرستن'],
          'حماة': ['سلمية', 'مصياف', 'الحمراء'],
          'درعا': ['بصرى', 'الحراك', 'نوى'],
          'اللاذقية': ['كسب', 'جبلة', 'مشقيتا'],
          'طرطوس': ['بانياس', 'أرواد', 'صافيتا'],
          'السويداء': ['شهبا', 'صلخد', 'شقيا'],
          'دير الزور': ['الميادين', 'أبو كمال', 'العشارة'],
          'إدلب': ['أريحا', 'جسر الشغور', 'معرة النعمان'],
          'الرقة': ['الثورة', 'الكرامة', 'المنصورة'],
        }
      : {
          'Damascus': ['Midan', 'Mazzeh', 'Afif'],
          'Aleppo': ['As-Safira', 'Al-bab', 'Manbij'],
          'Homs': ['Talkalakh', 'Al-Qusayr', 'Al-Rastan'],
          'Hama': ['Salamiyah', 'Masyaf', 'Al-Hamraa'],
          'Daraa': ['Bosra', 'Al-Hirak', 'Nawa'],
          'Latakia': ['Kessab', 'Jableh', 'Mashqita'],
          'Tartous': ['Baniyas', 'Arwad', 'Safita'],
          'Suwayda': ['Shahba', 'Salkhad', 'Shaqqa'],
          'Deir ez-Zor': ['Mayadin', 'Abu Kamal', 'Al-Asharah'],
          'Idlib': ['Ariha', 'Jisr ash-Shughur', 'Maarat al-Numan'],
          'Raqqa': ['Al-Thawrah', 'Al-Karamah', 'Al-Mansoura'],
        };

  Map<String, String> get dbToAr => {
        // المحافظات
        'Damascus': 'دمشق',
        'Aleppo': 'حلب',
        'Homs': 'حمص',
        'Hama': 'حماة',
        'Daraa': 'درعا', // تأكدي من سبينغ السيرفر (Daraa أو Draa)
        'Draa': 'درعا', // للاحتياط حسب كود الفلتر السابق
        'Latakia': 'اللاذقية',
        'Tartous': 'طرطوس',
        'Suwayda': 'السويداء',
        'Deir ez-Zor': 'دير الزور',
        'Idlib': 'إدلب',
        'Raqqa': 'الرقة',

        // المناطق (التي لم تكن موجودة في القائمة السابقة)
        'Midan': 'الميدان',
        'Mazzeh': 'المزة',
        'Afif': 'عفيف',
        'As-Safira': 'السفيرة',
        'Al-Bab': 'الباب',
        'Manbij': 'منبج',
        'Talkalakh': 'تلكلخ',
        'Al-Qusayr': 'القصير',
        'Al-Rastan': 'الرستن',
        'Salamiyah': 'سلمية',
        'Masyaf': 'مصياف',
        'Al-Hamraa': 'الحمراء',
        'Bosra': 'بصرى',
        'Al-Hirak': 'الحراك',
        'Nawa': 'نوى',
        'Kessab': 'كسب',
        'Jableh': 'جبلة',
        'Mashqita': 'مشقيتا',
        'Baniyas': 'بانياس',
        'Arwad': 'أرواد',
        'Safita': 'صافيتا',
        'Shahba': 'شهبا',
        'Salkhad': 'صلخد',
        'Shaqqa': 'شقيا',
        'Mayadin': 'الميادين',
        'Abu Kamal': 'أبو كمال',
        'Al-Asharah': 'العشارة',
        'Ariha': 'أريحا',
        'Jisr ash-Shughur': 'جسر الشغور',
        'Maarat al-Numan': 'معرة النعمان',
        'Al-Thawrah': 'الثورة',
        'Al-Karamah': 'الكرامة',
        'Al-Mansoura': 'المنصورة',

        // أنواع الطابو
        'green': 'طابو أخضر',
        'Court Decision': 'قرار محكمة',
        'Power of Attorney': 'وكالة',
      };

  // --- نصوص شاشة الملف الشخصي (Profile) ---
  String get accountSettings => isAr ? "إعدادات الحساب" : "Account Settings";
  String get language => isAr ? "اللغة" : "Language";
  String get darkMode => isAr ? "الوضع الليلي" : "Dark Mode";
  String get lightMode => isAr ? "الوضع النهاري" : "Light Mode";
  String get areYouSureLogout => isAr
      ? "هل أنت متأكد من تسجيل الخروج؟"
      : "Are you sure you want to logout?";
  String get yes => isAr ? "نعم" : "Yes";
  String get no => isAr ? "لا" : "No";
  String get noData => isAr ? "لا يوجد بيانات" : "No Data Available";
  String get profile => isAr ? "الملف الشخصي" : "Profile";

  String get myBookings => isAr ? "حجوزاتي" : "My Bookings";

  String get logout => isAr ? "تسجيل الخروج" : "Logout";

String get userIdLabel => isAr ? "رقم المستخدم" : "User ID";
  String get accept => isAr ? "قبول" : "Accept"; // أضيفي هذا السطر
  String get viewDetailsMsg => isAr
      ? "اضغط لعرض تفاصيل الشقة"
      : "Click to view apartment details"; // أضيفي هذا السطر
  // 3. دالة سحرية تستخدمها في أي مكان لعرض النص مترجم
  String translate(String? value) {
    if (value == null) return '';
    if (!isAr) return value;
    return dbToAr[value] ?? value;
  }

  // رسائل التنبيه والخطأ (كما هي)
  String get priceRequired => isAr ? "السعر مطلوب" : "Price is required";
  String get invalidNumber => isAr ? "رقم غير صالح" : "Invalid number";
  String get imageError => isAr
      ? "يرجى رفع صورة واحدة على الأقل"
      : "Please upload at least one image";
  String get locationError =>
      isAr ? "يرجى اختيار المحافظة والمدينة" : "Please select location";
  String get addSuccess =>
      isAr ? "تم إضافة الشقة بنجاح!" : "Apartment Added Successfully!";
  String get addError =>
      isAr ? "فشل في الإضافة، حاول مجدداً" : "Failed to add apartment";
  String get descriptionRequired =>
      isAr ? "الوصف مطلوب" : "Description is required";
  String get descriptionTooShort =>
      isAr ? "الوصف قصير جداً" : "Description too short";
  String get selectTitleDeed => isAr ? "اختر نوع الملكية" : "Select Title Deed";

  String get noActiveBookings =>
      isAr ? "لا توجد حجوزات نشطة" : "No active bookings";
  String get noPastBookings =>
      isAr ? "لا توجد حجوزات سابقة" : "No past bookings";
  String get noCancelledBookings =>
      isAr ? "لا توجد حجوزات ملغاة" : "No cancelled bookings";
  String get activeBookings => isAr ? "نشطة" : "Active";
  String get history => isAr ? "السجل" : "History";
  String get archived => isAr ? "المؤرشفة" : "Archived";

  String get rejected => isAr ? "مرفوضة" : "Rejected";
  String get rateNow => isAr ? "قيم الآن" : "Rate Now";
  String get edit => isAr ? "تعديل" : "Edit";
  String get rated => isAr ? "تم التقييم" : "Rated";
  String get cancelBooking => isAr ? "إلغاء الحجز" : "Cancel Booking";
  String get areYouSureCancel => isAr
      ? "هل أنت متأكد من إلغاء هذا الحجز؟"
      : "Are you sure you want to cancel this booking?";
// --- نصوص صفحة الحجز (Booking Page) ---
  String get selectStayPeriod =>
      isAr ? "تحديد فترة الإقامة" : "Select Stay Period";
  String get editStayPeriod => isAr ? "تعديل فترة الإقامة" : "Edit Stay Period";
  String get checkInDate => isAr ? "تاريخ الدخول" : "Check-in Date";
  String get checkOutDate => isAr ? "تاريخ الخروج" : "Check-out Date";
  String get confirmBooking => isAr ? "تأكيد الحجز" : "Confirm Booking";
  String get updateBooking => isAr ? "تحديث الحجز" : "Update Booking";

  // --- نصوص نافذة التأكيد (Confirmation Dialog) ---
  String get bookingPeriod => isAr ? "فترة الحجز" : "Booking Period";
  String get totalAmount => isAr ? "المبلغ الإجمالي" : "Total Amount";
  String get confirm => isAr ? "تأكيد" : "Confirm";
  // ملاحظة: "cancel" موجودة مسبقاً في كودك فلا داعي لتكرارها

  // --- رسائل التنبيه والخطأ للحجز (SnackBars) ---
  String get selectStartFirstError =>
      isAr ? "يرجى اختيار تاريخ البدء أولاً" : "Please select start date first";
  String get datesRequiredError =>
      isAr ? "يرجى تحديد التاريخين" : "Please select both dates";
  String get loginRequiredError =>
      isAr ? "يرجى تسجيل الدخول أولاً" : "Please login first";
  String get serverError => isAr
      ? "خطأ في الاتصال، يرجى المحاولة لاحقاً"
      : "Server error, please try again later";
  String get bookingSuccess =>
      isAr ? "تم الحجز بنجاح!" : "Reservation Successful!";
  String get updateSuccess =>
      isAr ? "تم تحديث الموعد بنجاح!" : "Update Successful!";

// --- نصوص صفحة الإشعارات (Notification Screen) ---
  String get notifications => isAr ? "الإشعارات" : "Notifications";
  String get noNotifications =>
      isAr ? "لا يوجد إشعارات حالياً" : "No notifications yet";
  String get error => isAr ? "خطأ" : "Error";
  String get markAsRead => isAr ? "تحديد كمقروء" : "Mark as read";

// --- نصوص شاشة انتظار التفعيل (Account Pending) ---
  String get accountUnderReview =>
      isAr ? "الحساب قيد المراجعة" : "The account is under review.";
  String get pendingDescription => isAr
      ? "شكراً لتسجيلك في تطبيق سكني.\n يتم حالياً مراجعة معلوماتك من قبل المسؤول. ستتمكن من تسجيل الدخول فور تلقيك إشعار التفعيل."
      : "Thank you for registering with the Sakani application.\n Your information is currently being reviewed by the administrator. You will be able to log in as soon as you receive the activation notification.";
  String get returnToLogin => isAr ? "العودة لتسجيل الدخول" : "Return to login";
  String get accountActivatedMsg => isAr
      ? "تم تفعيل حسابك بنجاح! أهلاً بك."
      : "Your account has been successfully activated! Welcome.";

  // 1. إضافة نص "الكل" ليستخدم في الفلتر
  String get all => isAr ? "الكل" : "All";

  // 2. إضافة عناوين الفلتر ليكون الشغل راكز
  String get filterTitle => isAr ? "فلترة" : "Filter";
  String get reset => isAr ? "إعادة تعيين" : "Reset";
  String get apply => isAr ? "تطبيق" : "Apply";
  String get priceRange => isAr ? "نطاق السعر" : "Price Range";
  String get spaceRange => isAr ? "نطاق المساحة" : "Space Range";

  // 3. الدالة السحرية للتحويل العكسي (من العربي للانكليزي قبل الإرسال للسيرفر)
  String getEnglishValue(String localValue) {
    if (!isAr) return localValue; // إذا التطبيق إنكليزي، القيمة أصلاً إنكليزي
    if (localValue == "الكل") return "All";

    // البحث في القاموس عن المفتاح (Key) الذي يقابل هذه القيمة العربية
    try {
      return dbToAr.entries
          .firstWhere((entry) => entry.value == localValue)
          .key;
    } catch (e) {
      return localValue; // إذا لم يجدها، يرسلها كما هي
    }
  }
}

// الـ Providers
final isArabicProvider = StateProvider<bool>((ref) => false);

final stringsProvider = Provider<AppStrings>((ref) {
  final isAr = ref.watch(isArabicProvider);
  return AppStrings(isAr);
});
