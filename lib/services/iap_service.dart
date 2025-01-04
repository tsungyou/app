import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:test_empty_1/services/auth_service.dart';
import 'package:test_empty_1/services/firebase_service.dart';

class IapService {
  String uid;
  IapService(this.uid);
  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if(purchaseDetails.status ==  PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored){
        _handleSuccessfulPurchase(purchaseDetails);
      }
      if(purchaseDetails.pendingCompletePurchase){
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    if(purchaseDetails.productID == "strategy_1_month_1") {
      FirebaseService().updateStrategyExpirationDate(1, uid, 31);
    }
  }
}