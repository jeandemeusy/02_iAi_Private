import sys
from mazeApp import mazeApp

if __name__ == "__main__":
    app = mazeApp(None, sys.argv)
    app.title('Maze Solver')
    app.mainloop()
