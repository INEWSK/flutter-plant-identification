// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreeDataAdapter extends TypeAdapter<TreeData> {
  @override
  final int typeId = 0;

  @override
  TreeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeData(
      count: fields[0] as int,
      next: fields[1] as dynamic,
      previous: fields[2] as dynamic,
      results: (fields[3] as List)?.cast<Result>(),
    );
  }

  @override
  void write(BinaryWriter writer, TreeData obj) {
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
      other is TreeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final int typeId = 1;

  @override
  Result read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Result(
      id: fields[0] as int,
      folderName: fields[1] as String,
      scientificName: fields[2] as String,
      commonName: fields[3] as String,
      introduction: fields[4] as String,
      specialFeatures: fields[5] as String,
      toLearnMore: fields[6] as String,
      family: fields[7] as String,
      height: fields[8] as String,
      natureOfLeaf: fields[9] as String,
      branch: fields[10] as String,
      bark: fields[11] as String,
      leaf: fields[12] as String,
      flower: fields[13] as String,
      fruit: fields[14] as String,
      dateCreated: fields[15] as DateTime,
      treeImages: (fields[16] as List)?.cast<TreeImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, Result obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.folderName)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.commonName)
      ..writeByte(4)
      ..write(obj.introduction)
      ..writeByte(5)
      ..write(obj.specialFeatures)
      ..writeByte(6)
      ..write(obj.toLearnMore)
      ..writeByte(7)
      ..write(obj.family)
      ..writeByte(8)
      ..write(obj.height)
      ..writeByte(9)
      ..write(obj.natureOfLeaf)
      ..writeByte(10)
      ..write(obj.branch)
      ..writeByte(11)
      ..write(obj.bark)
      ..writeByte(12)
      ..write(obj.leaf)
      ..writeByte(13)
      ..write(obj.flower)
      ..writeByte(14)
      ..write(obj.fruit)
      ..writeByte(15)
      ..write(obj.dateCreated)
      ..writeByte(16)
      ..write(obj.treeImages);
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

class TreeImageAdapter extends TypeAdapter<TreeImage> {
  @override
  final int typeId = 2;

  @override
  TreeImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeImage(
      id: fields[0] as int,
      treeImage: fields[1] as String,
      dateCreated: fields[2] as DateTime,
      tree: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TreeImage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.treeImage)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.tree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
