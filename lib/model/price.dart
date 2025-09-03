class Price {
  Price({this.id, this.des,this.price,this.type});

  final String? id;
  final String? des;
  final String? type;
  final double? price;

  static Price? fromMap(Map<String, dynamic>? data, id) {
    if (data == null) {
      return null;
    }
    // final String id = data['id'];
    final String? des = data['des'];
    final double? price = data['price'];
    final String? type = data['type'];

    return Price(
      id: id,
      des: des,
      price: price,
      type: type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'des': des,
      'type': type,
      'price':price,
    };
  }
}

