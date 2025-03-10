import os
import uuid

DEBUG = False
TESTING = False
SECRET_KEY = str(uuid.uuid4())
USERNAME = str(uuid.uuid4())
PASSWORD = str(uuid.uuid4())

NAME = 'datapusher'

# database
SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/job_store.db'

# webserver host and port
HOST = '0.0.0.0'
PORT = 8000

# logging
STDERR = True

# Content length settings
CHUNK_SIZE = int(os.environ.get('DATAPUSHER_CHUNK_SIZE', '16384'))
CHUNK_INSERT_ROWS = int(os.environ.get('DATAPUSHER_CHUNK_INSERT_ROWS', '250'))
DOWNLOAD_TIMEOUT = int(os.environ.get('DATAPUSHER_DOWNLOAD_TIMEOUT', '30'))
MAX_CONTENT_LENGTH = int(os.environ.get('DATAPUSHER_MAX_CONTENT_LENGTH', '1024000'))

# Verify SSL
SSL_VERIFY = os.environ.get('DATAPUSHER_SSL_VERIFY', False)

# Rewrite resource URL's when ckan callback url base is used
REWRITE_RESOURCES = os.environ.get('DATAPUSHER_REWRITE_RESOURCES', False)
REWRITE_URL = os.environ.get('DATAPUSHER_REWRITE_URL', 'http://ckan:5000/')
