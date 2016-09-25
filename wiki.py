# -*- coding: utf-8 -*-
"""
Created on Sun Sep 25 00:48:46 2016

@author: Michal.Kot
"""
import requests
import re

dzielnice=[
'Bemowo'
,'Białołęka'
,'Bielany'
,'Mokotów'
,'Ochota'
,'Praga-Północ'
,'Praga-Południe'
,'Rembertów'
,'Śródmieście'
,'Targówek'
,'Ursus'
,'Ursynów'
,'Wawer'
,'Wesoła'
,'Wilanów'
,'Włochy'
,'Wola'
,'Żoliborz'
]

fOut='C:/Users/michal.kot/Documents/MBS_Hackathon/wikiImgAll.csv'
dataDict=dict()

def getImgLink(zId):
            fileName=dataDict[zId]
            reqImg='https://commons.wikimedia.org/w/api.php?action=query&titles=File:' + fileName + '&prop=imageinfo&&iiprop=url&iiurlwidth=220&format=json'
            resImg=requests.get(reqImg)
            imgUrl=re.findall(re.compile('"thumburl":"(https:.*).*\","t'), resImg.text)[0]
            return imgUrl

with open(fOut, 'w') as fOut:
    for d in dzielnice:
        reqAddress='https://pl.wikipedia.org/wiki/Wikipedia:Wiki_Lubi_Zabytki/mazowieckie/Warszawa/' + d + '?action=raw'
        res = requests.get(reqAddress)
        res = res.text
        
        data = re.findall(re.compile('((id|zdj.+?)+?) *= *(.*)\n',re.MULTILINE), res)
        dataDict=dict((data[x][2],data[x+1][2])for x in range(0,len(data)-1,2))
        
        for key in dataDict:
            print(key + ' ' + dataDict[key])
            if key!='' and dataDict[key]!='':
                url=getImgLink(key)
                outStr=key + ',' + url + '\n'
                fOut.write(outStr)
        
    