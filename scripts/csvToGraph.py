import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import sys



def drawGraph(folder,query,subplots):
    plt.subplot(subplots)
    plt.minorticks_on()
    plt.grid(axis='x')
    plt.grid(which='minor',axis='x',linestyle=':',linewidth=0.4)
    files = os.listdir(folder+'/'+query)
    files.sort()
    load=[0.0]*len(files)
    preprocess=[0.0]*len(files)
    chase=[0.0]*len(files)
    execute=[0.0]*len(files)
    total=[0.0]*len(files)
    rewrite=[0.0]*len(files)
    convert=[0.0]*len(files)
    gqr=[0.0]*len(files)
    tuples=[0.0]*len(files)
    print(files)
    index=0
    for fileName in files:
     	thereException=bool(False)
        try:
            file = pd.read_csv(folder+'/'+query+'/'+fileName)
            print("-----------------Before------------------------")
            print(file.to_string())
#             file.fillna(-1, inplace = True)
           #  print("---------------------After--------------------")
#             print(file.to_string())
            print("-----------------------------------------")
            if 'loading' in file:
                if (fileName == 'RDFox.csv' or fileName == 'rdfoxLong.csv'):
                    try:
                        if(file['loading'].min() != -1):
                            load[index]=file['loading'].mean()
                            x1 = float(file['loading'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['loading'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in loading times in " + folder+'/'+query+'/'+fileName)
                else:
                    try:
                        if(file['loading'].min() != -1):
                            load[index]=file['loading'].mean()/1000000
                            x1 = float(file['loading'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['loading'].min() == -1):
                        	thereException=bool(True)   
                    except:
                        print("Errors in loading times in " + folder+'/'+query+'/'+fileName)

            if 'preprocess' in file:
                try:
                    if(file['preprocess'].min() != -1):
                      	preprocess[index]=file['preprocess'].mean()/1000000
                      	x1 = float(file['preprocess'].min())
                        if(pd.isna(x1)):
                        	thereException=bool(True)
                    elif(file['preprocess'].min() == -1):
                    	thereException=bool(True)
                except:
                    print("Errors in preprocess times in " + folder+'/'+query+'/'+fileName)
            if 'chase' in file:
                if (fileName == 'RDFox.csv' or fileName == 'rdfoxLong.csv'):
                    try:
                        if(file['chase'].min() != -1):
                        	chase[index]=file['chase'].mean()
                        	x1 = float(file['chase'].min())
                        	if(pd.isna(x1)):
                        		thereException=bool(True)
                    	elif(file['chase'].min() == -1):
                    		thereException=bool(True)
                    except:
                        print("Errors in preprocess times in " + folder+'/'+query+'/'+fileName)        
                else:
                    try:
                        if(file['chase'].min() != -1):
                            chase[index]=file['chase'].mean()/1000000
                            x1 = float(file['chase'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['chase'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in preprocess times in " + folder+'/'+query+'/'+fileName)       
            if 'execute' in file:
                if (fileName == 'RDFox.csv' or fileName == 'rdfoxLong.csv'):
                    try:
                        if(file['execute'].min() != -1):
                            execute[index]=file['execute'].mean()
                            x1 = float(file['execute'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['execute'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in execute times in " + folder+'/'+query+'/'+fileName)
                else:
                    try:
                        if(file['execute'].min() != -1):
                            execute[index]=file['execute'].mean()/1000000
                            x1 = float(file['execute'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['execute'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in execute times in " + folder+'/'+query+'/'+fileName)            
            if 'rewrite' in file:
                try:
                    if(file['rewrite'].min() != -1):
                        rewrite[index]=file['rewrite'].mean()/1000000
                        x1 = float(file['rewrite'].min())
                        if(pd.isna(x1)):
                        	thereException=bool(True)
                    elif(file['rewrite'].min() == -1):
                    	thereException=bool(True)
                except:
                    print("Errors in rewrite times in " + folder+'/'+query+'/'+fileName) 
            if 'tuples' in file:
                try:
                    if(file['tuples'].min() != -1):
                        tuples[index]=file['tuples'].mean()/1000000
                        x1 = float(file['tuples'].min())
                        if(pd.isna(x1)):
                        	thereException=bool(True)
                    elif(file['tuples'].min() == -1):
                    	thereException=bool(True)
                except:
                    print("Errors in tuples in " + folder+'/'+query+'/'+fileName)       
            if 'convert' in file:
            	if (fileName == 'gqr.csv'):
                    try:
                        if(file['convert'].min() != -1):
                            convert[index]=file['convert'].mean()
                            x1 = float(file['convert'].min())
                            if(pd.isna(x1)):
                            	thereException=bool(True)
                        elif(file['convert'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in rewrite times in " + folder+'/'+query+'/'+fileName)
                else:
                    try:
                        if(file['convert'].min() != -1):
                             convert[index]=file['convert'].mean()/1000000    
                             x1 = float(file['convert'].min())
                             if(pd.isna(x1)):
                             	thereException=bool(True)
                        elif(file['convert'].min() == -1):
                        	thereException=bool(True)
                    except:
                        print("Errors in loading times in " + folder+'/'+query+'/'+fileName)
 
            if 'gqr' in file:
                try:
                    if(file['gqr'].min() != -1):
                        gqr[index]=file['gqr'].mean()/1000000
                        x1 = float(file['convert'].min())
                        if(pd.isna(x1)):
                        	thereException=bool(True)
                    elif(file['convert'].min() == -1):
                    	thereException=bool(True)
                except:
                    print("Errors in gqr times in " + folder+'/'+query+'/'+fileName)        
            
            print('There is ', thereException)
            if(thereException):
            	print("Yes")
            	load[index]=0
            	preprocess[index]=0
            	chase[index]=0
            	execute[index]=0
            	rewrite[index]=0
            	convert[index]=0
            	gqr[index]=0
            index=index+1
        except:
            print(folder+'/'+query)
    print(folder+'/'+query)   
    print('loading', load)
    print('preprocesss',preprocess)
    print('chase',chase)
    print('execute',execute)
    print('rewrite',rewrite)
    print('convert',convert)
    print('gqr',gqr)

    size=np.arange(len(preprocess))
    width = 0.35

    loads=plt.barh(size,load,width)
    preprocesss=plt.barh(size,preprocess,width,left=load)
    chases=plt.barh(size,chase,width,left=np.array(load)+np.array(preprocess))
    rewrites=plt.barh(size, rewrite, width,left=np.array(load)+np.array(preprocess)+np.array(chase))
    gqrs=plt.barh(size,gqr,width,left=np.array(load)+np.array(preprocess)+np.array(chase)+np.array(rewrite))
    converts=plt.barh(size,convert , width,left=np.array(load)+np.array(preprocess)+np.array(chase)+np.array(rewrite)+np.array(gqr))
    executes=plt.barh(size,execute,width,left=np.array(load)+np.array(preprocess)+np.array(chase)+np.array(rewrite)+np.array(convert)+np.array(gqr))
    plt.title(query)
    files = [f.replace('chasestepper.csv', 'BCA.csv') for f in files]
    ticks = map(lambda x: x.split('.')[0],files)
    print(ticks)
    plt.yticks(size,ticks)
    if subplots % 10 == 1:
#           plt.legend((loads[0],rewrites[0],chases[0],executes[0],converts[0]), ['Load','Rewrite','Chase','Execute','LAVrewrite'], loc=7, bbox_to_anchor=(1.1, 0.5))
          plt.legend((loads[0],rewrites[0],chases[0],executes[0],converts[0]), ['Load','Rewrite','Chase','Execute','Convert'], loc=7, bbox_to_anchor=(1.1, 0.5))
#     	  plt.legend((loads[0],rewrites[0],preprocesss[0],chases[0],executes[0],converts[0]), ['Load','Rewrite','Preprocess','Chase','Execute','Convert'], loc=7, bbox_to_anchor=(1.1, 0.5))
#         plt.legend((loads[0],rewrites[0],chases[0],executes[0],converts[0]), ['Load','Rewrite','Chase','Execute','Convert'], loc=7, bbox_to_anchor=(1.1, 0.5))
#         plt.legend((loads[0],rewrites[0],chases[0],executes[0],converts[0]), ['Load','Rewrite','Chase','Execute','Convert'], loc=7, bbox_to_anchor=(1.1, 0.5))

if len(sys.argv) > 1:
    folder=sys.argv[1]
    queries =os.listdir(folder)
    queries.sort()
    subplots=len(queries)*100 + 11
    for query in queries:
        if query.startswith('Q'):
            drawGraph(folder,query,subplots)
            subplots = subplots + 1
    plt.xlabel('Time (milliseconds)')
    plt.subplots_adjust(left=0.08,bottom=0.1,top=0.95,right=0.9,wspace=0.04,hspace=0.5)   
    fig = plt.gcf()
    fig.set_size_inches(25.5, 15.5)
    plt.savefig(folder+".png",orientation='landscape',format='png')
else:
    print("No folder included")