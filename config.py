class Config:
    SECRET_KEY = "supersecretkey"
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://root:root@localhost/fittrack"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
