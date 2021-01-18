class Card {
  String number;
  String cvv;
  int mm;
  int yy;
  String cardName;

  Card({this.number, this.cvv, this.mm, this.yy, this.cardName});

  @override
  String toString() {
    return this.number;
  }
}
