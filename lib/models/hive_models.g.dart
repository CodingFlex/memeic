// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMemeModelAdapter extends TypeAdapter<HiveMemeModel> {
  @override
  final int typeId = 0;

  @override
  HiveMemeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMemeModel(
      id: fields[0] as String,
      imageUrl: fields[1] as String,
      title: fields[2] as String?,
      tags: (fields[3] as List?)?.cast<String>(),
      showPreview: fields[4] as bool,
      savedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMemeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.showPreview)
      ..writeByte(5)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMemeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveSearchHistoryAdapter extends TypeAdapter<HiveSearchHistory> {
  @override
  final int typeId = 1;

  @override
  HiveSearchHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSearchHistory(
      query: fields[0] as String,
      searchedAt: fields[1] as DateTime,
      resultCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSearchHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.searchedAt)
      ..writeByte(2)
      ..write(obj.resultCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSearchHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveUserPreferencesAdapter extends TypeAdapter<HiveUserPreferences> {
  @override
  final int typeId = 2;

  @override
  HiveUserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUserPreferences(
      darkMode: fields[0] as bool,
      autoPlayVideos: fields[1] as bool,
      defaultSearchFilter: fields[2] as String?,
      maxSearchHistoryItems: fields[3] as int,
      enableNotifications: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserPreferences obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.autoPlayVideos)
      ..writeByte(2)
      ..write(obj.defaultSearchFilter)
      ..writeByte(3)
      ..write(obj.maxSearchHistoryItems)
      ..writeByte(4)
      ..write(obj.enableNotifications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveTagWithCountAdapter extends TypeAdapter<HiveTagWithCount> {
  @override
  final int typeId = 3;

  @override
  HiveTagWithCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTagWithCount(
      tag: fields[0] as String,
      count: fields[1] as int,
      emoji: fields[2] as String?,
      cachedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTagWithCount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tag)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTagWithCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveCategoryWithCountAdapter extends TypeAdapter<HiveCategoryWithCount> {
  @override
  final int typeId = 4;

  @override
  HiveCategoryWithCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCategoryWithCount(
      category: fields[0] as String,
      count: fields[1] as int,
      emoji: fields[2] as String?,
      cachedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCategoryWithCount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCategoryWithCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
