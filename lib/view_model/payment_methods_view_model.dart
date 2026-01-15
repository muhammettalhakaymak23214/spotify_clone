import 'package:mobx/mobx.dart';

class PaymentMethodsViewModel { 

  PaymentMethodsViewModel() {
    _selectedMethod = Observable(PaymentMethod.spotify);
  }

 
  late final Observable<PaymentMethod> _selectedMethod;

  
  PaymentMethod get selectedMethod => _selectedMethod.value;

  
  void changeMethod(PaymentMethod method) {
    runInAction(() {
      _selectedMethod.value = method;
    });
  }

}

enum PaymentMethod {
  spotify,
  googlePlay,
}
