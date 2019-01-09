import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    """ Flask config-object
    """
    DEBUG = os.environ.get('DEBUG', False)
    TESTING = os.environ.get('TESTING', False)

    HOST = os.environ.get('HOST', '127.0.0.1')
    PORT = os.environ.get('PORT', 5000)

    SECRET_KEY = os.environ.get('SECRET_KEY',
                                '51f52814-0071-11e6-a247-000ec6c2372c')
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL', 'sqlite:///' + os.path.join(basedir, 'db.sqlite'))
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    REQUEST_STATS_WINDOW = 15
    CELERY_CONFIG = {}
    SOCKETIO_MESSAGE_QUEUE = os.environ.get(
        'SOCKETIO_MESSAGE_QUEUE', os.environ.get('CELERY_BROKER_URL',
                                                 'redis://'))


class DevelopmentConfig(Config):
    """ flack devel-config
    """
    DEBUG = True


class ProductionConfig(Config):
    """ flack Production-config
    """
    pass


class TestingConfig(Config):
    """ flack Testing-config
    """
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite://'
    CELERY_CONFIG = {'CELERY_ALWAYS_EAGER': True}
    SOCKETIO_MESSAGE_QUEUE = None


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig
}
