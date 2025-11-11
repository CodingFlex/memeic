/// MemeConverter - Helper for Converting Between MemeModel and HiveMemeModel
///
/// This helper makes it easy to convert between:
/// - MemeModel (used in the app UI)
/// - HiveMemeModel (used for storage in Hive)
/// - Map<String, dynamic> (simple data format)
///
/// Think of this as a translator that converts between different "languages"
/// that represent the same meme data.

import 'package:memeic/models/hive_models.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';

class MemeConverter {
  /// Convert HiveMemeModel (from storage) to MemeModel (for UI)
  ///
  /// How it works:
  /// 1. Takes a HiveMemeModel (stored in Hive)
  /// 2. Converts it to a MemeModel (used in the app)
  ///
  /// Think of this as: "Take the stored meme and make it usable in the app"
  static MemeModel fromHiveModel(HiveMemeModel hiveMeme) {
    return MemeModel(
      id: hiveMeme.id,
      imageUrl: hiveMeme.imageUrl,
      title: hiveMeme.title,
      tags: hiveMeme.tags,
      showPreview: hiveMeme.showPreview,
    );
  }

  /// Convert MemeModel (from UI) to HiveMemeModel (for storage)
  ///
  /// How it works:
  /// 1. Takes a MemeModel (used in the app)
  /// 2. Converts it to a HiveMemeModel (for storage)
  ///
  /// Think of this as: "Take the meme from the app and prepare it for storage"
  static HiveMemeModel toHiveModel(MemeModel meme, {DateTime? savedAt}) {
    return HiveMemeModel(
      id: meme.id,
      imageUrl: meme.imageUrl,
      title: meme.title,
      tags: meme.tags,
      showPreview: meme.showPreview,
      savedAt: savedAt ?? DateTime.now(),
    );
  }

  /// Convert Map (from Hive) to MemeModel (for UI)
  ///
  /// How it works:
  /// 1. Takes a Map (data format from Hive)
  /// 2. Converts it to a MemeModel (for UI)
  ///
  /// Think of this as: "Take the raw data and make it a usable MemeModel"
  static MemeModel fromMap(Map<String, dynamic> map) {
    return MemeModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String?,
      tags: map['tags'] != null ? List<String>.from(map['tags'] as List) : null,
      showPreview: map['showPreview'] as bool? ?? false,
    );
  }

  /// Convert MemeModel (from UI) to Map (for storage)
  ///
  /// How it works:
  /// 1. Takes a MemeModel (from UI)
  /// 2. Converts it to a Map (for storage)
  ///
  /// Think of this as: "Take the MemeModel and convert it to raw data"
  static Map<String, dynamic> toMap(MemeModel meme) {
    return {
      'id': meme.id,
      'imageUrl': meme.imageUrl,
      'title': meme.title,
      'tags': meme.tags,
      'showPreview': meme.showPreview,
    };
  }

  /// Convert a list of Maps to a list of MemeModels
  ///
  /// How it works:
  /// 1. Takes a list of Maps (from Hive)
  /// 2. Converts each Map to a MemeModel
  /// 3. Returns a list of MemeModels
  ///
  /// Think of this as: "Convert a bunch of raw data into usable MemeModels"
  static List<MemeModel> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Convert a list of MemeModels to a list of Maps
  ///
  /// How it works:
  /// 1. Takes a list of MemeModels (from UI)
  /// 2. Converts each MemeModel to a Map
  /// 3. Returns a list of Maps
  ///
  /// Think of this as: "Convert a bunch of MemeModels into raw data"
  static List<Map<String, dynamic>> toMapList(List<MemeModel> memes) {
    return memes.map((meme) => toMap(meme)).toList();
  }
}
