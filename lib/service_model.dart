class serviceModel{
  String serviceID;
  String serviceName; //"petID" => collection "pets" field "name"
  String servicePrice;

  serviceModel(
      {required this.serviceID,
        required this.serviceName,
        required this.servicePrice,});
}
