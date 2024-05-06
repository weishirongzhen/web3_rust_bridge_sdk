class AleoDelegateTransferData {
  final String authorization;
  final String feeAuthorization;
  final String program;

  AleoDelegateTransferData.public({
    required this.authorization,
    required this.feeAuthorization,
    required this.program,
  });

  @override
  String toString() {

    return authorization + feeAuthorization + program;
  }
}
