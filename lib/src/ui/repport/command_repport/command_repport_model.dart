class CommandRepportModel {
  final String actionDescription;
  final DateTime actionDate;
  final String deviceDescription;
  final String phoneDescription;
  final String commande;
  final String userId;

  CommandRepportModel({
    required this.actionDescription,
    required this.actionDate,
    required this.deviceDescription,
    required this.phoneDescription,
    required this.commande,
    required this.userId,
  });
}
