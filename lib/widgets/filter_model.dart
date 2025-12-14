// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// class FilterModel extends StatefulWidget{
//   const FilterModel({super.key});

//   @override
//   State<FilterModel> createState() => _FilterModelState(); 
    
//   }
//   class _FilterModelState extends State<FilterModel>{
//     String _selectedGovernorate='Damascus';
//     String _selectedCity='Mazzeh';
//     RangeValues _priceRange= const RangeValues(25000, 500000);
//     RangeValues _areaRange= const RangeValues(50, 500);

//     final List<String> _governorates = ['Damascus', 'Aleppo', 'Homs', 'Hama', 'Draa', 'Latakia','Tartous','Suwayda','Deir ez-Zor' ,'Idlib','Raqqa'];
//     final Map<String, List<String>> _citiesByGovernorate={
//       'Damascus': ['Midan', 'Mazzeh', 'Afif'],
//       'Homs': ['Talkalakh', 'Al-Qusayr','Al-Rastan'],
//       'Hama':['Salamiyah','Masyaf','Al-Hamraa'],
//     };
//     @override
//     Widget build(BuildContext context){
//       return Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top:Radius.circular(25.0))
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0)),
//           child: Column(
//             mainAxisSize:MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Filter',
//                 style: GoogleFonts.lato(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               _buildSectionTitle('Governorate'),
//               const SizedBox(height: 10),
//               _buildGovernorateDropdown(),
//               const SizedBox(height:20),

//                _buildSectionTitle('City'),
//               const SizedBox(height: 10),
//               _buildCityDropdown(),
//               const SizedBox(height:20),

//                _buildSectionTitle('Price Range'),
//               const SizedBox(height: 10),
//               _buildPriceRangeslider(),
//               const SizedBox(height:20),

//                _buildSectionTitle('Area (sqm)'),
//               const SizedBox(height: 10),
//               _buildAreaRangeSlider(),
//               const SizedBox(height:30),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         side: BorderSide(color: Colors.blue[800]!),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: Text(
//                         'Reset',
//                         style: GoogleFonts.lato(
//                           color: Colors.blue[800],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: (){
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[800],
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                            child: Text(
//                             'Apply',
//                             style: GoogleFonts.lato(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildSectionTitle(String title){
//     return Text(
//       title,
//       style: GoogleFonts.lato(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
//   Widget _build
//   }
