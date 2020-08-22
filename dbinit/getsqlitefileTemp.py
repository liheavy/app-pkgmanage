import os
import sys 

def main():
    if len(sys.argv) != 3:
        print("Need two parameter: 1.sqlite file url; 2.database local directory.")
        print(str(sys.argv))
        return
    for i in sys.argv:
        print(i)
    
    url = sys.argv[1]
    localdir = sys.argv[2]
    os.system("wget " + url + " -q -r -np -nd -A .sqlite")
    os.system("mkdir " + localdir)
    os.system("cp -f *.sqlite " + localdir)
    return


if __name__ == '__main__':
    main()

