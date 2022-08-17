class Images {
  Images({
    this.path,
  });

  String path;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    path: json["location"] != null ?  json["location"] : null,
  );

  Map<String, dynamic> toJson() => {
    "path": path != null ? path : null,
  };
}