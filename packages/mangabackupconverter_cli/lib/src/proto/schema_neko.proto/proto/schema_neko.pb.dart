//
//  Generated code. Do not modify.
//  source: proto/schema_neko.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'schema_neko.pbenum.dart';

class PreferenceValue extends $pb.GeneratedMessage {
  factory PreferenceValue({
    $core.String? type,
    $core.List<$core.int>? truevalue,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (truevalue != null) {
      $result.truevalue = truevalue;
    }
    return $result;
  }
  PreferenceValue._() : super();
  factory PreferenceValue.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PreferenceValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'PreferenceValue', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'type')
        ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'truevalue', $pb.PbFieldType.QY);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PreferenceValue clone() => PreferenceValue()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PreferenceValue copyWith(void Function(PreferenceValue) updates) =>
      super.copyWith((message) => updates(message as PreferenceValue)) as PreferenceValue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreferenceValue create() => PreferenceValue._();
  PreferenceValue createEmptyInstance() => create();
  static $pb.PbList<PreferenceValue> createRepeated() => $pb.PbList<PreferenceValue>();
  @$core.pragma('dart2js:noInline')
  static PreferenceValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreferenceValue>(create);
  static PreferenceValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get truevalue => $_getN(1);
  @$pb.TagNumber(2)
  set truevalue($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTruevalue() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruevalue() => clearField(2);
}

/// .editorconfig
/// Backup.kt
class Backup extends $pb.GeneratedMessage {
  factory Backup({
    $core.Iterable<BackupManga>? backupManga,
    $core.Iterable<BackupCategory>? backupCategories,
  }) {
    final $result = create();
    if (backupManga != null) {
      $result.backupManga.addAll(backupManga);
    }
    if (backupCategories != null) {
      $result.backupCategories.addAll(backupCategories);
    }
    return $result;
  }
  Backup._() : super();
  factory Backup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Backup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Backup', createEmptyInstance: create)
    ..pc<BackupManga>(1, _omitFieldNames ? '' : 'backupManga', $pb.PbFieldType.PM,
        protoName: 'backupManga', subBuilder: BackupManga.create)
    ..pc<BackupCategory>(2, _omitFieldNames ? '' : 'backupCategories', $pb.PbFieldType.PM,
        protoName: 'backupCategories', subBuilder: BackupCategory.create);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Backup clone() => Backup()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Backup copyWith(void Function(Backup) updates) => super.copyWith((message) => updates(message as Backup)) as Backup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Backup create() => Backup._();
  Backup createEmptyInstance() => create();
  static $pb.PbList<Backup> createRepeated() => $pb.PbList<Backup>();
  @$core.pragma('dart2js:noInline')
  static Backup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Backup>(create);
  static Backup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BackupManga> get backupManga => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<BackupCategory> get backupCategories => $_getList(1);
}

