# coding:utf-8

import sys
import io
import os
import time

from flask import Flask
from datetime import timedelta

sys.path.append(os.getcwd() + "/class/core")
sys.setdefaultencoding('utf-8')
import db
import public


class config:
    __version = '0.0.1'
    __app = None

    def __init__(self):
        pass

    def makeApp(self, name):
        app = Flask(name)
        app.debug = True

        app.config.version = self.__version + str(time.time())
        app.config['SECRET_KEY'] = os.urandom(24)
        app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=7)
        __app = app

        self.initDB()
        return app

    def initDB(self):
        try:
            sql = db.Sql().dbfile('default')
            csql = public.readFile('data/sql/default.sql')
            csql_list = csql.split(';')
            for index in range(len(csql_list)):
                sql.execute(csql_list[index], ())
        except Exception, ex:
            print str(ex)

    def getVersion(self):
        return self.__version

    def getApp(self):
        return self.__app
