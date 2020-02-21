from os import path, mkdir

class File():
    def __init__(self, path):
        assert(isinstance(path,str))
        self.path = path

    def to_DXF(self, foldername = 'DXFs'):
        #print(os.split(self.path))

        name = self.path.replace('\\','/').split('/')
        name[-1] = name[-1].replace('png', 'dxf')
        name[-2] = foldername

        folder = '/'.join(name[:-1])
        if not path.isdir(folder):
            mkdir(folder)

        return DXF_File('/'.join(name))
