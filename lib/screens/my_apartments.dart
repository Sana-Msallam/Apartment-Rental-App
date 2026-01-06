// import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
// import 'package:apartment_rental_app/main.dart';
// import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
// import 'package:apartment_rental_app/screens/booking_screen.dart';
// import 'package:apartment_rental_app/screens/notification_screen.dart';
// import 'package:apartment_rental_app/services/local_notifications_service.dart';
// import 'package:apartment_rental_app/widgets/filter_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/apartmentCard.dart';
// import '../constants/app_constants.dart';
// import '../screens/favorites_screen.dart';
// import '../screens/profile_screen.dart';
// import '../screens/add_apartment_page.dart';

// class MyApartmentsScreen extends ConsumerWidget {
//   const MyApartmentsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//                   final apartmentsAsyncValue = ref.watch(apartmentProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Apartments', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: isDark ? Colors.white : Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: apartmentsAsyncValue.when(
//           data: (apartments) {
//             if (apartments.isEmpty) {
//               return const Center(child: Text('You haven\'t added any apartments yet.'));
//             }
//             return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 6,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 0.68,
//               ),
//               itemCount: apartments.length,
//               itemBuilder: (context, index) {
//                 final apartment = apartments[index];
//                 return Apartmentcard(
//                   id: apartment.id,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ApartmentDetailsScreen(apartmentId: apartment.id),
//                       ),
//                     );
//                   },
//                   onDelete: () {
//     // هنا تضعين كود الحذف
//     print("Delete apartment with id: ${apartment.id}");
//   },
//                   imagePath: apartment.imagePath,
//                   price: apartment.price,
//                   governorate: apartment.governorate,
//                   city: apartment.city,
//                   space: apartment.space,
//                   average_rating: apartment.averageRating,
//                 );
//               },
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stack) => Center(child: Text('Error: $error')),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppConstants.primaryColor,
//         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddApartmentPage())),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }