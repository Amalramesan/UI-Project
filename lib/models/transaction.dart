class Transactions {
  final int? id;
  final String type;
  final String money;
  final String remark;
  Transactions({
    this.id,
    required this.money,
    required this.remark,
    required this.type,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'money': money, 'remark': remark, 'type': type};
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'],
      money: map['money'],
      remark: map['remark'],
      type: map['type'],
    );
  }
}
