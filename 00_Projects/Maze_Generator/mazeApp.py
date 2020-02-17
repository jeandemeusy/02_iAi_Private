from tkinter import *
import json, argparse, os
import time

import numpy as np
import scipy.misc, glob

class mazeApp(Tk):
    def __init__(self, parent, argv):
        Tk.__init__(self, parent)
        self.parent = parent

        parser = argparse.ArgumentParser()
        parser.add_argument("--config", help="JSON configuration filename.")
        self.readConfigfile(parser.parse_args().config)

        self.divs = self.findDivisors(self.set["size"]//2)

        self.sqSize = self.divs[len(self.divs)//2]
        self.sqNum = self.set["size"]//self.sqSize
        self.autoSave = BooleanVar()
        self.mazeGenerated = False

        w = self.set["size"] + 2*self.set["off"] + 100
        h = self.set["size"] + 2*self.set["off"] + 20
        x = (self.winfo_screenwidth() - w) / 2
        y = (self.winfo_screenheight() - h) / 2
        self.geometry('%dx%d+%d+%d' % (w, h, x, y))
        self.initialize()

    def readConfigfile(self, configFile):
        try:
            with open(configFile) as json_data_file:
                self.set = json.load(json_data_file)
        except:
            raise Exception('Unable to find ' + configFile)
        else:
            path = self.set["generatedMazesDir"]
            if os.path.exists(path) == False:
                try:                os.makedirs(path)
                except OSError:     print("Creation of %s failed" % path)
                else:               print("Sucessfully created %s" % path)

    def initialize(self):
        self.resizable(False,False)
        self.initializeDrawWindow()
        self.drawArea.place(x=self.set["off"], y=self.set["off"])

        self.status = Label(self, text="Ready", bd=1, relief=SUNKEN, anchor=W)
        self.status.pack(side=BOTTOM, fill=X)

        self.addButton(self, 0, 1, 90, 30,  "Clear", self.clearMaze)
        self.addButton(self, 0, 2, 90, 30, "Create", self.generateMaze)
        self.minusButton = self.addButton(self, 0, 3, 29, 30, '-', self.minusSize)
        self.addButton(self, 1, 3, 29, 30, '•', self.midSize)
        self.plusButton  = self.addButton(self, 2, 3, 29, 30, '+', self.plusSize)
        self.solveButton = self.addButton(self, 0, 5, 90, 30,  "Solve", self.solveMaze)
        self.addButton(self, 0, 7, 90, 30,   "Auto", self.autoSave, check=1)
        self.addButton(self, 0, 8, 90, 30,   "Save", self.saveMaze)

        self.solveButton.config(state="disabled", relief=RIDGE)

    def initializeDrawWindow(self):
        self.rect = [None]*self.sqSize**2
        self.drawArea = Canvas(self.parent, bg=self.set["pathColor"],
                               width=self.set["size"]-1, height=self.set["size"]-1)
        self.drawArea.bind(   "<Motion>", self.mouseMove)
        self.drawArea.bind("<B1-Motion>", self.mousePaint)
        self.drawArea.bind("<B3-Motion>", self.mouseErase)
        self.drawArea.bind( "<Button-1>", self.mousePaint)
        self.drawArea.bind( "<Button-3>", self.mouseErase)
        self.drawContours()

    def drawContours(self):
        for i in range(0,self.sqSize):
            indexL = i
            indexU = self.sqSize*i
            indexD = self.sqSize*i+self.sqSize-1
            indexR = self.sqSize*(self.sqSize-1)+i

            self.addElementAtIndex(indexL, "wall")
            self.addElementAtIndex(indexU, "wall")
            self.addElementAtIndex(indexD, "wall")
            self.addElementAtIndex(indexR, "wall")
        self.mazeGenerated = False

    def addButton(self, parent, x, y, w, h, title, command, check=0):
        if check:   button = Checkbutton(self, text="Auto save", var=command)
        else:       button = Button(parent, text=title, command=command)

        x = x * 30 + 2 * self.set["off"] + self.set["size"]
        y = y * 30 + 1 * self.set["off"]
        button.place(x=x, y=y, width=w, height=h)

        return button

    def minusSize(self):
        idx = self.divs.index(self.sqSize)
        if idx > 0:
            for i in range(0,self.sqSize**2):
                self.removeElementAtIndex(i)

            self.sqSize = self.divs[idx-1]
            self.sqNum = self.set["size"]//self.sqSize
            self.rect = [None]*self.sqSize**2
            self.status.config(text="Maze size decreased.")
            self.drawContours()

        if idx==1:    self.minusButton.config(state="disabled", relief=RIDGE)
        else:       self.minusButton.config(state="normal", relief=RAISED)
        self.plusButton.config(state="normal", relief=RAISED)
        print(self.sqSize)

    def midSize(self):
        idx = len(self.divs)//2
        if self.divs[idx] != self.sqSize:
            for i in range(0,self.sqSize**2):
                self.removeElementAtIndex(i)

            self.sqSize = self.divs[idx]
            self.sqNum = self.set["size"]//self.sqSize
            self.rect = [None]*self.sqSize**2
            self.status.config(text="Maze size set to default.")
            self.drawContours()

        self.minusButton.config(state="normal", relief=RAISED)
        self.plusButton.config(state="normal", relief=RAISED)
        print(self.sqSize)

    def plusSize(self):
        idx = self.divs.index(self.sqSize)
        if idx+1 < len(self.divs):
            for i in range(0,self.sqSize**2):
                self.removeElementAtIndex(i)

            self.sqSize = self.divs[idx+1]
            self.sqNum = self.set["size"]//self.sqSize
            self.rect = [None]*self.sqSize**2
            self.status.config(text="Maze size increased.")
            self.drawContours()

        if idx==len(self.divs)-2:    self.plusButton.config(state="disabled", relief=RIDGE)
        else:                   self.plusButton.config(state="normal", relief=RAISED)
        self.minusButton.config(state="normal", relief=RAISED)
        print(self.sqSize)

    def findDivisors(self,value):
        i = 2
        divs = []
        while i < (value+1)//2:
            if value % i == 0:
               divs.append(i)
            i += 1
        divs.append(value)
        return divs




#     # ####### #     #  #####  #######     ####### #     # #######  #####
##   ## #     # #     # #     # #           #       #     #    #    #     #
# # # # #     # #     # #       #           #       #     #    #    #
#  #  # #     # #     #  #####  #####       #####   #     #    #     #####
#     # #     # #     #       # #           #        #   #     #          #
#     # #     # #     # #     # #           #         # #      #    #     #
#     # #######  #####   #####  #######     #######    #       #     #####

    def mouseMove(self,event):
        x = event.x//self.sqNum
        y = event.y//self.sqNum
        self.status.config(text="Cursor at x=" + str(x) + " y=" + str(y)+'.')

    def mousePaint(self, event):
        if self.isInCanvas(event.x,event.y):
            index = event.x//self.sqNum * self.sqSize + event.y//self.sqNum

            if self.rect[index] == None:
                self.addElementAtIndex(index, "draw")
                self.status.config(text="Walls added.")

    def mouseErase(self, event):
        if self.isInCanvas(event.x,event.y):
            index = event.x//self.sqNum * self.sqSize + event.y//self.sqNum

            self.removeElementAtIndex(index)




#     #    #    ####### #######     ####### ####### #######  #####
##   ##   # #        #  #           #       #          #    #     #
# # # #  #   #      #   #           #       #          #    #
#  #  # #     #    #    #####       ####    #          #     #####
#     # #######   #     #           #       #          #          #
#     # #     #  #      #           #       #          #    #     #
#     # #     # ####### #######     #       #######    #     #####

    def clearMaze(self):
        for i in range(0,self.sqSize**2):
            self.removeElementAtIndex(i)
        self.drawContours()
        supText = ""
        if self.set["size"] % self.sqSize:
            supText = "Non-integer cell's number. Errors may occur !"
        self.status.config(text="Maze refreshed."+' '+supText)
        self.solveButton.config(state="disabled", relief=RIDGE)

    def convertMaze(self):
        img = np.empty((self.sqSize**2, 3))
        for i in range(0, self.sqSize**2):
            try:
                col = self.drawArea.itemcget(self.rect[i],"fill")
            except:
                col = self.set["pathColor"]
            img[i,:] = [int(col[1:3], 16),int(col[3:5], 16),int(col[5:7], 16)]

        img = img.reshape((self.sqSize, self.sqSize,3))
        self.maze = img[:,:,0].T

        return np.transpose(img,(1,0,2))

    def saveMaze(self):
        img = self.convertMaze()
        highestNumber = -1

        files = glob.glob(self.set["generatedMazesDir"]+"*.png")
        for i in range(0,len(files)):
            numWithExt = files[i].split("maze")[-1]
            fileNumber = int(numWithExt.split('.')[0])
            if fileNumber > highestNumber:
                highestNumber = fileNumber

        fileName = "maze" + str(highestNumber+1).zfill(3) + ".png"
        path = self.set["generatedMazesDir"]+fileName
        scipy.misc.imsave(path, img.astype(np.uint8))
        self.status.config(text="Maze saved as " + path + ".")

    def solveMaze(self):
        if self.mazeGenerated:
            self.convertMaze()

            x0, y0 = 0, np.where(self.maze[0,:]==int(self.set["pathColor"][1:3],16))[0]
            x1, y1 = self.sqSize-1, np.where(self.maze[-1,:]==int(self.set["pathColor"][1:3],16))[0]

            self.iterations = 0
            self.recursiveSolver(x0, y0, x1, y1)

            path = self.correctPath.T
            path = path.reshape((self.sqSize**2,1))

            for i in range(0,self.sqSize**2):
                if path[i]==1:
                    self.addElementAtIndex(i, "draw")

            self.status.config(text="Maze solved in " + str(self.iterations) + " iterations.")

            self.solveButton.config(state="disabled", relief=RIDGE)
            self.mazeGenerated = False
        else:
            self.status.config(text="Maze not ready to be solved.")

    def recursiveSolver(self,x0,y0,x1,y1):
        self.iterations += 1

        if (x0 == x1) and (y0 == y1):
            self.correctPath[x0,y0]=1
            return 1
        if self.maze[x0,y0] == int(self.set["wallColor"][1:3],16) or self.wasHere[x0,y0]:
            return 0

        self.wasHere[x0,y0] = 1
        if x0 != self.sqSize-1:
            if self.recursiveSolver(x0+1,y0,x1,y1):
                self.correctPath[x0,y0] = 1
                return 1
        if x0 != 0:
            if self.recursiveSolver(x0-1,y0,x1,y1):
                self.correctPath[x0,y0] = 1
                return 1
        if y0 != self.sqSize-1:
            if self.recursiveSolver(x0,y0+1,x1,y1):
                self.correctPath[x0,y0] = 1
                return 1
        if y0 != 0:
            if self.recursiveSolver(x0,y0-1,x1,y1):
                self.correctPath[x0,y0] = 1
                return 1
        return 0

    def generateMaze(self):
        for i in range(0,self.sqSize**2):
            self.removeElementAtIndex(i)

        self.wasHere = np.zeros((self.sqSize,self.sqSize))
        self.correctPath = np.zeros((self.sqSize,self.sqSize))

        maze = np.tile([[1, 2], [2, 0]], (self.sqSize//2, self.sqSize//2))
        maze = maze[:-1,:-1]
        cells = {(i, j): (i, j) for i, j in np.argwhere(maze == 1)}
        walls = np.argwhere(maze == 2)

        def find(p, q):
            if p != cells[p] or q != cells[q]:
                cells[p], cells[q] = find(cells[p], cells[q])
            return cells[p], cells[q]

        np.random.shuffle(walls)
        for i, j in walls:
            if i % 2: p, q = find((i - 1, j), (i + 1, j))
            else:     p, q = find((i, j - 1), (i, j + 1))
            maze[i, j] = (p != q)
            if maze[i, j]: cells[p] = q

        linMaze = np.zeros((self.sqSize,self.sqSize))
        linMaze[1:self.sqSize-1,1:self.sqSize-1] = maze

        linMaze[np.random.choice(np.where(linMaze[:, 1])[0]), 0] = 2
        linMaze[np.random.choice(np.where(linMaze[:,-2])[0]),-1] = 2
        linMaze = linMaze.reshape((self.sqSize**2,1))

        for i in range(0,self.sqSize**2):
            if   linMaze[i]==0 :    self.addElementAtIndex(i, "wall")
            elif linMaze[i]==2 :    self.addElementAtIndex(i, "path")

        self.mazeGenerated = True
        self.status.config(text="New random maze generated.")
        self.solveButton.config(state="normal", relief=RAISED)

        if self.autoSave.get():
            self.saveMaze()

    def addElementAtIndex(self, index, type="wall"):
        x = (index//self.sqSize)*self.sqNum+1
        y = (index %self.sqSize)*self.sqNum+1

        self.removeElementAtIndex(index)
        self.rect[index] = self.createSquare(x, y, type)

    def removeElementAtIndex(self, index):
        if self.rect[index] != None:
            self.drawArea.delete(self.rect[index])
            self.rect[index] = None

    def createSquare(self, x, y, type):
        a = x + self.sqNum-1
        b = y + self.sqNum-1
        clr = self.set[type+"Color"]

        return self.drawArea.create_rectangle(x, y, a, b, fill=clr, outline=clr)

    def isInCanvas(self,x,y):
        condition1 = (x < self.set["size"]-self.sqNum-1)
        condition2 = (y < self.set["size"]-self.sqNum-1)
        condition3 = (x > self.sqNum)
        condition4 = (y > self.sqNum)

        return (condition1 and condition2 and condition3 and condition4)
