import urllib
import os
import wget
from bs4 import BeautifulSoup
import yaml

def get_all_file_at_url(tmpUrl, files, must_keywords, select_keywords):
    newdir = []
    try:
        response = urllib.request.urlopen(tmpUrl)
        htmlstr = response.read()
        soup = BeautifulSoup(htmlstr, "html.parser")
        tds = soup.find_all('td')
        for i in range(len(tds)):
            td = tds[i]
            if td.a != None :
                attr = td.a
                href = attr['href']
                if '..' in href:
                    continue
                if (href[-1] == '/'):
                    newdir.append(tmpUrl+href)
                    continue

                # check must key words
                all_key_exist = True
                for word in must_keywords:
                    if (word in tmpUrl+href):
                        continue
                    else:
                        all_key_exist = False
                        break
                if not all_key_exist:
                    continue

                # check sekect key words
                one_key_exist = False
                for word in select_keywords:
                    if (word in tmpUrl+href):
                        one_key_exist = True
                    else:
                        continue
                if one_key_exist:
                    files.append(tmpUrl+href)

        for j in range(len(newdir)):
            get_all_file_at_url(newdir[j], files, must_keywords,select_keywords)

    except urllib.error.URLError as e:
        print("Error:"+str(e))

    return

def get_file_local(filedir, filesUrl):
    # check file location
    if not os.path.exists(filedir):
        os.makedirs(filedir)
    try:        
        fileNames = os.listdir(filedir)
        for i in range(len(filesUrl)):
            fileexist = False
            file_url_name = filesUrl[i].split('/')[4]+"_"+filesUrl[i].split('/')[5]+".sqlite.bz2" 
            for j in range(len(fileNames)):
                if fileNames[j] == file_url_name:
                    fileexist = True
                    break
                else:
                    continue
            if fileexist:
                continue
            else: 
                print("\nBegin to download file:" + file_url_name)
                wget.download(filesUrl[i], filedir+file_url_name)
        os.system("bzip2 -d "+ filedir + "*.bz2")
    except:
        print("Error while list files in the dir.") 
    return

def write_dbcfg_file(cfgfile, files):

    db_version = "openEuer_20.03_LTS"
    arch = "_x86"
    bin_db_files = "bin_db_files"
    src_db_files0 = ["src_db_file_0", "src_db_file_1"]
    src_db_files1 = ["src_db_file_0_1", "src_db_file_1_1"]
    stat = "enable"
    priority = 1

    item = [
        {
            "db_name" : db_version + arch,
            "src_db_file" : src_db_files0,
            "bin_db_file" : bin_db_files,
            "status" : stat,
            "priority" : priority
        },
        {
            "db_name" : db_version + "_aarch",
            "src_db_file" : src_db_files1,
            "bin_db_file" : bin_db_files,
            "status" : stat,
            "priority" : priority
        }
        ]
    with open(cfgfile, "w", encoding="utf-8") as f:
        yaml.dump(item, f) 

    return

def main():
    url = "https://repo.openeuler.org/"
    localdir = "./dbfiles/"
    must_keywords = ["primary.sqlite."]
    select_keywords = ["everything", "source"]
    cfgfile = "init_db.yaml"
    files = []
    filesUrl = []
    get_all_file_at_url(url, files, must_keywords, select_keywords)
    for strr in files:
        print(strr)

    get_file_local(localdir, files)

    write_dbcfg_file(cfgfile, files)
        
    return

if __name__ == '__main__':
    main()

