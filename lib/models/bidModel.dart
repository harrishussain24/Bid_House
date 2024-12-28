// ignore_for_file: file_names

class BidsModel {
  String? bidId;
  String? bidderName;
  String? bidderEmail;
  num? bid;
  DateTime? createdOn;

  BidsModel(
      {this.bidId,
      this.bidderName,
      this.bidderEmail,
      this.bid,
      this.createdOn});

  BidsModel.fromMap(Map<String, dynamic> map) {
    bidId = map['bidId'];
    bidderName = map['bidderName'];
    bidderEmail = map['bidderEmail'];
    bid = map['bid'];
    createdOn = map['createdOn'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'bidId': bidId,
      'bidderName': bidderName,
      'bidderEmail': bidderEmail,
      'bid': bid,
      'createdOn': createdOn
    };
  }
}
