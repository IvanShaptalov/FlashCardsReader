// # import 'tables.py'datetime
// # import 'tables.py'uuid

// # import 'tables.py'jwt
// # from icecream import 'tables.py'ic
// # from sqlalchemy import 'tables.py'Column, String, BigInteger, ForeignKey, DateTime, Float, Integer, Boolean
// # from sqlalchemy.orm import 'tables.py'relationship

// # from config import 'tables.py'config, enums
// # from . import 'tables.py'db_methods
// # from .core import 'tables.py'Base
// # from .db_methods import 'tables.py'get_from_db_multiple_filter, write_obj_to_table, delete_obj_from_table


// # # region tables

// # class UahExchangeRate1(Base):
// #     __tablename__ = 'uah_exchange_rate1'

// #     uid = Column('uid', String, unique=True, primary_key=True, index=True)
// #     title = Column('title', String, unique=False)
// #     rate = Column('rate', Float, unique=False)
// #     cc = Column('cc', String, unique=False)
// #     en_title = Column('en_title', String, unique=False)
// #     units = Column('units', String, unique=False)
// #     rate_per_unit = Column('rate_per_unit', String, unique=False)
// #     group = Column('group', String, unique=False)
// #     exchange_date = Column('exchange_date', DateTime, unique=False)
// #     calc_date = Column('calc_date', DateTime, unique=False)

// #     attrs_to_save = ('uid',
// #                      'title',
// #                      'rate',
// #                      'cc',
// #                      'en_title',
// #                      'units',
// #                      'rate_per_unit',
// #                      'group',
// #                      'exchange_date',
// #                      'calc_date')

// #     def __str__(self):
// #         return '{}{}{}'.format(self.title,
// #                                self.rate,
// #                                self.cc)


// # class UONIAOvernigh2(Base):
// #     __tablename__ = 'uonia_overnight2'

// #     uid = Column('uid', String, unique=True, primary_key=True, index=True)
// #     dt = Column('dt', String, unique=False)
// #     rate = Column('rate', Float, unique=False)
// #     id_api = Column('id_api', Float, unique=False)
// #     cc = Column('cc', String, unique=False)

// #     attrs_to_save = ('uid',
// #                      'dt',
// #                      'rate',
// #                      'id_api',
// #                      'cc')

// #     def __str__(self):
// #         return '{}{}'.format(self.id_api,
// #                              self.value)


// # class UONIA3(Base):
// #     __tablename__ = 'uonia3'

// #     uid = Column('uid', String, unique=True, primary_key=True, index=True)
// #     dt = Column('dt', String, unique=False)
// #     rate = Column('rate', Float, unique=False)
// #     id_api = Column('id_api', Float, unique=False)
// #     cc = Column('cc', String, unique=False)

// #     attrs_to_save = ('uid',
// #                      'dt',
// #                      'rate',
// #                      'id_api',
// #                      'cc')

// #     def __str__(self):
// #         return '{}{}'.format(self.id_api,
// #                              self.value)


// # class APIKeys(Base):
// #     __tablename__ = 'api_keys'

// #     id = Column('id', String, unique=True, primary_key=True, index=True)
// #     key = Column('key', String, unique=False)
// #     permissions = Column('permissions', String, unique=False)

// #     attrs_to_save = ('id',
// #                      'key',
// #                      'permissions')

// #     @property
// #     def is_sudo(self):
// #         return self.permissions == enums.ApiKeyPermissions.SUDO.value

// #     @staticmethod
// #     def get_from_db(open_session, id=None, all_objects=False):
// #         if all_objects:
// #             return db_methods.get_from_db_multiple_filter(table_class=APIKeys,
// #                                                           all_objects=True,
// #                                                           open_session=open_session)
// #         result_api_key = db_methods.get_from_db_multiple_filter(table_class=APIKeys,
// #                                                                 identifier_to_value=[
// #                                                                     APIKeys.id == id],
// #                                                                 open_session=open_session)

// #         return result_api_key

// #     def to_dict(self):
// #         result = {}
// #         for attr in self.attrs_to_save:
// #             result[attr] = self.__getattribute__(attr)
// #         return result

// #     def _create_token(self):
// #         token_live = config.JW_TOKEN_MINUTES_LIVE
// #         expired = datetime.datetime.utcnow() + datetime.timedelta(minutes=token_live)

// #         token = jwt.encode({'public_id': self.id, 'perm': self.permissions, 'exp': expired},
// #                            config.SECRET_KEY, algorithm="HS256")

// #         return token

// #     def decode_token(self):
// #         payload = jwt.decode(self.key, config.SECRET_KEY, algorithms=["HS256"])
// #         return payload

// #     def save(self, open_session):
// #         api_key = get_from_db_multiple_filter(self.__class__,
// #                                               identifier_to_value=[
// #                                                   self.__class__.id == self.id],
// #                                               open_session=open_session)

// #         self.key = self._create_token()

// #         write_obj_to_table(open_session=open_session,
// #                            table_class=self.__class__,
// #                            identifier_to_value=[
// #                                self.__class__.id == self.id] if api_key is None else None,
// #                            **self.to_dict())

// #         return self.key

// #     def delete(self, open_session):
// #         try:
// #             return delete_obj_from_table(open_session=open_session,
// #                                          table_class=self.__class__,
// #                                          identifier_to_value=[self.__class__.id == self.id])
// #         except Exception as e:
// #             print(e)
// #             return False

// #     def __str__(self):
// #         return f'{self.key}'


// # # endregion


// # def create_tables(c_engine):
// #     Base.metadata.create_all(bind=c_engine)
// #     ic('tables created')
// #     return True


// # def drop_tables(c_engine):
// #     Base.metadata.drop_all(bind=c_engine)
// #     ic('tables deleted')
// #     return True
