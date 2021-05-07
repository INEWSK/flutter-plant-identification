// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreeInfoAdapter extends TypeAdapter<TreeInfo> {
  @override
  final int typeId = 4;

  @override
  TreeInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeInfo(
      count: fields[0] as int,
      next: fields[1] as dynamic,
      previous: fields[2] as dynamic,
      results: (fields[3] as List)?.cast<Result>(),
    );
  }

  @override
  void write(BinaryWriter writer, TreeInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.next)
      ..writeByte(2)
      ..write(obj.previous)
      ..writeByte(3)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final int typeId = 5;

  @override
  Result read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Result(
      infoType: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      dateCreated: fields[3] as DateTime,
      infoImages: (fields[4] as List)?.cast<InfoImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, Result obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.infoType)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.dateCreated)
      ..writeByte(4)
      ..write(obj.infoImages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InfoImageAdapter extends TypeAdapter<InfoImage> {
  @override
  final int typeId = 6;

  @override
  InfoImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoImage(
      id: fields[0] as int,
      infoImage: fields[1] as String,
      dateCreated: fields[2] as DateTime,
      info: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InfoImage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.infoImage)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
