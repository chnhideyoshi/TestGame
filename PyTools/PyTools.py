import os;
import sys, shutil, os, string 
sourcepath="F:\\workspacecsharp\\RecentProject\\CocosStudioTest\\res"
targetpath="F:\\workspacecsharp\\Lab\\TestGame\\Resources";
#if os.path.exists(targetpath):  
#    os.remove(targetpath);
for filename in os.listdir(sourcepath):
    if ".csb" in filename:
        fullname=sourcepath+"\\"+filename;
        fulltarget=targetpath+"\\"+filename;
        shutil.copy(fullname,fulltarget) 



    