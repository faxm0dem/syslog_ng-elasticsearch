#!/usr/bin/python

from datetime import datetime
from elasticsearch import Elasticsearch

def init():
    global es
    es = Elasticsearch(['localhost:9200'])
    print "This is the init function."

def deinit():
    print "This is the deinit function."

def queue(message):
    res = es.index(index="test", doc_type="test", body=message)

