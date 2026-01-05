// class MyApartmentsScreen extends ConsumerWidget {
//   const MyApartmentsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final myApartmentsAsyncValue = ref.watch(myApartmentsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Apartments', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: isDark ? Colors.white : Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: myApartmentsAsyncValue.when(
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
//                     // الانتقال لتفاصيل شقتي (ربما مع خيار الحذف أو التعديل)
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ApartmentDetailsScreen(apartmentId: apartment.id),
//                       ),
//                     );
//                   },
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
//       // زر إضافة شقة جديدة (كما في كودك)
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppConstants.primaryColor,
//         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddApartmentPage())),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }