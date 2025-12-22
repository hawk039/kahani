// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryMetadataAdapter extends TypeAdapter<StoryMetadata> {
  @override
  final int typeId = 1;

  @override
  StoryMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryMetadata(
      genre: fields[0] as String,
      tone: fields[1] as String,
      language: fields[2] as String,
      filename: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StoryMetadata obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.genre)
      ..writeByte(1)
      ..write(obj.tone)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.filename);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
