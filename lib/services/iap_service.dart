import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  Future<void> listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      print('Purchase status: ${purchaseDetails.status}');
      print('Purchase productID: ${purchaseDetails.productID}');
      print('Purchase pendingCompletePurchase: ${purchaseDetails.pendingCompletePurchase}');

      if(purchaseDetails.pendingCompletePurchase){
        print('Completing purchase for ${purchaseDetails.productID}');
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }
}