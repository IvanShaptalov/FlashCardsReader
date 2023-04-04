// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcards.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetFlashCardCollectionCollection on Isar {
  IsarCollection<FlashCardCollection> get flashCardCollections =>
      this.collection();
}

const FlashCardCollectionSchema = CollectionSchema(
  name: r'FlashCardCollection',
  id: -3438873001137511263,
  properties: {
    r'flashCards': PropertySchema(
      id: 0,
      name: r'flashCards',
      type: IsarType.objectList,
      target: r'FlashCard',
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _flashCardCollectionEstimateSize,
  serialize: _flashCardCollectionSerialize,
  deserialize: _flashCardCollectionDeserialize,
  deserializeProp: _flashCardCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'FlashCard': FlashCardSchema},
  getId: _flashCardCollectionGetId,
  getLinks: _flashCardCollectionGetLinks,
  attach: _flashCardCollectionAttach,
  version: '3.0.5',
);

int _flashCardCollectionEstimateSize(
  FlashCardCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.flashCards;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[FlashCard]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              FlashCardSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _flashCardCollectionSerialize(
  FlashCardCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<FlashCard>(
    offsets[0],
    allOffsets,
    FlashCardSchema.serialize,
    object.flashCards,
  );
  writer.writeLong(offsets[1], object.hashCode);
  writer.writeString(offsets[2], object.title);
}

FlashCardCollection _flashCardCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FlashCardCollection(
    flashCards: reader.readObjectList<FlashCard>(
      offsets[0],
      FlashCardSchema.deserialize,
      allOffsets,
      FlashCard(),
    ),
    title: reader.readStringOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _flashCardCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<FlashCard>(
        offset,
        FlashCardSchema.deserialize,
        allOffsets,
        FlashCard(),
      )) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _flashCardCollectionGetId(FlashCardCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _flashCardCollectionGetLinks(
    FlashCardCollection object) {
  return [];
}

void _flashCardCollectionAttach(
    IsarCollection<dynamic> col, Id id, FlashCardCollection object) {
  object.id = id;
}

extension FlashCardCollectionQueryWhereSort
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QWhere> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhere>
      anyTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'title'),
      );
    });
  }
}

extension FlashCardCollectionQueryWhere
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QWhereClause> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [null],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleEqualTo(String? title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleNotEqualTo(String? title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleGreaterThan(
    String? title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [title],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleLessThan(
    String? title, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [],
        upper: [title],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleBetween(
    String? lowerTitle,
    String? upperTitle, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [lowerTitle],
        includeLower: includeLower,
        upper: [upperTitle],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleStartsWith(String TitlePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'title',
        lower: [TitlePrefix],
        upper: ['$TitlePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [''],
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterWhereClause>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'title',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'title',
              upper: [''],
            ));
      }
    });
  }
}

extension FlashCardCollectionQueryFilter on QueryBuilder<FlashCardCollection,
    FlashCardCollection, QFilterCondition> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'flashCards',
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'flashCards',
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'flashCards',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension FlashCardCollectionQueryObject on QueryBuilder<FlashCardCollection,
    FlashCardCollection, QFilterCondition> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterFilterCondition>
      flashCardsElement(FilterQuery<FlashCard> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'flashCards');
    });
  }
}

extension FlashCardCollectionQueryLinks on QueryBuilder<FlashCardCollection,
    FlashCardCollection, QFilterCondition> {}

extension FlashCardCollectionQuerySortBy
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QSortBy> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension FlashCardCollectionQuerySortThenBy
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QSortThenBy> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension FlashCardCollectionQueryWhereDistinct
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QDistinct> {
  QueryBuilder<FlashCardCollection, FlashCardCollection, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<FlashCardCollection, FlashCardCollection, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension FlashCardCollectionQueryProperty
    on QueryBuilder<FlashCardCollection, FlashCardCollection, QQueryProperty> {
  QueryBuilder<FlashCardCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FlashCardCollection, List<FlashCard>?, QQueryOperations>
      flashCardsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flashCards');
    });
  }

  QueryBuilder<FlashCardCollection, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<FlashCardCollection, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const FlashCardSchema = Schema(
  name: r'FlashCard',
  id: 2394645075128407362,
  properties: {
    r'answerWords': PropertySchema(
      id: 0,
      name: r'answerWords',
      type: IsarType.string,
    ),
    r'fromLanguage': PropertySchema(
      id: 1,
      name: r'fromLanguage',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'questionWords': PropertySchema(
      id: 3,
      name: r'questionWords',
      type: IsarType.string,
    ),
    r'toLanguage': PropertySchema(
      id: 4,
      name: r'toLanguage',
      type: IsarType.string,
    )
  },
  estimateSize: _flashCardEstimateSize,
  serialize: _flashCardSerialize,
  deserialize: _flashCardDeserialize,
  deserializeProp: _flashCardDeserializeProp,
);

int _flashCardEstimateSize(
  FlashCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.answerWords;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fromLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.questionWords;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.toLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _flashCardSerialize(
  FlashCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.answerWords);
  writer.writeString(offsets[1], object.fromLanguage);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeString(offsets[3], object.questionWords);
  writer.writeString(offsets[4], object.toLanguage);
}

FlashCard _flashCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FlashCard(
    answerWords: reader.readStringOrNull(offsets[0]),
    fromLanguage: reader.readStringOrNull(offsets[1]),
    questionWords: reader.readStringOrNull(offsets[3]),
    toLanguage: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _flashCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FlashCardQueryFilter
    on QueryBuilder<FlashCard, FlashCard, QFilterCondition> {
  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'answerWords',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'answerWords',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'answerWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'answerWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> answerWordsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'answerWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'answerWords',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      answerWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'answerWords',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fromLanguage',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fromLanguage',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> fromLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> fromLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fromLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> fromLanguageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fromLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      fromLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fromLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'questionWords',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'questionWords',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'questionWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'questionWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'questionWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'questionWords',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      questionWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'questionWords',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toLanguage',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      toLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toLanguage',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      toLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      toLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition> toLanguageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      toLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<FlashCard, FlashCard, QAfterFilterCondition>
      toLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toLanguage',
        value: '',
      ));
    });
  }
}

extension FlashCardQueryObject
    on QueryBuilder<FlashCard, FlashCard, QFilterCondition> {}
