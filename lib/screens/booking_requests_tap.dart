import 'dart:ui';

import 'package:apartment_rental_app/controller/booking_controller.dart';
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
            const Text('No pending requests found',style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.pendingRequests.length,
      itemBuilder: (context, index){
        final request =state.pendingRequests[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
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
                    Text("Apartment ID: ${request.apartmentId}", 
                      style: TextStyle(color: Colors.grey[600])),

                        ],
                      ),
                    ),
                    Text(
                      "${request.totalPrice} \$",
                      style: TextStyle(color:theme.primaryColor, fontWeight: FontWeight.bold ),
                    )
                  ],
                  ),
                  const Divider(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoColumn("Start Date", request.startDate),
                     _infoColumn("End Date", request.endDate),
                     ],
                  ),
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
                         child: const Text('Acccept', style: TextStyle(color: Colors.white),)
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

              ],
            ),
            ),

        );
      }
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
