print('input name_prifix minindex maxindex newpre newminindex');
name_pri="remu4_";
print("good!");
minindex=1;
print("good!");
maxindex=15;
print("good!");
newpre="reimu_start_";
print("good!");
newminindex=1;
print("good!");
print("process!");
import os,sys
curDir = os.getcwd()+"\\"
filenames=os.listdir(curDir);
for i in range(minindex,maxindex+1):
    filename=name_pri+str(i)+'.png';
    if os.path.exists(curDir+filename): 
        os.renames(curDir+filename,curDir+newpre+str(newminindex)+'.png');
        newminindex+=1;
print("cmp");

