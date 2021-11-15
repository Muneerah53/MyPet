class ServiceModel{
  String serviceID;
  String serviceName; //"petID" => collection "pets" field "name"
  String servicePrice;

  ServiceModel(
      {required this.serviceID,
        required this.serviceName,
        required this.servicePrice,});
}
