import 'package:flutter/material.dart';

Image  imgPreCache(String img) {
  return Image.network(
    'https://edutalk-cdn.sgp1.cdn.digitaloceanspaces.com/Game/Background/' + img,
    fit: BoxFit.fill,
  );
}
