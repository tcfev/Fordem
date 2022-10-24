class LocationData {
  const LocationData({
    this.longitude,
    this.latitude,
    this.url,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      LocationData(url: json['url'], latitude: json['lan'], longitude: json['long']);

  final String url;
  final String longitude;
  final String latitude;

  Map<String, dynamic> toJson() => {
        'url': url,
        'lat': latitude,
        'long': longitude,
      };
}
