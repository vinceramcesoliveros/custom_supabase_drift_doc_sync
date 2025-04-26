// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_info_schema.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetSyncInfoCollection on Isar {
  IsarCollection<int, SyncInfo> get syncInfos => this.collection();
}

const SyncInfoSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SyncInfo',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'lastPulledAt',
        type: IsarType.dateTime,
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, SyncInfo>(
    serialize: serializeSyncInfo,
    deserialize: deserializeSyncInfo,
    deserializeProperty: deserializeSyncInfoProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeSyncInfo(IsarWriter writer, SyncInfo object) {
  IsarCore.writeLong(
      writer,
      1,
      object.lastPulledAt?.toUtc().microsecondsSinceEpoch ??
          -9223372036854775808);
  return object.id;
}

@isarProtected
SyncInfo deserializeSyncInfo(IsarReader reader) {
  final int _id;
  _id = IsarCore.readId(reader);
  final DateTime? _lastPulledAt;
  {
    final value = IsarCore.readLong(reader, 1);
    if (value == -9223372036854775808) {
      _lastPulledAt = null;
    } else {
      _lastPulledAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final object = SyncInfo(
    id: _id,
    lastPulledAt: _lastPulledAt,
  );
  return object;
}

@isarProtected
dynamic deserializeSyncInfoProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      {
        final value = IsarCore.readLong(reader, 1);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _SyncInfoUpdate {
  bool call({
    required int id,
    DateTime? lastPulledAt,
  });
}

class _SyncInfoUpdateImpl implements _SyncInfoUpdate {
  const _SyncInfoUpdateImpl(this.collection);

  final IsarCollection<int, SyncInfo> collection;

  @override
  bool call({
    required int id,
    Object? lastPulledAt = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (lastPulledAt != ignore) 1: lastPulledAt as DateTime?,
        }) >
        0;
  }
}

sealed class _SyncInfoUpdateAll {
  int call({
    required List<int> id,
    DateTime? lastPulledAt,
  });
}

class _SyncInfoUpdateAllImpl implements _SyncInfoUpdateAll {
  const _SyncInfoUpdateAllImpl(this.collection);

  final IsarCollection<int, SyncInfo> collection;

  @override
  int call({
    required List<int> id,
    Object? lastPulledAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (lastPulledAt != ignore) 1: lastPulledAt as DateTime?,
    });
  }
}

extension SyncInfoUpdate on IsarCollection<int, SyncInfo> {
  _SyncInfoUpdate get update => _SyncInfoUpdateImpl(this);

  _SyncInfoUpdateAll get updateAll => _SyncInfoUpdateAllImpl(this);
}

sealed class _SyncInfoQueryUpdate {
  int call({
    DateTime? lastPulledAt,
  });
}

class _SyncInfoQueryUpdateImpl implements _SyncInfoQueryUpdate {
  const _SyncInfoQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<SyncInfo> query;
  final int? limit;

  @override
  int call({
    Object? lastPulledAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (lastPulledAt != ignore) 1: lastPulledAt as DateTime?,
    });
  }
}

extension SyncInfoQueryUpdate on IsarQuery<SyncInfo> {
  _SyncInfoQueryUpdate get updateFirst =>
      _SyncInfoQueryUpdateImpl(this, limit: 1);

  _SyncInfoQueryUpdate get updateAll => _SyncInfoQueryUpdateImpl(this);
}

class _SyncInfoQueryBuilderUpdateImpl implements _SyncInfoQueryUpdate {
  const _SyncInfoQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<SyncInfo, SyncInfo, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? lastPulledAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (lastPulledAt != ignore) 1: lastPulledAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension SyncInfoQueryBuilderUpdate
    on QueryBuilder<SyncInfo, SyncInfo, QOperations> {
  _SyncInfoQueryUpdate get updateFirst =>
      _SyncInfoQueryBuilderUpdateImpl(this, limit: 1);

  _SyncInfoQueryUpdate get updateAll => _SyncInfoQueryBuilderUpdateImpl(this);
}

extension SyncInfoQueryFilter
    on QueryBuilder<SyncInfo, SyncInfo, QFilterCondition> {
  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> lastPulledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition>
      lastPulledAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> lastPulledAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition>
      lastPulledAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition>
      lastPulledAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> lastPulledAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition>
      lastPulledAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterFilterCondition> lastPulledAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension SyncInfoQueryObject
    on QueryBuilder<SyncInfo, SyncInfo, QFilterCondition> {}

extension SyncInfoQuerySortBy on QueryBuilder<SyncInfo, SyncInfo, QSortBy> {
  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> sortByLastPulledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> sortByLastPulledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }
}

extension SyncInfoQuerySortThenBy
    on QueryBuilder<SyncInfo, SyncInfo, QSortThenBy> {
  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> thenByLastPulledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<SyncInfo, SyncInfo, QAfterSortBy> thenByLastPulledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }
}

extension SyncInfoQueryWhereDistinct
    on QueryBuilder<SyncInfo, SyncInfo, QDistinct> {
  QueryBuilder<SyncInfo, SyncInfo, QAfterDistinct> distinctByLastPulledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }
}

extension SyncInfoQueryProperty1
    on QueryBuilder<SyncInfo, SyncInfo, QProperty> {
  QueryBuilder<SyncInfo, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SyncInfo, DateTime?, QAfterProperty> lastPulledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }
}

extension SyncInfoQueryProperty2<R>
    on QueryBuilder<SyncInfo, R, QAfterProperty> {
  QueryBuilder<SyncInfo, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SyncInfo, (R, DateTime?), QAfterProperty>
      lastPulledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }
}

extension SyncInfoQueryProperty3<R1, R2>
    on QueryBuilder<SyncInfo, (R1, R2), QAfterProperty> {
  QueryBuilder<SyncInfo, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SyncInfo, (R1, R2, DateTime?), QOperations>
      lastPulledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncInfoImpl _$$SyncInfoImplFromJson(Map<String, dynamic> json) =>
    _$SyncInfoImpl(
      id: (json['id'] as num).toInt(),
      lastPulledAt: json['lastPulledAt'] == null
          ? null
          : DateTime.parse(json['lastPulledAt'] as String),
    );

Map<String, dynamic> _$$SyncInfoImplToJson(_$SyncInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lastPulledAt': instance.lastPulledAt?.toIso8601String(),
    };
