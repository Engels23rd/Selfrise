

class cardsdata {
  final int id;
  final String categoria;
  final String autor;
  final String name;
  final String image;
  final String link;
  final String description;

  const cardsdata({
    required this.id,
    required this.categoria,
    required this.autor,
    required this.name,
    required this.image,
    required this.link,
    required this.description,
  });

  factory cardsdata.fromJson(Map<String, dynamic> json) => cardsdata(
      id: json["id"],
      categoria: json["categoria"],
      autor: json["autor"],
      name: json["name"],
      image: json["image"],
      link: json["link"],
      description: json["description"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoria": categoria,
        "autor": autor,
        "name": name,
        "image": image,
        "link": link,
        "description": description,
      };

  cardsdata copy() => cardsdata(
      id: id,
      categoria: categoria,
      autor: autor,
      name: name,
      image: image,
      link: link,
      description: description);
}
