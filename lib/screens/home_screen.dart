import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Our Recommendation',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child:GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.68,
                ),
                itemCount:8 ,
                itemBuilder: (context,index){
                  final properties=[
                    {
                    'imagePath' : 'assets/images/door1.jpg', 
                    'price' : '400.000', 
                    'governorate' : 'Damascus',
                    'city':'Mazzeh',
                    'area': '250',
                    },
                    {
                      'imagePath': 'assets/images/door2.jpg', 
                    'price': '500.000', 
                    'governorate': 'Damascus',
                    'city' :'Midan',
                    'area':'100',
                    },
                    {
                      'imagePath': 'assets/images/door3.jpg', 
                    'price': '600.000', 
                    'governorate': 'Damascus',
                    'city':'BabToma',
                    'area': '200',
                    },
                    {
                      'imagePath': 'assets/images/door4.jpg', 
                    'price': '250.000', 
                    'governorate': 'Damascus',
                    'city':'Afif',
                    'area': '150',
                    },
                    {
                    'imagePath' : 'assets/images/door1.jpg', 
                    'price' : '400.000', 
                    'governorate' : 'Damascus',
                    'city':'Mazzeh',
                    'area': '250',
                    },
                    {
                      'imagePath': 'assets/images/door2.jpg', 
                    'price': '500.000', 
                    'governorate': 'Damascus',
                    'city' :'Midan',
                    'area':'100',
                    },
                    {
                      'imagePath': 'assets/images/door3.jpg', 
                    'price': '600.000', 
                    'governorate': 'Damascus',
                    'city':'BabToma',
                    'area': '200',
                    },
                    {
                      'imagePath': 'assets/images/door4.jpg', 
                    'price': '250.000', 
                    'governorate': 'Damascus',
                    'city':'Afif',
                    'area': '150',
                    },
                  ];
                  final property=properties[index];
                  return Apartmentcard(
                    imagePath: property['imagePath']!,
                     price: property['price']!,
                      governorate: property['governorate']!,
                      city: property['city']!,
                      area: property['area']!,
                      );
                },
              
              ), 
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }
  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
        child: Row(
          children: [
             Image(
              image: AssetImage('assets/images/Logo.png'),
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 10),
           Text(
                  'Sakani',
                  style: GoogleFonts.lemon(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Color(0xFF234F68)
                  ),
                ),
            const Spacer(),
         Image(
              image: AssetImage('assets/images/notification.png'),
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildSearchBar(){
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.2),
  //           spreadRadius: 1,
  //           blurRadius: 4,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         prefixIcon: const Icon(Icons.search,color: Colors.grey),
  //         suffixIcon: IconButton(
  //            icon: const Icon(Icons.tune, 
  //            color: Color(0xFF234F68),
  //            ),
  //            onPressed: (){
  //            },
  //            ),
  //            hintText: 'Search',
  //            border: InputBorder.none,
  //            contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildCustomBottomNavBar(){
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFF234F68),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, true),
          _buildNavBarItem(Icons.favorite_border, false),
          _buildNavBarItem(Icons.tune, false),
          _buildNavBarItem(Icons.person, false),
        ],
      ),
    );
  }
  Widget _buildNavBarItem(IconData icon, bool isActive){
    return IconButton(
       icon: Icon(
        icon,
        color: isActive? Colors.white :Colors.white70,
        size: 28,
       ),
       onPressed: (){

       },
       );
  }
}
