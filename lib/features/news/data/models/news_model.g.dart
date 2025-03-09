import 'package:hive/hive.dart';
import 'package:appsguardian/features/news/data/models/news_model.dart';

class NewsModelAdapter extends TypeAdapter<NewsModel> {
  @override
  final int typeId = 0;

  @override
  NewsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return NewsModel(
      title: fields[0] as String,
      images: (fields[1] as List).cast<String>(),
      contents: fields[2] as String,
      date: fields[3] as DateTime,
      source: fields[4] as String? ?? 'No Source',  // Handling null values
      author: fields[5] as String? ?? 'Unknown Author',  // Handling null values
      description: fields[6] as String? ?? 'No description available',  // Handling null values
      url: fields[7] as String? ?? '',  // Handling null values
    );
  }

  @override
  void write(BinaryWriter writer, NewsModel obj) {
    writer
      ..writeByte(8)  // Updated field count
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.contents)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)  // Write new field
      ..write(obj.author)
      ..writeByte(6)  // Write new field
      ..write(obj.description)
      ..writeByte(7)  // Write new field
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewsModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
