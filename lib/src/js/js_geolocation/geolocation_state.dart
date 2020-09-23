part of 'geolocation_cubit.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();
}

class GeolocationInitial extends GeolocationState {
  @override
  List<Object> get props => [];
}

class GeolocationLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  GeolocationLoaded(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is GeolocationLoaded &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => super.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
