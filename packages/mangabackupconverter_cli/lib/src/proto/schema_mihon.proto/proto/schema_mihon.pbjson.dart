//
//  Generated code. Do not modify.
//  source: proto/schema_mihon.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use updateStrategyDescriptor instead')
const UpdateStrategy$json = {
  '1': 'UpdateStrategy',
  '2': [
    {'1': 'ALWAYS_UPDATE', '2': 0},
    {'1': 'ONLY_FETCH_ONCE', '2': 1},
  ],
};

/// Descriptor for `UpdateStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List updateStrategyDescriptor = $convert.base64Decode(
    'Cg5VcGRhdGVTdHJhdGVneRIRCg1BTFdBWVNfVVBEQVRFEAASEwoPT05MWV9GRVRDSF9PTkNFEA'
    'E=');

@$core.Deprecated('Use preferenceValueDescriptor instead')
const PreferenceValue$json = {
  '1': 'PreferenceValue',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 9, '10': 'type'},
    {'1': 'truevalue', '3': 2, '4': 2, '5': 12, '10': 'truevalue'},
  ],
};

/// Descriptor for `PreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preferenceValueDescriptor = $convert.base64Decode(
    'Cg9QcmVmZXJlbmNlVmFsdWUSEgoEdHlwZRgBIAIoCVIEdHlwZRIcCgl0cnVldmFsdWUYAiACKA'
    'xSCXRydWV2YWx1ZQ==');

@$core.Deprecated('Use backupDescriptor instead')
const Backup$json = {
  '1': 'Backup',
  '2': [
    {
      '1': 'backupManga',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.BackupManga',
      '10': 'backupManga'
    },
    {
      '1': 'backupCategories',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.BackupCategory',
      '10': 'backupCategories'
    },
    {
      '1': 'backupSources',
      '3': 101,
      '4': 3,
      '5': 11,
      '6': '.BackupSource',
      '10': 'backupSources'
    },
    {
      '1': 'backupPreferences',
      '3': 104,
      '4': 3,
      '5': 11,
      '6': '.BackupPreference',
      '10': 'backupPreferences'
    },
    {
      '1': 'backupSourcePreferences',
      '3': 105,
      '4': 3,
      '5': 11,
      '6': '.BackupSourcePreferences',
      '10': 'backupSourcePreferences'
    },
    {
      '1': 'backupExtensionRepo',
      '3': 106,
      '4': 3,
      '5': 11,
      '6': '.BackupExtensionRepos',
      '10': 'backupExtensionRepo'
    },
  ],
};

/// Descriptor for `Backup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupDescriptor = $convert.base64Decode(
    'CgZCYWNrdXASLgoLYmFja3VwTWFuZ2EYASADKAsyDC5CYWNrdXBNYW5nYVILYmFja3VwTWFuZ2'
    'ESOwoQYmFja3VwQ2F0ZWdvcmllcxgCIAMoCzIPLkJhY2t1cENhdGVnb3J5UhBiYWNrdXBDYXRl'
    'Z29yaWVzEjMKDWJhY2t1cFNvdXJjZXMYZSADKAsyDS5CYWNrdXBTb3VyY2VSDWJhY2t1cFNvdX'
    'JjZXMSPwoRYmFja3VwUHJlZmVyZW5jZXMYaCADKAsyES5CYWNrdXBQcmVmZXJlbmNlUhFiYWNr'
    'dXBQcmVmZXJlbmNlcxJSChdiYWNrdXBTb3VyY2VQcmVmZXJlbmNlcxhpIAMoCzIYLkJhY2t1cF'
    'NvdXJjZVByZWZlcmVuY2VzUhdiYWNrdXBTb3VyY2VQcmVmZXJlbmNlcxJHChNiYWNrdXBFeHRl'
    'bnNpb25SZXBvGGogAygLMhUuQmFja3VwRXh0ZW5zaW9uUmVwb3NSE2JhY2t1cEV4dGVuc2lvbl'
    'JlcG8=');

@$core.Deprecated('Use backupCategoryDescriptor instead')
const BackupCategory$json = {
  '1': 'BackupCategory',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'order', '3': 2, '4': 1, '5': 3, '10': 'order'},
    {'1': 'id', '3': 3, '4': 1, '5': 3, '10': 'id'},
    {'1': 'flags', '3': 100, '4': 1, '5': 3, '10': 'flags'},
  ],
};

