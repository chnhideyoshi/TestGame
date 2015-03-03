print('input name_prifix minindex maxindex newpre newminindex');
#0
name_pri="nima (";
name_suf=").png";
print("good!");
minindex=0;
print("good!");
maxindex=48;
print("good!");
newpre="sk2_";
print("good!");
newminindex=1;
print("good!");
print("process!");
import os,sys
curDir = os.getcwd()+"\\"
filenames=os.listdir(curDir);
for i in range(minindex,maxindex+1):
    filename=name_pri+str(i)+name_suf;
    if os.path.exists(curDir+filename): 
        os.renames(curDir+filename,curDir+newpre+str(newminindex)+'.png');
        newminindex+=1;
print("cmp");

