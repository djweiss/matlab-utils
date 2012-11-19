# ======================================================================
# Copyright (c) 2012 David Weiss
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ======================================================================

import os
import re
import sys

def writeheader(filename,header,skip=None):
    """
    write a header to filename, 
    skip files where first line after optional shebang matches the skip regex
    filename should be the name of the file to write to
    header should be a list of strings
    skip should be a regex
    """
    f = open(filename,"r")
    lines =f.readlines()
    f.close()

    result = re.match('^function.*', lines[0])
    if result != None:
      output = list()
      output.append(lines[0])

      i = 1
      while lines[i] != "\n" and lines[i][0] == '%':
        output.append(lines[i])
        i += 1

      while lines[i] == "\n":
        i += 1
      
      print i, lines[i]

      j = i
      licstart = j
      result = re.match('^% =.*', lines[j])
      if result != None:
        j += 1
        result = re.match('^% =.*', lines[j])
        while j < len(lines) and (result == None):
          result = re.match('^% =.*', lines[j])
          j += 1
          
      licend = j

      i = j
      print (licstart, licend)
      
      output.append("\n")

      for l in header:
        output.append("% " + l)

      output.append("\n")

      while i < len(lines):
        output.append(lines[i])
        i += 1

      return output

    return None

if __name__ == '__main__':
  if len(sys.argv) == 1:
    print "usage: %s <license.txt> <src.m>" % sys.argv[0]
    sys.exit(1)

  f = open(sys.argv[1], "r")
  lic = f.readlines()
  f.close()

  output = writeheader(sys.argv[2], lic)
  if output != None:
    f = open(sys.argv[2], "w")
    for l in output:
      f.write(l)
    f.close()
    print "updated header for %s" % sys.argv[2]