/// BackupCategory.kt
class BackupCategory extends $pb.GeneratedMessage {
  factory BackupCategory({
    $core.String? name,
    $core.int? order,
    $core.int? flags,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (order != null) {
      $result.order = order;
    }
    if (flags != null) {
      $result.flags = flags;
    }
    return $result;
  }
  BackupCategory._() : super();
  factory BackupCategory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupCategory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupCategory', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'name')
        ..a<$core.int>(2, _omitFieldNames ? '' : 'order', $pb.PbFieldType.O3)
        ..a<$core.int>(100, _omitFieldNames ? '' : 'flags', $pb.PbFieldType.O3);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupCategory clone() => BackupCategory()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupCategory copyWith(void Function(BackupCategory) updates) =>
      super.copyWith((message) => updates(message as BackupCategory)) as BackupCategory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupCategory create() => BackupCategory._();
  BackupCategory createEmptyInstance() => create();
  static $pb.PbList<BackupCategory> createRepeated() => $pb.PbList<BackupCategory>();
  @$core.pragma('dart2js:noInline')
  static BackupCategory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupCategory>(create);
  static BackupCategory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get order => $_getIZ(1);
  @$pb.TagNumber(2)
  set order($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => clearField(2);

  @$pb.TagNumber(100)
  $core.int get flags => $_getIZ(2);
  @$pb.TagNumber(100)
  set flags($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(100)
  $core.bool hasFlags() => $_has(2);
  @$pb.TagNumber(100)
  void clearFlags() => clearField(100);
}

/// BackupChapter.kt
class BackupChapter extends $pb.GeneratedMessage {
  factory BackupChapter({
    $core.String? url,
    $core.String? name,
    $core.String? scanlator,
    $core.bool? read,
    $core.bool? bookmark,
    $core.int? lastPageRead,
    $fixnum.Int64? dateFetch,
    $fixnum.Int64? dateUpload,
    $core.double? chapterNumber,
    $core.int? sourceOrder,
    $core.int? pagesLeft,
    $core.String? uploader,
    $core.bool? isUnavailable,
    $core.int? smartOrder,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (name != null) {
      $result.name = name;
    }
    if (scanlator != null) {
      $result.scanlator = scanlator;
    }
    if (read != null) {
      $result.read = read;
    }
    if (bookmark != null) {
      $result.bookmark = bookmark;
    }
    if (lastPageRead != null) {
      $result.lastPageRead = lastPageRead;
    }
    if (dateFetch != null) {
      $result.dateFetch = dateFetch;
    }
    if (dateUpload != null) {
      $result.dateUpload = dateUpload;
    }
    if (chapterNumber != null) {
      $result.chapterNumber = chapterNumber;
    }
    if (sourceOrder != null) {
      $result.sourceOrder = sourceOrder;
    }
    if (pagesLeft != null) {
      $result.pagesLeft = pagesLeft;
    }
    if (uploader != null) {
      $result.uploader = uploader;
    }
    if (isUnavailable != null) {
      $result.isUnavailable = isUnavailable;
    }
    if (smartOrder != null) {
      $result.smartOrder = smartOrder;
    }
    return $result;
  }
  BackupChapter._() : super();
  factory BackupChapter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupChapter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupChapter', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'url')
        ..aQS(2, _omitFieldNames ? '' : 'name')
        ..aOS(3, _omitFieldNames ? '' : 'scanlator')
        ..aOB(4, _omitFieldNames ? '' : 'read')
        ..aOB(5, _omitFieldNames ? '' : 'bookmark')
        ..a<$core.int>(6, _omitFieldNames ? '' : 'lastPageRead', $pb.PbFieldType.O3, protoName: 'lastPageRead')
        ..aInt64(7, _omitFieldNames ? '' : 'dateFetch', protoName: 'dateFetch')
        ..aInt64(8, _omitFieldNames ? '' : 'dateUpload', protoName: 'dateUpload')
        ..a<$core.double>(9, _omitFieldNames ? '' : 'chapterNumber', $pb.PbFieldType.OF, protoName: 'chapterNumber')
        ..a<$core.int>(10, _omitFieldNames ? '' : 'sourceOrder', $pb.PbFieldType.O3, protoName: 'sourceOrder')
        ..a<$core.int>(800, _omitFieldNames ? '' : 'pagesLeft', $pb.PbFieldType.O3, protoName: 'pagesLeft')
        ..aOS(905, _omitFieldNames ? '' : 'uploader')
        ..aOB(906, _omitFieldNames ? '' : 'isUnavailable', protoName: 'isUnavailable')
        ..a<$core.int>(907, _omitFieldNames ? '' : 'smartOrder', $pb.PbFieldType.O3, protoName: 'smartOrder');

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupChapter clone() => BackupChapter()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupChapter copyWith(void Function(BackupChapter) updates) =>
      super.copyWith((message) => updates(message as BackupChapter)) as BackupChapter;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupChapter create() => BackupChapter._();
  BackupChapter createEmptyInstance() => create();
  static $pb.PbList<BackupChapter> createRepeated() => $pb.PbList<BackupChapter>();
  @$core.pragma('dart2js:noInline')
  static BackupChapter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupChapter>(create);
  static BackupChapter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get scanlator => $_getSZ(2);
  @$pb.TagNumber(3)
  set scanlator($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasScanlator() => $_has(2);
  @$pb.TagNumber(3)
  void clearScanlator() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get read => $_getBF(3);
  @$pb.TagNumber(4)
  set read($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRead() => $_has(3);
  @$pb.TagNumber(4)
  void clearRead() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get bookmark => $_getBF(4);
  @$pb.TagNumber(5)
  set bookmark($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBookmark() => $_has(4);
  @$pb.TagNumber(5)
  void clearBookmark() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lastPageRead => $_getIZ(5);
  @$pb.TagNumber(6)
  set lastPageRead($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLastPageRead() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastPageRead() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get dateFetch => $_getI64(6);
  @$pb.TagNumber(7)
  set dateFetch($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDateFetch() => $_has(6);
  @$pb.TagNumber(7)
  void clearDateFetch() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get dateUpload => $_getI64(7);
  @$pb.TagNumber(8)
  set dateUpload($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasDateUpload() => $_has(7);
  @$pb.TagNumber(8)
  void clearDateUpload() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get chapterNumber => $_getN(8);
  @$pb.TagNumber(9)
  set chapterNumber($core.double v) {
    $_setFloat(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasChapterNumber() => $_has(8);
  @$pb.TagNumber(9)
  void clearChapterNumber() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get sourceOrder => $_getIZ(9);
  @$pb.TagNumber(10)
  set sourceOrder($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSourceOrder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceOrder() => clearField(10);

  @$pb.TagNumber(800)
  $core.int get pagesLeft => $_getIZ(10);
  @$pb.TagNumber(800)
  set pagesLeft($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(800)
  $core.bool hasPagesLeft() => $_has(10);
  @$pb.TagNumber(800)
  void clearPagesLeft() => clearField(800);

  @$pb.TagNumber(905)
  $core.String get uploader => $_getSZ(11);
  @$pb.TagNumber(905)
  set uploader($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(905)
  $core.bool hasUploader() => $_has(11);
  @$pb.TagNumber(905)
  void clearUploader() => clearField(905);

  @$pb.TagNumber(906)
  $core.bool get isUnavailable => $_getBF(12);
  @$pb.TagNumber(906)
  set isUnavailable($core.bool v) {
    $_setBool(12, v);
  }

  @$pb.TagNumber(906)
  $core.bool hasIsUnavailable() => $_has(12);
  @$pb.TagNumber(906)
  void clearIsUnavailable() => clearField(906);

  @$pb.TagNumber(907)
  $core.int get smartOrder => $_getIZ(13);
  @$pb.TagNumber(907)
  set smartOrder($core.int v) {
    $_setSignedInt32(13, v);
  }

  @$pb.TagNumber(907)
  $core.bool hasSmartOrder() => $_has(13);
  @$pb.TagNumber(907)
  void clearSmartOrder() => clearField(907);
}

/// BackupHistory.kt
class BrokenBackupHistory extends $pb.GeneratedMessage {
  factory BrokenBackupHistory({
    $core.String? url,
    $fixnum.Int64? lastRead,
    $fixnum.Int64? readDuration,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (lastRead != null) {
      $result.lastRead = lastRead;
    }
    if (readDuration != null) {
      $result.readDuration = readDuration;
    }
    return $result;
  }
  BrokenBackupHistory._() : super();
  factory BrokenBackupHistory.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BrokenBackupHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BrokenBackupHistory', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'url')
        ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'lastRead', $pb.PbFieldType.Q6,
            protoName: 'lastRead', defaultOrMaker: $fixnum.Int64.ZERO)
        ..aInt64(3, _omitFieldNames ? '' : 'readDuration', protoName: 'readDuration');

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BrokenBackupHistory clone() => BrokenBackupHistory()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BrokenBackupHistory copyWith(void Function(BrokenBackupHistory) updates) =>
      super.copyWith((message) => updates(message as BrokenBackupHistory)) as BrokenBackupHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BrokenBackupHistory create() => BrokenBackupHistory._();
  BrokenBackupHistory createEmptyInstance() => create();
  static $pb.PbList<BrokenBackupHistory> createRepeated() => $pb.PbList<BrokenBackupHistory>();
  @$core.pragma('dart2js:noInline')
  static BrokenBackupHistory getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BrokenBackupHistory>(create);
  static BrokenBackupHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastRead => $_getI64(1);
  @$pb.TagNumber(2)
  set lastRead($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLastRead() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastRead() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get readDuration => $_getI64(2);
  @$pb.TagNumber(3)
  set readDuration($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasReadDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadDuration() => clearField(3);
}

class BackupHistory extends $pb.GeneratedMessage {
  factory BackupHistory({
    $core.String? url,
    $fixnum.Int64? lastRead,
    $fixnum.Int64? readDuration,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (lastRead != null) {
      $result.lastRead = lastRead;
    }
    if (readDuration != null) {
      $result.readDuration = readDuration;
    }
    return $result;
  }
  BackupHistory._() : super();
  factory BackupHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupHistory', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'url')
        ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'lastRead', $pb.PbFieldType.Q6,
            protoName: 'lastRead', defaultOrMaker: $fixnum.Int64.ZERO)
        ..aInt64(3, _omitFieldNames ? '' : 'readDuration', protoName: 'readDuration');

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupHistory clone() => BackupHistory()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupHistory copyWith(void Function(BackupHistory) updates) =>
      super.copyWith((message) => updates(message as BackupHistory)) as BackupHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupHistory create() => BackupHistory._();
  BackupHistory createEmptyInstance() => create();
  static $pb.PbList<BackupHistory> createRepeated() => $pb.PbList<BackupHistory>();
  @$core.pragma('dart2js:noInline')
  static BackupHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupHistory>(create);
  static BackupHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastRead => $_getI64(1);
  @$pb.TagNumber(2)
  set lastRead($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLastRead() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastRead() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get readDuration => $_getI64(2);
  @$pb.TagNumber(3)
  set readDuration($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasReadDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadDuration() => clearField(3);
}

/// BackupManga.kt
class BackupManga extends $pb.GeneratedMessage {
  factory BackupManga({
    $fixnum.Int64? source,
    $core.String? url,
    $core.String? title,
    $core.String? artist,
    $core.String? author,
    $core.String? description,
    $core.Iterable<$core.String>? genre,
    $core.int? status,
    $core.String? thumbnailUrl,
    $fixnum.Int64? dateAdded,
    $core.int? viewer,
    $core.Iterable<BackupChapter>? chapters,
    $core.Iterable<$core.int>? categories,
    $core.Iterable<BackupTracking>? tracking,
    $core.bool? favorite,
    $core.int? chapterFlags,
    $core.Iterable<BrokenBackupHistory>? brokenHistory,
    $core.int? viewerFlags,
    $core.Iterable<BackupHistory>? history,
    $core.String? customTitle,
    $core.String? scanlatorFilter,
    $core.String? alternativeArtwork,
    $core.Iterable<BackupMergeManga>? mergeMangaList,
  }) {
    final $result = create();
    if (source != null) {
      $result.source = source;
    }
    if (url != null) {
      $result.url = url;
    }
    if (title != null) {
      $result.title = title;
    }
    if (artist != null) {
      $result.artist = artist;
    }
    if (author != null) {
      $result.author = author;
    }
    if (description != null) {
      $result.description = description;
    }
    if (genre != null) {
      $result.genre.addAll(genre);
    }
    if (status != null) {
      $result.status = status;
    }
    if (thumbnailUrl != null) {
      $result.thumbnailUrl = thumbnailUrl;
    }
    if (dateAdded != null) {
      $result.dateAdded = dateAdded;
    }
    if (viewer != null) {
      $result.viewer = viewer;
    }
    if (chapters != null) {
      $result.chapters.addAll(chapters);
    }
    if (categories != null) {
      $result.categories.addAll(categories);
    }
    if (tracking != null) {
      $result.tracking.addAll(tracking);
    }
    if (favorite != null) {
      $result.favorite = favorite;
    }
    if (chapterFlags != null) {
      $result.chapterFlags = chapterFlags;
    }
    if (brokenHistory != null) {
      $result.brokenHistory.addAll(brokenHistory);
    }
    if (viewerFlags != null) {
      $result.viewerFlags = viewerFlags;
    }
    if (history != null) {
      $result.history.addAll(history);
    }
    if (customTitle != null) {
      $result.customTitle = customTitle;
    }
    if (scanlatorFilter != null) {
      $result.scanlatorFilter = scanlatorFilter;
    }
    if (alternativeArtwork != null) {
      $result.alternativeArtwork = alternativeArtwork;
    }
    if (mergeMangaList != null) {
      $result.mergeMangaList.addAll(mergeMangaList);
    }
    return $result;
  }
  BackupManga._() : super();
  factory BackupManga.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupManga.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupManga', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'source', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'artist')
    ..aOS(5, _omitFieldNames ? '' : 'author')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..pPS(7, _omitFieldNames ? '' : 'genre')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(9, _omitFieldNames ? '' : 'thumbnailUrl', protoName: 'thumbnailUrl')
    ..aInt64(13, _omitFieldNames ? '' : 'dateAdded', protoName: 'dateAdded')
    ..a<$core.int>(14, _omitFieldNames ? '' : 'viewer', $pb.PbFieldType.O3)
    ..pc<BackupChapter>(16, _omitFieldNames ? '' : 'chapters', $pb.PbFieldType.PM, subBuilder: BackupChapter.create)
    ..p<$core.int>(17, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.P3)
    ..pc<BackupTracking>(18, _omitFieldNames ? '' : 'tracking', $pb.PbFieldType.PM, subBuilder: BackupTracking.create)
    ..aOB(100, _omitFieldNames ? '' : 'favorite')
    ..a<$core.int>(101, _omitFieldNames ? '' : 'chapterFlags', $pb.PbFieldType.O3, protoName: 'chapterFlags')
    ..pc<BrokenBackupHistory>(102, _omitFieldNames ? '' : 'brokenHistory', $pb.PbFieldType.PM,
        protoName: 'brokenHistory', subBuilder: BrokenBackupHistory.create)
    ..a<$core.int>(103, _omitFieldNames ? '' : 'viewerFlags', $pb.PbFieldType.O3)
    ..pc<BackupHistory>(104, _omitFieldNames ? '' : 'history', $pb.PbFieldType.PM, subBuilder: BackupHistory.create)
    ..aOS(800, _omitFieldNames ? '' : 'customTitle', protoName: 'customTitle')
    ..aOS(901, _omitFieldNames ? '' : 'scanlatorFilter', protoName: 'scanlatorFilter')
    ..aOS(903, _omitFieldNames ? '' : 'alternativeArtwork', protoName: 'alternativeArtwork')
    ..pc<BackupMergeManga>(904, _omitFieldNames ? '' : 'mergeMangaList', $pb.PbFieldType.PM,
        protoName: 'mergeMangaList', subBuilder: BackupMergeManga.create);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupManga clone() => BackupManga()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupManga copyWith(void Function(BackupManga) updates) =>
      super.copyWith((message) => updates(message as BackupManga)) as BackupManga;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupManga create() => BackupManga._();
  BackupManga createEmptyInstance() => create();
  static $pb.PbList<BackupManga> createRepeated() => $pb.PbList<BackupManga>();
  @$core.pragma('dart2js:noInline')
  static BackupManga getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupManga>(create);
  static BackupManga? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get source => $_getI64(0);
  @$pb.TagNumber(1)
  set source($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get artist => $_getSZ(3);
  @$pb.TagNumber(4)
  set artist($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasArtist() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtist() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get author => $_getSZ(4);
  @$pb.TagNumber(5)
  set author($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.String> get genre => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get status => $_getIZ(7);
  @$pb.TagNumber(8)
  set status($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get thumbnailUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set thumbnailUrl($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasThumbnailUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearThumbnailUrl() => clearField(9);

  @$pb.TagNumber(13)
  $fixnum.Int64 get dateAdded => $_getI64(9);
  @$pb.TagNumber(13)
  set dateAdded($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasDateAdded() => $_has(9);
  @$pb.TagNumber(13)
  void clearDateAdded() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get viewer => $_getIZ(10);
  @$pb.TagNumber(14)
  set viewer($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasViewer() => $_has(10);
  @$pb.TagNumber(14)
  void clearViewer() => clearField(14);

  @$pb.TagNumber(16)
  $core.List<BackupChapter> get chapters => $_getList(11);

  @$pb.TagNumber(17)
  $core.List<$core.int> get categories => $_getList(12);

  @$pb.TagNumber(18)
  $core.List<BackupTracking> get tracking => $_getList(13);

  @$pb.TagNumber(100)
  $core.bool get favorite => $_getBF(14);
  @$pb.TagNumber(100)
  set favorite($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(100)
  $core.bool hasFavorite() => $_has(14);
  @$pb.TagNumber(100)
  void clearFavorite() => clearField(100);

  @$pb.TagNumber(101)
  $core.int get chapterFlags => $_getIZ(15);
  @$pb.TagNumber(101)
  set chapterFlags($core.int v) {
    $_setSignedInt32(15, v);
  }

  @$pb.TagNumber(101)
  $core.bool hasChapterFlags() => $_has(15);
  @$pb.TagNumber(101)
  void clearChapterFlags() => clearField(101);

  @$pb.TagNumber(102)
  $core.List<BrokenBackupHistory> get brokenHistory => $_getList(16);

  @$pb.TagNumber(103)
  $core.int get viewerFlags => $_getIZ(17);
  @$pb.TagNumber(103)
  set viewerFlags($core.int v) {
    $_setSignedInt32(17, v);
  }

  @$pb.TagNumber(103)
  $core.bool hasViewerFlags() => $_has(17);
  @$pb.TagNumber(103)
  void clearViewerFlags() => clearField(103);

  @$pb.TagNumber(104)
  $core.List<BackupHistory> get history => $_getList(18);

  @$pb.TagNumber(800)
  $core.String get customTitle => $_getSZ(19);
  @$pb.TagNumber(800)
  set customTitle($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(800)
  $core.bool hasCustomTitle() => $_has(19);
  @$pb.TagNumber(800)
  void clearCustomTitle() => clearField(800);

  @$pb.TagNumber(901)
  $core.String get scanlatorFilter => $_getSZ(20);
  @$pb.TagNumber(901)
  set scanlatorFilter($core.String v) {
    $_setString(20, v);
  }

  @$pb.TagNumber(901)
  $core.bool hasScanlatorFilter() => $_has(20);
  @$pb.TagNumber(901)
  void clearScanlatorFilter() => clearField(901);

  @$pb.TagNumber(903)
  $core.String get alternativeArtwork => $_getSZ(21);
  @$pb.TagNumber(903)
  set alternativeArtwork($core.String v) {
    $_setString(21, v);
  }

  @$pb.TagNumber(903)
  $core.bool hasAlternativeArtwork() => $_has(21);
  @$pb.TagNumber(903)
  void clearAlternativeArtwork() => clearField(903);

  @$pb.TagNumber(904)
  $core.List<BackupMergeManga> get mergeMangaList => $_getList(22);
}

/// BackupMergeManga.kt
class BackupMergeManga extends $pb.GeneratedMessage {
  factory BackupMergeManga({
    $core.String? url,
    $core.String? title,
    $core.String? coverUrl,
    $core.int? mergeType,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (title != null) {
      $result.title = title;
    }
    if (coverUrl != null) {
      $result.coverUrl = coverUrl;
    }
    if (mergeType != null) {
      $result.mergeType = mergeType;
    }
    return $result;
  }
  BackupMergeManga._() : super();
  factory BackupMergeManga.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupMergeManga.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupMergeManga', createEmptyInstance: create)
        ..aQS(1, _omitFieldNames ? '' : 'url')
        ..aOS(2, _omitFieldNames ? '' : 'title')
        ..aOS(3, _omitFieldNames ? '' : 'coverUrl', protoName: 'coverUrl')
        ..a<$core.int>(4, _omitFieldNames ? '' : 'mergeType', $pb.PbFieldType.Q3, protoName: 'mergeType');

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupMergeManga clone() => BackupMergeManga()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupMergeManga copyWith(void Function(BackupMergeManga) updates) =>
      super.copyWith((message) => updates(message as BackupMergeManga)) as BackupMergeManga;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupMergeManga create() => BackupMergeManga._();
  BackupMergeManga createEmptyInstance() => create();
  static $pb.PbList<BackupMergeManga> createRepeated() => $pb.PbList<BackupMergeManga>();
  @$core.pragma('dart2js:noInline')
  static BackupMergeManga getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupMergeManga>(create);
  static BackupMergeManga? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get coverUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverUrl($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCoverUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get mergeType => $_getIZ(3);
  @$pb.TagNumber(4)
  set mergeType($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMergeType() => $_has(3);
  @$pb.TagNumber(4)
  void clearMergeType() => clearField(4);
}

/// BackupTracking.kt
class BackupTracking extends $pb.GeneratedMessage {
  factory BackupTracking({
    $core.int? syncId,
    $fixnum.Int64? libraryId,
    $core.int? mediaIdInt,
    $core.String? trackingUrl,
    $core.String? title,
    $core.double? lastChapterRead,
    $core.int? totalChapters,
    $core.double? score,
    $core.int? status,
    $fixnum.Int64? startedReadingDate,
    $fixnum.Int64? finishedReadingDate,
    $fixnum.Int64? mediaId,
  }) {
    final $result = create();
    if (syncId != null) {
      $result.syncId = syncId;
    }
    if (libraryId != null) {
      $result.libraryId = libraryId;
    }
    if (mediaIdInt != null) {
      $result.mediaIdInt = mediaIdInt;
    }
    if (trackingUrl != null) {
      $result.trackingUrl = trackingUrl;
    }
    if (title != null) {
      $result.title = title;
    }
    if (lastChapterRead != null) {
      $result.lastChapterRead = lastChapterRead;
    }
    if (totalChapters != null) {
      $result.totalChapters = totalChapters;
    }
    if (score != null) {
      $result.score = score;
    }
    if (status != null) {
      $result.status = status;
    }
    if (startedReadingDate != null) {
      $result.startedReadingDate = startedReadingDate;
    }
    if (finishedReadingDate != null) {
      $result.finishedReadingDate = finishedReadingDate;
    }
    if (mediaId != null) {
      $result.mediaId = mediaId;
    }
    return $result;
  }
  BackupTracking._() : super();
  factory BackupTracking.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BackupTracking.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'BackupTracking', createEmptyInstance: create)
        ..a<$core.int>(1, _omitFieldNames ? '' : 'syncId', $pb.PbFieldType.Q3, protoName: 'syncId')
        ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'libraryId', $pb.PbFieldType.Q6,
            protoName: 'libraryId', defaultOrMaker: $fixnum.Int64.ZERO)
        ..a<$core.int>(3, _omitFieldNames ? '' : 'mediaIdInt', $pb.PbFieldType.O3, protoName: 'mediaIdInt')
        ..aOS(4, _omitFieldNames ? '' : 'trackingUrl', protoName: 'trackingUrl')
        ..aOS(5, _omitFieldNames ? '' : 'title')
        ..a<$core.double>(6, _omitFieldNames ? '' : 'lastChapterRead', $pb.PbFieldType.OF, protoName: 'lastChapterRead')
        ..a<$core.int>(7, _omitFieldNames ? '' : 'totalChapters', $pb.PbFieldType.O3, protoName: 'totalChapters')
        ..a<$core.double>(8, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OF)
        ..a<$core.int>(9, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
        ..aInt64(10, _omitFieldNames ? '' : 'startedReadingDate', protoName: 'startedReadingDate')
        ..aInt64(11, _omitFieldNames ? '' : 'finishedReadingDate', protoName: 'finishedReadingDate')
        ..aInt64(100, _omitFieldNames ? '' : 'mediaId', protoName: 'mediaId');

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BackupTracking clone() => BackupTracking()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BackupTracking copyWith(void Function(BackupTracking) updates) =>
      super.copyWith((message) => updates(message as BackupTracking)) as BackupTracking;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BackupTracking create() => BackupTracking._();
  BackupTracking createEmptyInstance() => create();
  static $pb.PbList<BackupTracking> createRepeated() => $pb.PbList<BackupTracking>();
  @$core.pragma('dart2js:noInline')
  static BackupTracking getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackupTracking>(create);
  static BackupTracking? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get syncId => $_getIZ(0);
  @$pb.TagNumber(1)
  set syncId($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSyncId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSyncId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get mediaIdInt => $_getIZ(2);
  @$pb.TagNumber(3)
  set mediaIdInt($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMediaIdInt() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaIdInt() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get trackingUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set trackingUrl($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTrackingUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrackingUrl() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get lastChapterRead => $_getN(5);
  @$pb.TagNumber(6)
  set lastChapterRead($core.double v) {
    $_setFloat(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLastChapterRead() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastChapterRead() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalChapters => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalChapters($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTotalChapters() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalChapters() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get score => $_getN(7);
  @$pb.TagNumber(8)
  set score($core.double v) {
    $_setFloat(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearScore() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get status => $_getIZ(8);
  @$pb.TagNumber(9)
  set status($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get startedReadingDate => $_getI64(9);
  @$pb.TagNumber(10)
  set startedReadingDate($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasStartedReadingDate() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartedReadingDate() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get finishedReadingDate => $_getI64(10);
  @$pb.TagNumber(11)
  set finishedReadingDate($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasFinishedReadingDate() => $_has(10);
  @$pb.TagNumber(11)
  void clearFinishedReadingDate() => clearField(11);

  @$pb.TagNumber(100)
  $fixnum.Int64 get mediaId => $_getI64(11);
  @$pb.TagNumber(100)
  set mediaId($fixnum.Int64 v) {
    $_setInt64(11, v);
  }

  @$pb.TagNumber(100)
  $core.bool hasMediaId() => $_has(11);
  @$pb.TagNumber(100)
  void clearMediaId() => clearField(100);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
