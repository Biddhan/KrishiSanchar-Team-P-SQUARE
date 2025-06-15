import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:p_square/app/features/profile/controller/profile_controller.dart';
import 'package:p_square/app/features/profile/models/order_model.dart';

class MyOrdersView extends GetView<ProfileController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load orders when the view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyOrders();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('मेरो अर्डरहरू'), elevation: 0),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingOrders.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'कुनै अर्डर छैन',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'तपाईंले अहिलेसम्म कुनै अर्डर गर्नुभएको छैन',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/marketplace'),
                    child: const Text('अहिले किनमेल गर्नुहोस्'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.getMyOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.myOrders.length,
              itemBuilder: (context, index) {
                final orderJson = controller.myOrders[index];
                return OrderCard(orderJson: orderJson, controller: controller,);
              },
            ),
          );
        }),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic orderJson;
  final ProfileController controller;

  const OrderCard({super.key, required this.orderJson, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Parse the order from JSON
    final order = Order.fromJson(orderJson);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'अर्डर #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(order.orderStatus.name),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('मिति', _formatDate(order.createdDate)),
            _buildInfoRow('समय', order.createdTime.substring(0, 8)),
            _buildInfoRow('ठेगाना', order.buyer.address),
            _buildInfoRow(
              'कुल रकम',
              'रू ${order.totalGrossAmount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Show order details
                      _showOrderDetails(context, order);
                    },
                    child: const Text('विवरण हेर्नुहोस्'),
                  ),
                ),
              ],
            ),
            if (order.orderStatus.name == "Pending")
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    // payment
                    controller.payment(order);
                  },
                  child: const Text('भुक्तानी गर्नुहोस्'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Payed':
        color = Colors.green;
        break;
      case 'Processing':
        color = Colors.blue;
        break;
      case 'Delivered':
        color = Colors.purple;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        _getStatusInNepali(status),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getStatusInNepali(String status) {
    switch (status) {
      case 'Payed':
        return 'भुक्तानी भएको';
      case 'Pending':
        return 'प्रक्रियामा';
      case 'Delivered':
        return 'डेलिभर भएको';
      case 'Cancelled':
        return 'रद्द गरिएको';
      case 'Confirmed':
        return 'पुष्टि गरिएको';
      case 'Shipped':
        return 'ढुवानीमा पठाइयो';
      default:
        return status;
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'अर्डर विवरण #${order.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      _buildStatusChip(order.orderStatus.name),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ग्राहक विवरण',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('नाम', order.buyer.fullName),
                  _buildInfoRow('इमेल', order.buyer.email),
                  _buildInfoRow('फोन', order.buyer.phoneNumber),
                  _buildInfoRow('ठेगाना', order.buyer.address),
                  const SizedBox(height: 20),
                  const Text(
                    'अर्डर विवरण',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('अर्डर मिति', _formatDate(order.createdDate)),
                  _buildInfoRow('अर्डर समय', order.createdTime.substring(0, 8)),
                  _buildInfoRow(
                    'कुल रकम',
                    'रू ${order.totalGrossAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 20),
                  // const Text(
                  //   'अर्डर आइटमहरू',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  // ),
                  // const SizedBox(height: 10),
                  // if (order.orderItems == null ||
                  //     (order.orderItems?.isEmpty ?? true))
                  //   const Text('कुनै आइटम उपलब्ध छैन'),
                  // const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('बन्द गर्नुहोस्'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
