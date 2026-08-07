class VisitorModel {
  final String visitorId;
  final String name;
  final String mobile;
  final String email;
  final String company;
  final String? photoUrl;
  final String? idProofUrl;
  final String idVerificationStatus;

  VisitorModel({
    required this.visitorId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.company,
    this.photoUrl,
    this.idProofUrl,
    this.idVerificationStatus = 'Verified',
  });
}
