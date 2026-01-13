import 'dart:ui';

import 'package:apartment_rental_app/providers/booking_provider.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingRequestsTap extends ConsumerStatefulWidget {
  const BookingRequestsTap({super.key});

  @override
  ConsumerState<BookingRequestsTap> createState()=> _BookingRequestsTapState();

}

class _BookingRequestsTapState extends ConsumerState<BookingRequestsTap>{
  @override 
  void initState(){
    super.initState();
    Future.microtask(()=> ref.read(bookingProvider.notifier).fetchOwnerRequests());
  }
  @override
  Widget build(BuildContext context){
    final state =ref.watch(bookingProvider);
    final theme =Theme.of(context);

    if(state.isLoading){
      return const Center(child: CircularProgressIndicator());
    }
    if(state.pendingRequests.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80,color: Colors.grey[400]),
            const SizedBox(height: 10),
            const Text('No requests found',style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.pendingRequests.length,
      itemBuilder: (context, index){
        final request =state.pendingRequests[index];
        final status = request.status.toLowerCase().trim();
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child:InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              print("Navigating to apartment: ${request.apartmentId}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApartmentDetailsScreen(apartmentId:  request.apartmentId),
                ),
              );
            },
           child :Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.person, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User ID: ${request.userId}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _buildStatusBadge(request.status),
                  
                        ],
                      ),
                    ),
                    Text(
                      "${request.totalPrice} \$",
                      style: TextStyle(color:theme.primaryColor, fontWeight: FontWeight.bold ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                  ],
                  ),
                   const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoColumn("Start Date", request.startDate),
                     _infoColumn("End Date", request.endDate),
                     ],
                  ),
                  if (status == 'pending') ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => ref.read(bookingProvider.notifier).acceptRequest(request.id),
                         style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                         child: const Text('Accept', style: TextStyle(color: Colors.white),)
                         ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ref.read(bookingProvider.notifier).rejectRequest(request.id),
                          style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ), 
                          child: const Text('Reject', style: TextStyle(color: Colors.red)),
                          ),
                           ), 
                            ],
                  ),

              ] else ...[
                const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        "Click to view apartment details",
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
            ),
            ),
              ],
              ],


       ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase().trim()) {
      case 'pending': color = Colors.orange; break;
      case 'accepted': color = Colors.green; break;
      case 'rejected': color = Colors.red; break;
      case 'completed': color = Colors.blue; break;
      case 'cancelled': color = Colors.grey; break;
      default: color = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

Widget _infoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
