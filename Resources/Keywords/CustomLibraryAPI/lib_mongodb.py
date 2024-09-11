from pymongo import MongoClient
from robot.api.deco import keyword

class lib_mongodb:
    def __init__(self, uri=None, database=None, collection=None):
        self.client = None
        self.database = None
        self.collection = None
        if uri and database and collection:
            self.connect_to_mongodb(uri, database, collection)

    @keyword("Connect MongoDB")
    def connect_to_mongodb(self, uri, database, collection):
        self.client = MongoClient(uri, tls=True, tlsAllowInvalidCertificates=True)
        self.database = self.client[database]
        self.collection = self.database[collection]
        return (
            f"Connected to MongoDB at {uri}\n"
            f"Database: {database}\n"
            f"Collection: {collection}"
        )
    
    @keyword("Disconnect MongoDB")
    def disconnect_from_mongodb(self):
        if self.client is not None:
            self.client.close()
            self.client = None
            self.database = None
            self.collection = None
            return "Disconnected from MongoDB"
        else:
            return "No active connection to MongoDB"

    @keyword("Insert MongoDB")
    def insert_document(self, document):
        if self.collection is None:
            raise Exception("Collection is not set")
        return list(self.collection.insert_one(document))
        
    @keyword("Query MongoDB")
    def get_documents(self, query={}):
        if self.collection is None:
            raise Exception("Collection is not set")
        return list(self.collection.find(query))

    @keyword("Update MongoDB")
    def update_document(self, query, update):
        if self.collection is None:
            raise Exception("Collection is not set")
        return list(self.collection.update_one(query, {"$set": update}))

    @keyword("Delete MongoDB")
    def delete_document(self, query={}):
        if self.collection is None:
            raise Exception("Collection is not set")
        return list(self.collection.delete_one(query))