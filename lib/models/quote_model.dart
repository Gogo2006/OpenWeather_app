class Quote {
  final String quoteContent;
  //final String authorName;

  Quote({
    required this.quoteContent,
    //required this.authorName,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteContent: json['slip']['advice'],
      //authorName: json[0]['author']
      );
  }
}