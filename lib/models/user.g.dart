// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUserModelAdapter extends TypeAdapter<HiveUserModel> {
  @override
  final int typeId = 0;

  @override
  HiveUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      imageUrl: fields[4] as String,
      token: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
