from os import path, mkdir

class File():
    def __init__(self, path):
        assert(isinstance(path,str))
        self.path = path
