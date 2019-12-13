## https://docs.python.org/3/howto/logging-cookbook.html#an-example-dictionary-based-configuration
## https://docs.djangoproject.com/en/1.9/topics/logging/#configuring-logging
logcfg = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(module)s %(process)d %(thread)d %(message)s'
        },
        'simple': {
            # 'format': '%(levelname)s %(message)s'
            'format': '[%(levelname)s]:[%(filename)s:%(lineno)d - %(funcName)20s() ]: %(message)s'
            # 'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        },
        'standard': { 
            # 'format': '%(asctime)s:[%(levelname)s]:%(lineno)d:%(name)s:: %(message)s'
            'format': '%(asctime)s:[%(levelname)s]:[%(name)s]:[%(filename)s:%(lineno)d - %(funcName)20s() ]: %(message)s'
        },
    },
    'filters': {},
    'handlers': {
        'default': {
            'level':'DEBUG',
            'class':'logging.StreamHandler',
        },
        'console':{
            'level':'DEBUG',
            'class':'logging.StreamHandler',
            'formatter': 'standard',
            'stream': 'ext://sys.stdout'
        },
        # 'file_info': {
        #     'class': 'logging.handlers.RotatingFileHandler',
        #     'level': 'DEBUG',
        #     'formatter': 'standard',
        #     'filename': 'log/info.log',
        #     'maxBytes': 10485760,
        #     'backupCount': 20,
        #     'encoding': 'utf8'
        # },
        # 'file_error': {
        #     'class': 'logging.handlers.RotatingFileHandler',
        #     'level': 'ERROR',
        #     'formatter': 'standard',
        #     'filename': 'log/errors.log',
        #     'maxBytes': 10485760,
        #     'backupCount': 20,
        #     'encoding': 'utf8'
        # }
    },
    'loggers':{
        '': {
            'handlers': ['console'],
            'level': 'INFO',
            'propagate': False
        },
        '__main__': {
            'handlers': ['console'],
            # 'level': 'CRITICAL',
            'level': 'ERROR',
            # 'level': 'WARNING',
            # 'level': 'INFO',
            # 'level': 'DEBUG',
            # 'level': 'NOTSET',
            'propagate': False
        }
    }
}
