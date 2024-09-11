from pymongo import MongoClient
from bson.objectid import ObjectId
import datetime
import re
import json
import os


class MongodbLibrary():
    ROBOT_LIBRARY_SCOPE = 'TEST'
    ROBOT_LIBRARY_VERSION = '1.0.0'

    def __init__(self):
        """
        Initializes _dbconnection to None.
        """
        self._dbconnection = None

    ### Connecting ###
    def connect_to_mongodb(self, dbHost='localhost', dbPort=27017, dbMaxPoolSize=10, dbNetworkTimeout=None):
        """
        Loads pymongo and connects to the MongoDB host using parameters submitted.

        Example usage:
        | # To connect to localhost MongoDB service on port 27017 |
        | Connect To MongoDB | localhost | ${27017} |
        | # Or for an authenticated connection |
        | Connect To MongoDB | admin:passlocalhost | ${27017} |
        """
        self._dbconnection = MongoClient(host=dbHost, port=dbPort, maxPoolSize=dbMaxPoolSize,
                             socketTimeoutMS=dbNetworkTimeout)

    def disconnect_from_mongodb(self):
        """
        Disconnects from the MongoDB server.

        For example:
        | Disconnect From MongoDB | # disconnects from current connection to the MongoDB server |
        """
        self._dbconnection.close()

    ### Get ###
    def get_mongodb_database(self):
        """
        Returns a list of all of the databases currently on the MongoDB
        server you are connected to.

        Usage is:
        | @{allDBs} | Get Mongodb Databases |
        | Log Many | @{allDBs} |
        | Should Contain | ${allDBs} | DBName |
        """
        allDBs = self._dbconnection.list_database_names()
        return allDBs

    def get_mongodb_collections(self, dbName: str):
        """
        Returns a list of all of the collections for the database you
        passed in on the connected MongoDB server.

        Usage is:
        | @{allCollections} | Get MongoDB Collections | DBName |
        | Log Many | @{allCollections} |
        | Should Contain | ${allCollections} | CollName |
        """
        dbName = str(dbName)
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        allCollections = db.list_collection_names()
        return allCollections

    def get_mongodb_collection_count(self, dbName: str, dbCollName: str):
        """
        Returns the number records for the collection specified.

        Usage is:
        | ${allResults} | Get MongoDB Collection Count | DBName | CollectionName |
        | Log | ${allResults} |
        """
        dbName = str(dbName)
        dbCollName = str(dbCollName)
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % dbCollName]
        count = coll.estimated_document_count()
        return count

    ### Drop ###
    def drop_mongodb_database(self, dbDelName: str):
        """
        Deletes the database passed in from the MongoDB server if it exists.
        If the database does not exist, no errors are thrown.

        Usage is:
        | Drop MongoDB Database | myDB |
        | @{allDBs} | Get MongoDB Collections | myDB |
        | Should Not Contain | ${allDBs} | myDB |
        """
        dbDelName = str(dbDelName)
        try:
            self._dbconnection.drop_database('%s' % dbDelName)
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")

    def drop_mongodb_collection(self, dbName: str, dbCollName: str):
        """
        Deletes the named collection passed in from the database named.
        If the collection does not exist, no errors are thrown.

        Usage is:
        | Drop MongoDB Collection | myDB | CollectionName |
        | @{allCollections} | Get MongoDB Collections | myDB |
        | Should Not Contain | ${allCollections} | CollectionName |
        """
        dbName = str(dbName)
        dbCollName = str(dbCollName)
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        db.drop_collection('%s' % dbCollName)

    ### Create ###
    def create_mongodb_database_collection(self, dbCreateName: str,  dbCollName: str):
        """
        Create new database and collection
        If the database exists, only the collection will be created.
        And if the database does not exist, both the database and the collection will be created.

        Usage in:
        | Create Mongodb Database Collection | myDB | NewCollectionsName |
        | @{allCollections} | Get MongoDB Collections | myDB |
        | Should Contain | ${allCollections} | NewCollectionsName |
        of
        | Create Mongodb Database Collection | newDatabase | NewCollectionsName |
        | @{allDBs} | Get MongoDB Database
        | Should Contain | ${allDBs} | newDatabase |
        | @{allCollections} | Get MongoDB Collections | newDatabase |
        | Should Contain | ${allCollections} | NewCollectionsName |
        """
        dbCreateName = str(dbCreateName)
        db = self._dbconnection[dbCreateName]
        db.create_collection('%s' % dbCollName)

    ### Save ###
    def insert_mongodb_one_record(self, dbName: str, dbCollName: str, insertJSON: str):
        """
        Insert new record in Database name and Collection name specified.
        And support datetime format field in updateJSON by 'datetime()'.

        | ${allResults} | Insert Mongodb One Record | DBName | CollectionName | JSON |

        Enter a new record usage is:
        | ${date}       | Get Current Date
        | ${field_json} | Create Dictionary | name=test_name1 | lastname=test_lastname | createDate=datetime(${date})
        | ${allResults} | Insert Mongodb One Record | DBName | CollectionName | ${field_json} |
        | Log | ${allResults} |

        Update an existing record usage is:
        | ${field_json} | Create Dictionary | _id=4dacab2d52dfbd26f1000000
        | ${allResults} | Insert Mongodb One Record | DBName | CollectionName | ${field_json} |
        | Log | ${allResults} |
        """
        dbName = str(dbName)
        dbCollName = str(dbCollName)

        _, ext = os.path.splitext(insertJSON)
        if ext.lower() == ".json":
            raise TypeError("Json file is not support.")
        try:
            insert_json = json.loads(insertJSON)
        except json.JSONDecodeError:
            insertJSON = insertJSON.replace("'", "\"")
            insert_json = json.loads(insertJSON)
        self._check_json_field_format_datetime(insert_json)

        if '_id' in insert_json:
            insert_json['_id'] = ObjectId(insert_json['_id'])
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % dbCollName]
        allResults = coll.insert_one(insert_json)      # allResults = coll.save(queryJSON)
        return allResults

    def update_many_mongodb_records(self, dbName: str, dbCollName: str, queryJSON: str, updateJSON: str, upsert=False):
        """
        Update many MongoDB records at ones based on the given query string and
        return number of modified documents.
        And support datetime format field in updateJSON by 'datetime()'.

        Usage is:
        | ${query_json}  | Create Dictionary | order=Order001 |
        | ${update_json} | Create Dictionary | name=test_name1 |
        | &{allResults} | Update Many Mongodb Records | DBName | CollectionName | ${query_json} | ${update_json} |
        | Log | ${allResults} |
        or
        | ${query_json}  | Create Dictionary | order=Order002 |
        | ${date}        | Get Current Date
        | ${update_json} | Create Dictionary | createDate=datetime(${date}) |
        | &{allResults} | Update Many Mongodb Records | DBName | CollectionName | ${query_json} | ${update_json} |
        | Log | ${allResults} |
        """
        db_name = str(dbName)
        collection_name = str(dbCollName)

        _, ext_query_json = os.path.splitext(queryJSON)
        if ext_query_json.lower() == ".json":
            raise TypeError("Json file is not support.")
        try:
            query_json = json.loads(queryJSON)
        except json.JSONDecodeError:
            queryJSON = queryJSON.replace("'", "\"")
            query_json = json.loads(queryJSON)
        self._check_json_field_format_datetime(query_json)

        _, ext_update_json = os.path.splitext(updateJSON)
        if ext_update_json.lower() == ".json":
            raise TypeError("Json file is not support.")
        try:
            update_json = json.loads(updateJSON)
        except json.JSONDecodeError:
            updateJSON = updateJSON.replace("'", "\"")
            update_json = json.loads(updateJSON)
        self._check_json_field_format_datetime(update_json)
        update_json = {"$set": update_json}

        if '_id' in query_json:
            query_json['_id'] = ObjectId(query_json['_id'])
        try:
            db = self._dbconnection['%s' % (db_name,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % collection_name]
        allResults = coll.update_many(query_json, update_json, upsert=upsert)
        return allResults.modified_count

    def _check_json_field_format_datetime(self, json_data: json):
        # check format datetime '%Y-%m-%d %H:%M:%S.%f'
        for field in json_data:
            value = json_data[field]
            value_str = str(value)
            if value_str.startswith("datetime"):
                pattern = r'datetime\((.+)\)'
                match = re.search(pattern, value)
                datetime_str = match.group(1)
                datetime_format = '%Y-%m-%d %H:%M:%S.%f'
                json_data[field] = datetime.datetime.strptime(datetime_str, datetime_format)

    ### Retrieve ###
    def retrieve_mongodb_records(self, dbName: str, dbCollName: str, jsonQuery={}, fields=[]):
        """
        Retrieve Some or All of the records in a give MongoDB database collection.
        Support jsonQuery is null and fields is null (optional for filter record and select only fields)
        Return list object result.

        Usage is:
        | ${allResults} | Retrieve Mongodb Records | DBName | CollectionName |
        | Log | ${allResults} |
        or
        | ${query_json}    | Create Dictionary | order=Order002 |
        | ${select_fields} | Create List       | name | lastname | details
        | ${allResults}    | Retrieve Mongodb Records | DBName | CollectionName | ${query_json} | ${select_fields}
        """
        dbName = str(dbName)
        dbCollName = str(dbCollName)
        if isinstance(jsonQuery, str):
            _, ext_query_json = os.path.splitext(jsonQuery)
            if ext_query_json.lower() == ".json":
                raise TypeError("Json file is not support.")
            try:
                criteria = json.loads(jsonQuery)
            except json.JSONDecodeError:
                print(jsonQuery)
                jsonQuery = jsonQuery.replace("'", "\"")
                criteria = json.loads(jsonQuery)
        else:
            criteria = jsonQuery

        if '_id' in criteria:
            criteria['_id'] = ObjectId(criteria['_id'])
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % dbCollName]
        if fields:
            specific_fields = {}
            for field in fields:
                specific_fields[field] = 1
            results = coll.find(criteria, specific_fields)
        else:
            results = coll.find(criteria)
        return list(results)

    ### Remove ###
    def remove_mongodb_records(self, dbName: str, dbCollName: str, jsonQuery: str):
        """
        Remove some of the records from a given MongoDB database collection
        based on the JSON entered.

        Usage is:
        | ${json_query} | Create Dictionary      | _id=4dacab2d52dfbd26f1000000
        | ${allResults} | Remove MongoDB Records | DBName | CollectionName | ${json_query} |
        | Log | ${allResults} |
        | ${output} | Retrieve Mongodb Records | DBName | CollectionName |
        | Should Not Contain | ${output} | '4dacab2d52dfbd26f1000000' |
        or
        | ${json_query} | Create Dictionary      | field=value
        | ${allResults} | Remove MongoDB Records | DBName | CollectionName | ${json_query} |
        | Log | ${allResults} |
        | ${output} | Retrieve Mongodb Records | DBName | CollectionName |
        | Should Not Contain | ${output} | 'value' |
        """
        dbName = str(dbName)
        dbCollName = str(dbCollName)
        _, ext_query_json = os.path.splitext(jsonQuery)
        if ext_query_json.lower() == ".json":
            raise TypeError("Json file is not support.")
        try:
            json_query = json.loads(jsonQuery)
        except json.JSONDecodeError:
            jsonQuery = jsonQuery.replace("'", "\"")
            json_query = json.loads(jsonQuery)
        if '_id' in json_query:
            json_query['_id'] = ObjectId(json_query['_id'])
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            raise TypeError("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % dbCollName]
        allResults = coll.delete_many(json_query)        # allResults = coll.remove(json_query)
        return allResults