/// Descriptor for `BackupCategory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupCategoryDescriptor = $convert.base64Decode(
    'Cg5CYWNrdXBDYXRlZ29yeRISCgRuYW1lGAEgAigJUgRuYW1lEhQKBW9yZGVyGAIgASgDUgVvcm'
    'RlchIOCgJpZBgDIAEoA1ICaWQSFAoFZmxhZ3MYZCABKANSBWZsYWdz');

@$core.Deprecated('Use backupChapterDescriptor instead')
const BackupChapter$json = {
  '1': 'BackupChapter',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'scanlator', '3': 3, '4': 1, '5': 9, '10': 'scanlator'},
    {'1': 'read', '3': 4, '4': 1, '5': 8, '10': 'read'},
    {'1': 'bookmark', '3': 5, '4': 1, '5': 8, '10': 'bookmark'},
    {'1': 'lastPageRead', '3': 6, '4': 1, '5': 3, '10': 'lastPageRead'},
    {'1': 'dateFetch', '3': 7, '4': 1, '5': 3, '10': 'dateFetch'},
    {'1': 'dateUpload', '3': 8, '4': 1, '5': 3, '10': 'dateUpload'},
    {'1': 'chapterNumber', '3': 9, '4': 1, '5': 2, '10': 'chapterNumber'},
    {'1': 'sourceOrder', '3': 10, '4': 1, '5': 3, '10': 'sourceOrder'},
    {'1': 'lastModifiedAt', '3': 11, '4': 1, '5': 3, '10': 'lastModifiedAt'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `BackupChapter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupChapterDescriptor = $convert.base64Decode(
    'Cg1CYWNrdXBDaGFwdGVyEhAKA3VybBgBIAIoCVIDdXJsEhIKBG5hbWUYAiACKAlSBG5hbWUSHA'
    'oJc2NhbmxhdG9yGAMgASgJUglzY2FubGF0b3ISEgoEcmVhZBgEIAEoCFIEcmVhZBIaCghib29r'
    'bWFyaxgFIAEoCFIIYm9va21hcmsSIgoMbGFzdFBhZ2VSZWFkGAYgASgDUgxsYXN0UGFnZVJlYW'
    'QSHAoJZGF0ZUZldGNoGAcgASgDUglkYXRlRmV0Y2gSHgoKZGF0ZVVwbG9hZBgIIAEoA1IKZGF0'
    'ZVVwbG9hZBIkCg1jaGFwdGVyTnVtYmVyGAkgASgCUg1jaGFwdGVyTnVtYmVyEiAKC3NvdXJjZU'
    '9yZGVyGAogASgDUgtzb3VyY2VPcmRlchImCg5sYXN0TW9kaWZpZWRBdBgLIAEoA1IObGFzdE1v'
    'ZGlmaWVkQXQSGAoHdmVyc2lvbhgMIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use backupExtensionReposDescriptor instead')
const BackupExtensionRepos$json = {
  '1': 'BackupExtensionRepos',
  '2': [
    {'1': 'baseUrl', '3': 1, '4': 2, '5': 9, '10': 'baseUrl'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'shortName', '3': 3, '4': 1, '5': 9, '10': 'shortName'},
    {'1': 'website', '3': 4, '4': 2, '5': 9, '10': 'website'},
    {
      '1': 'signingKeyFingerprint',
      '3': 5,
      '4': 2,
      '5': 9,
      '10': 'signingKeyFingerprint'
    },
  ],
};

/// Descriptor for `BackupExtensionRepos`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupExtensionReposDescriptor = $convert.base64Decode(
    'ChRCYWNrdXBFeHRlbnNpb25SZXBvcxIYCgdiYXNlVXJsGAEgAigJUgdiYXNlVXJsEhIKBG5hbW'
    'UYAiACKAlSBG5hbWUSHAoJc2hvcnROYW1lGAMgASgJUglzaG9ydE5hbWUSGAoHd2Vic2l0ZRgE'
    'IAIoCVIHd2Vic2l0ZRI0ChVzaWduaW5nS2V5RmluZ2VycHJpbnQYBSACKAlSFXNpZ25pbmdLZX'
    'lGaW5nZXJwcmludA==');

@$core.Deprecated('Use backupHistoryDescriptor instead')
const BackupHistory$json = {
  '1': 'BackupHistory',
  '2': [
    {'1': 'url', '3': 1, '4': 2, '5': 9, '10': 'url'},
    {'1': 'lastRead', '3': 2, '4': 2, '5': 3, '10': 'lastRead'},
    {'1': 'readDuration', '3': 3, '4': 1, '5': 3, '10': 'readDuration'},
  ],
};

/// Descriptor for `BackupHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupHistoryDescriptor = $convert.base64Decode(
    'Cg1CYWNrdXBIaXN0b3J5EhAKA3VybBgBIAIoCVIDdXJsEhoKCGxhc3RSZWFkGAIgAigDUghsYX'
    'N0UmVhZBIiCgxyZWFkRHVyYXRpb24YAyABKANSDHJlYWREdXJhdGlvbg==');

@$core.Deprecated('Use backupMangaDescriptor instead')
const BackupManga$json = {
  '1': 'BackupManga',
  '2': [
    {'1': 'source', '3': 1, '4': 2, '5': 3, '10': 'source'},
    {'1': 'url', '3': 2, '4': 2, '5': 9, '10': 'url'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist', '3': 4, '4': 1, '5': 9, '10': 'artist'},
    {'1': 'author', '3': 5, '4': 1, '5': 9, '10': 'author'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'genre', '3': 7, '4': 3, '5': 9, '10': 'genre'},
    {'1': 'status', '3': 8, '4': 1, '5': 5, '10': 'status'},
    {'1': 'thumbnailUrl', '3': 9, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'dateAdded', '3': 13, '4': 1, '5': 3, '10': 'dateAdded'},
    {'1': 'viewer', '3': 14, '4': 1, '5': 5, '10': 'viewer'},
    {
      '1': 'chapters',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.BackupChapter',
      '10': 'chapters'
    },
    {'1': 'categories', '3': 17, '4': 3, '5': 3, '10': 'categories'},
    {
      '1': 'tracking',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.BackupTracking',
      '10': 'tracking'
    },
    {'1': 'favorite', '3': 100, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'chapterFlags', '3': 101, '4': 1, '5': 5, '10': 'chapterFlags'},
    {'1': 'viewer_flags', '3': 103, '4': 1, '5': 5, '10': 'viewerFlags'},
    {
      '1': 'history',
      '3': 104,
      '4': 3,
      '5': 11,
      '6': '.BackupHistory',
      '10': 'history'
    },
    {
      '1': 'updateStrategy',
      '3': 105,
      '4': 1,
      '5': 14,
      '6': '.UpdateStrategy',
      '10': 'updateStrategy'
    },
    {'1': 'lastModifiedAt', '3': 106, '4': 1, '5': 3, '10': 'lastModifiedAt'},
    {
      '1': 'favoriteModifiedAt',
      '3': 107,
      '4': 1,
      '5': 3,
      '10': 'favoriteModifiedAt'
    },
    {
      '1': 'excludedScanlators',
      '3': 108,
      '4': 3,
      '5': 9,
      '10': 'excludedScanlators'
    },
    {'1': 'version', '3': 109, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `BackupManga`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupMangaDescriptor = $convert.base64Decode(
    'CgtCYWNrdXBNYW5nYRIWCgZzb3VyY2UYASACKANSBnNvdXJjZRIQCgN1cmwYAiACKAlSA3VybB'
    'IUCgV0aXRsZRgDIAEoCVIFdGl0bGUSFgoGYXJ0aXN0GAQgASgJUgZhcnRpc3QSFgoGYXV0aG9y'
    'GAUgASgJUgZhdXRob3ISIAoLZGVzY3JpcHRpb24YBiABKAlSC2Rlc2NyaXB0aW9uEhQKBWdlbn'
    'JlGAcgAygJUgVnZW5yZRIWCgZzdGF0dXMYCCABKAVSBnN0YXR1cxIiCgx0aHVtYm5haWxVcmwY'
    'CSABKAlSDHRodW1ibmFpbFVybBIcCglkYXRlQWRkZWQYDSABKANSCWRhdGVBZGRlZBIWCgZ2aW'
    'V3ZXIYDiABKAVSBnZpZXdlchIqCghjaGFwdGVycxgQIAMoCzIOLkJhY2t1cENoYXB0ZXJSCGNo'
    'YXB0ZXJzEh4KCmNhdGVnb3JpZXMYESADKANSCmNhdGVnb3JpZXMSKwoIdHJhY2tpbmcYEiADKA'
    'syDy5CYWNrdXBUcmFja2luZ1IIdHJhY2tpbmcSGgoIZmF2b3JpdGUYZCABKAhSCGZhdm9yaXRl'
    'EiIKDGNoYXB0ZXJGbGFncxhlIAEoBVIMY2hhcHRlckZsYWdzEiEKDHZpZXdlcl9mbGFncxhnIA'
    'EoBVILdmlld2VyRmxhZ3MSKAoHaGlzdG9yeRhoIAMoCzIOLkJhY2t1cEhpc3RvcnlSB2hpc3Rv'
    'cnkSNwoOdXBkYXRlU3RyYXRlZ3kYaSABKA4yDy5VcGRhdGVTdHJhdGVneVIOdXBkYXRlU3RyYX'
    'RlZ3kSJgoObGFzdE1vZGlmaWVkQXQYaiABKANSDmxhc3RNb2RpZmllZEF0Ei4KEmZhdm9yaXRl'
    'TW9kaWZpZWRBdBhrIAEoA1ISZmF2b3JpdGVNb2RpZmllZEF0Ei4KEmV4Y2x1ZGVkU2NhbmxhdG'
    '9ycxhsIAMoCVISZXhjbHVkZWRTY2FubGF0b3JzEhgKB3ZlcnNpb24YbSABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use backupPreferenceDescriptor instead')
const BackupPreference$json = {
  '1': 'BackupPreference',
  '2': [
    {'1': 'key', '3': 1, '4': 2, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.PreferenceValue',
      '10': 'value'
    },
  ],
};

/// Descriptor for `BackupPreference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupPreferenceDescriptor = $convert.base64Decode(
    'ChBCYWNrdXBQcmVmZXJlbmNlEhAKA2tleRgBIAIoCVIDa2V5EiYKBXZhbHVlGAIgAigLMhAuUH'
    'JlZmVyZW5jZVZhbHVlUgV2YWx1ZQ==');

@$core.Deprecated('Use backupSourcePreferencesDescriptor instead')
const BackupSourcePreferences$json = {
  '1': 'BackupSourcePreferences',
  '2': [
    {'1': 'sourceKey', '3': 1, '4': 2, '5': 9, '10': 'sourceKey'},
    {
      '1': 'prefs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.BackupPreference',
      '10': 'prefs'
    },
  ],
};

/// Descriptor for `BackupSourcePreferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupSourcePreferencesDescriptor =
    $convert.base64Decode(
        'ChdCYWNrdXBTb3VyY2VQcmVmZXJlbmNlcxIcCglzb3VyY2VLZXkYASACKAlSCXNvdXJjZUtleR'
        'InCgVwcmVmcxgCIAMoCzIRLkJhY2t1cFByZWZlcmVuY2VSBXByZWZz');

@$core.Deprecated('Use intPreferenceValueDescriptor instead')
const IntPreferenceValue$json = {
  '1': 'IntPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 5, '10': 'value'},
  ],
};

/// Descriptor for `IntPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intPreferenceValueDescriptor = $convert
    .base64Decode('ChJJbnRQcmVmZXJlbmNlVmFsdWUSFAoFdmFsdWUYASACKAVSBXZhbHVl');

@$core.Deprecated('Use longPreferenceValueDescriptor instead')
const LongPreferenceValue$json = {
  '1': 'LongPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 3, '10': 'value'},
  ],
};

/// Descriptor for `LongPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List longPreferenceValueDescriptor =
    $convert.base64Decode(
        'ChNMb25nUHJlZmVyZW5jZVZhbHVlEhQKBXZhbHVlGAEgAigDUgV2YWx1ZQ==');

@$core.Deprecated('Use floatPreferenceValueDescriptor instead')
const FloatPreferenceValue$json = {
  '1': 'FloatPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 2, '10': 'value'},
  ],
};

/// Descriptor for `FloatPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List floatPreferenceValueDescriptor =
    $convert.base64Decode(
        'ChRGbG9hdFByZWZlcmVuY2VWYWx1ZRIUCgV2YWx1ZRgBIAIoAlIFdmFsdWU=');

@$core.Deprecated('Use stringPreferenceValueDescriptor instead')
const StringPreferenceValue$json = {
  '1': 'StringPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringPreferenceValueDescriptor =
    $convert.base64Decode(
        'ChVTdHJpbmdQcmVmZXJlbmNlVmFsdWUSFAoFdmFsdWUYASACKAlSBXZhbHVl');

@$core.Deprecated('Use booleanPreferenceValueDescriptor instead')
const BooleanPreferenceValue$json = {
  '1': 'BooleanPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 8, '10': 'value'},
  ],
};

/// Descriptor for `BooleanPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List booleanPreferenceValueDescriptor =
    $convert.base64Decode(
        'ChZCb29sZWFuUHJlZmVyZW5jZVZhbHVlEhQKBXZhbHVlGAEgAigIUgV2YWx1ZQ==');

@$core.Deprecated('Use stringSetPreferenceValueDescriptor instead')
const StringSetPreferenceValue$json = {
  '1': 'StringSetPreferenceValue',
  '2': [
    {'1': 'value', '3': 1, '4': 3, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StringSetPreferenceValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringSetPreferenceValueDescriptor =
    $convert.base64Decode(
        'ChhTdHJpbmdTZXRQcmVmZXJlbmNlVmFsdWUSFAoFdmFsdWUYASADKAlSBXZhbHVl');

@$core.Deprecated('Use backupSourceDescriptor instead')
const BackupSource$json = {
  '1': 'BackupSource',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sourceId', '3': 2, '4': 2, '5': 3, '10': 'sourceId'},
  ],
};

/// Descriptor for `BackupSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupSourceDescriptor = $convert.base64Decode(
    'CgxCYWNrdXBTb3VyY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIaCghzb3VyY2VJZBgCIAIoA1IIc2'
    '91cmNlSWQ=');

@$core.Deprecated('Use backupTrackingDescriptor instead')
const BackupTracking$json = {
  '1': 'BackupTracking',
  '2': [
    {'1': 'syncId', '3': 1, '4': 2, '5': 5, '10': 'syncId'},
    {'1': 'libraryId', '3': 2, '4': 2, '5': 3, '10': 'libraryId'},
    {'1': 'mediaIdInt', '3': 3, '4': 1, '5': 5, '10': 'mediaIdInt'},
    {'1': 'trackingUrl', '3': 4, '4': 1, '5': 9, '10': 'trackingUrl'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'lastChapterRead', '3': 6, '4': 1, '5': 2, '10': 'lastChapterRead'},
    {'1': 'totalChapters', '3': 7, '4': 1, '5': 5, '10': 'totalChapters'},
    {'1': 'score', '3': 8, '4': 1, '5': 2, '10': 'score'},
    {'1': 'status', '3': 9, '4': 1, '5': 5, '10': 'status'},
    {
      '1': 'startedReadingDate',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'startedReadingDate'
    },
    {
      '1': 'finishedReadingDate',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'finishedReadingDate'
    },
    {'1': 'private', '3': 12, '4': 1, '5': 8, '10': 'private'},
    {'1': 'mediaId', '3': 100, '4': 1, '5': 3, '10': 'mediaId'},
  ],
};

/// Descriptor for `BackupTracking`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupTrackingDescriptor = $convert.base64Decode(
    'Cg5CYWNrdXBUcmFja2luZxIWCgZzeW5jSWQYASACKAVSBnN5bmNJZBIcCglsaWJyYXJ5SWQYAi'
    'ACKANSCWxpYnJhcnlJZBIeCgptZWRpYUlkSW50GAMgASgFUgptZWRpYUlkSW50EiAKC3RyYWNr'
    'aW5nVXJsGAQgASgJUgt0cmFja2luZ1VybBIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSKAoPbGFzdE'
    'NoYXB0ZXJSZWFkGAYgASgCUg9sYXN0Q2hhcHRlclJlYWQSJAoNdG90YWxDaGFwdGVycxgHIAEo'
    'BVINdG90YWxDaGFwdGVycxIUCgVzY29yZRgIIAEoAlIFc2NvcmUSFgoGc3RhdHVzGAkgASgFUg'
    'ZzdGF0dXMSLgoSc3RhcnRlZFJlYWRpbmdEYXRlGAogASgDUhJzdGFydGVkUmVhZGluZ0RhdGUS'
    'MAoTZmluaXNoZWRSZWFkaW5nRGF0ZRgLIAEoA1ITZmluaXNoZWRSZWFkaW5nRGF0ZRIYCgdwcm'
    'l2YXRlGAwgASgIUgdwcml2YXRlEhgKB21lZGlhSWQYZCABKANSB21lZGlhSWQ=');
