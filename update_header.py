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
      while lines[i]) != "\n" and lines[i][0] == '%':
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

