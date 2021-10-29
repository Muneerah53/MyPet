class AppointmentModel {
  String appointmentUID;
  String pet; //"petID" => collection "pets" field "name"
  String species;
  String service;
  String workshiftID;
  String type;
  dynamic time; // "workshiftID" => collection "Work Shift"
  dynamic date; // "workshiftID" => collection "Work Shift"

  AppointmentModel(
      {required this.appointmentUID,
      required this.pet,
      required this.service,
      required this.species,
      required this.workshiftID,
      required this.type,
      this.time,
      this.date});
}
