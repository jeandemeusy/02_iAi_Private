function [numOUT] = map(numIN,minIN,maxIN,minOUT,maxOUT)

numOUT = (numIN - minIN) * (maxOUT - minOUT) / (maxIN - minIN) + minOUT;