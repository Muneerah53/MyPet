class BoardingModel {
  String boardingUID;
  String pet;
  String species;
  String service;
  dynamic startDate;
  dynamic endDate;
  BoardingModel(
      {required this.boardingUID,
        required this.pet,
        required this.service,
        required this.species,
        this.startDate,
        this.endDate,
      });
}