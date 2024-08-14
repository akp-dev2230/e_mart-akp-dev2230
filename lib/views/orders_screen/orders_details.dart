import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/views/orders_screen/components/order_place_details.dart';
import 'package:e_mart/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              orderStatus(icon: Icons.done,color: redColor,title: "Placed", showDone: data['order_placed']),
              orderStatus(icon: Icons.thumb_up,color: Colors.blue,title: "Confirmed", showDone: data['order_confirmed']),
              orderStatus(icon: Icons.delivery_dining,color: Colors.yellow,title: "On Delivery", showDone: data['order_on_delivery']),
              orderStatus(icon: Icons.done_all,color: Colors.purple,title: "Delivered", showDone: data['order_delivered']),

              const Divider(),
              10.heightBox,

              Column(
                children: [
                  orderPlaceDetails(
                      title1: "Order Code",
                      d1: data['order_code'],
                      title2: "Shipping Method",
                      d2: data['shipping_method']
                  ),
                  orderPlaceDetails(
                      title1: "Order Date",
                      d1: intl.DateFormat().add_yMd().format((data['order_date'].toDate())),
                      title2: "Payment Method",
                      d2: data['payment_method']
                  ),
                  orderPlaceDetails(
                      title1: "Payment Status",
                      d1: "Unpaid",
                      title2: "Delivery Status",
                      d2: "Order placed"
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalCode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}".numCurrency.text.fontFamily(bold).color(redColor).make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.shadowSm.white.roundedSM.make(),

              10.heightBox,

              "Ordered Product".text.size(16.0).color(darkFontGrey).fontFamily(semibold).makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['total_amount'],
                        d1: "${data['orders'][index]['qty']}x",
                        d2: "Refundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ).box.shadowSm.white.margin(const EdgeInsets.only(bottom: 4.0)).make(),
              20.heightBox,




            ],
          ),
        ),
      ),
    );
  }
}
