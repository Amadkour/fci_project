// import 'package:get/get.dart';
//
// import '../model1_model.dart';
//
// class Model1Provider extends GetConnect {
//   @override
//   void onInit() {
//     httpClient.defaultDecoder = (map) => Model1.fromJson(map);
//     httpClient.baseUrl = 'YOUR-API-URL';
//   }
//
//   Future<Response<Model1>> getModel1(int id) async => await get('model1/$id');
//   Future<Response<Model1>> postModel1(Model1 model1) async =>
//       await post('model1', model1);
//   Future<Response> deleteModel1(int id) async => await delete('model1/$id');
// }
