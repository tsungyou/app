
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test_empty_1/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});
  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}


const List<String> _productIds = <String>[
  "strategy_1_month_1",
];
class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  List<ProductDetails> _products = [];

  @override
  void initState(){
    super.initState();
    initStoreInfo();
  }
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if(!_isAvailable) {
      _notice = "There are no upgrades at this time";
      return;
    }

    setState(() {
      _notice = "There is a connection to the store";
    });
    // Get IAP
    ProductDetailsResponse productDetailsResponse = await _inAppPurchase.queryProductDetails(_productIds.toSet());
  
    setState(() {
      _products = productDetailsResponse.productDetails;
      print(_products);
      print("not found products: ${productDetailsResponse.notFoundIDs}");
    });

    if(productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There no IAP product to be shown";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂閱策略'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if(_notice != null) 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_notice!),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (BuildContext context, int index) {
                  final ProductDetails productDetails = _products[index];
                  final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
                  return Card(  
                    
                    child: Row( 
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(productDetails.title, style: const TextStyle(fontSize: 20),),
                            Text(productDetails.description),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                          }, 
                          child: Text("${productDetails.price}/月")),
                      ],
                    ),
                  );
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}
