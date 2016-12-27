#!/usr/bin/python


# TODO:
#
# highlight float numbers properly (int part is broken because of dot)
# twos complement for negative binaries
#
# V dec, hex and bin groups using colors or bold
# V colored prompt and brown backgroud


import sys
import cmd
import re
from math import *


def test():
    print 'test'
    

class Colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    BOLD = '\033[1m'
    NONE = '\033[0m'
    UNDERLINE = '\033[4m'
    CYAN = '\033[36m'
    WHITE = '\033[7m'
    
    def __init__(self):
        self.curCol = self.BOLD
        self.newCol = self.GREEN

    def switchCol(self):
        if self.curCol == self.NONE:
            self.curCol = self.newCol
        else:
            self.curCol = self.NONE
        return self.curCol



def chopStr(strIn, chopSize):
    '''split a string into list of strings; each one is the size of chopSize, e.g.:
        chopStr('example', 3) => ['e', 'xam', 'ple'] '''
    
    parts = []
    for t in range(len(strIn), 0, chopSize * -1):
        f = t - chopSize
        if f < 0:
            f=0        
        parts.insert(0, strIn[f:t])
    return parts
        
        
def highLight(numStr):
    '''highlight groups of digits in a string:
         every 3 digits for decimal, every 4 for bin and hex'''
    
    #split number into base prefix with rjust spaces and numerical value 
    splits = re.split('(^\s*(0x|0b)*)', numStr)
    prefix = splits[1]
    value = splits[3]
    
    #float highlighting is not implemented yet
    if '.' in value:
        return numStr
    
    #set string group size from base prefix
    if prefix.strip()[0:2] in ['0x', '0b']:
        groupSize = 4
    else:
        groupSize = 3

    #split strings into groups and highlight each one
    #groups are reversed to start highlighting from number's end 
    groupsIn = chopStr(value, groupSize)[::-1]
    
    c = Colors()
    groupsOut = [c.switchCol() + p for p in groupsIn][::-1]
    
    hiValue = ''.join(groupsOut)
    
    return prefix + hiValue + c.NONE
    
    
def fmt(num, base=10):
    '''return a formatted string from a number according to its base'''
    
    if num == None:
        return None
    
    if base == 2:
        ret = bin(num)
    elif base == 16:
        ret = hex(num)
    else:
        ret = str(num)
        
    ret = ret.rjust(35)
    ret = highLight(ret)

    return ret

def toFloat(expr):
    return re.sub(r'''(?<![x\d\.])(\d+)(?![x\d\.])''', r'\1.0', expr, re.VERBOSE)

    
class MainCmd(cmd.Cmd):
    resVar = '@'
    resVals = {}


    def setResVar(self):
        '''generate one-letter variable name to hold the result history
            and update the prompt'''
        ascii = ord(self.resVar)
        if ascii == 91:
            ascii = 64
        self.resVar = chr(ascii + 1)
        self.prompt = Colors.GREEN + '\n' + self.resVar + ' = ' + Colors.NONE


    def preloop(self):
        '''cmd module init'''
        cmd.Cmd.preloop(self)
        self.setResVar()


    def do_EOF(self, Line):
        '''exit from shell on Ctrl-D'''
        return True


    def default(self, Line):
        '''calculate both integer and floating results and print floating if it's more \
            precise or integer in dec, hex and bin format'''

        Line = re.sub(r'[ ,]', '', Line)
        orgLine = Line
        
        #replace variable names with result history (resVals dictionary)
        resVars = re.findall(r'''\b[A-Z]\b''', Line)
        if len(resVars) > 0:
            for v in resVars:
                try:
                    Line = re.sub(r'\b' + v + r'\b', self.resVals[v], Line)
                except KeyError:
                    print "Variable", v, 'is empty'
                    return

        #add '0x' to hex digit if not present
        Line = re.sub(r'(\b\d*[a-f]+\d*)', '0x\\1', Line)

        if Line != orgLine:
            print "   ", Line

        #since passing integer numbers to Python produce rounded results
        #we convert all numbers to floating by adding '.0' at the end of each number
        FloatLine = toFloat(Line)

        IntResult = None
        FloatResult = None
        try:
            IntResult = int(eval(Line))
            FloatResult = eval(FloatLine)
        except:
            pass

#        DEBUG PRINT
#         print 'Int:   ', Line, '=', IntResult
#         print 'Float: ', FloatLine, '=', FloatResult

        #both results are invalid: user input error
        if IntResult is None and FloatResult is None:
            print "Can't calculate"
            return

        
        decResult = fmt(IntResult ,10)
        hexResult = fmt(IntResult, 16)
        binResult = fmt(IntResult, 2)
        floResult = fmt(FloatResult, 10)
        
        #only int result valid, e.g. hex calculation
        if IntResult is not None and FloatResult is None:
            print '%s\n%s\n%s' % (decResult, hexResult, binResult)
            self.resVals[self.resVar] = str(IntResult)

        #int invalid and float valid is impossible
        if IntResult is None and FloatResult is not None:
            print 'IntResult', IntResult
            print 'FloatResult', FloatResult
            print 'BUG?'
            return

        #both results are valid: show float if it has a fraction
        if IntResult is not None and FloatResult is not None:
            if IntResult == FloatResult:
                print '%s\n%s\n%s' % (decResult, hexResult, binResult)
                self.resVals[self.resVar] = str(IntResult)
            else:
                print floResult
                self.resVals[self.resVar] = str(FloatResult)

        self.setResVar()


if __name__ == '__main__':
    if 'test' in sys.argv:
        test()
        sys.exit()
    
    MainCmd().cmdloop()















