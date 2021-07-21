# NProgressbar | nprogressbar_native 

Install:

#method1:
client_script "@nprogressbar_native/progressbar.lua"
CreateProgress(...)

#method2:
exports.nprogressbar_native:CreateProgress(...)

#method3:
TriggerEvent('CreateProgress',...)


functions:
```
CreateProgress(duration,text,cb,font,p1,p2,transparent,color1,color2,color3) 
```
duration (number): the time progress remain    
text (string): background text  
cb (function): callback function  
font (string): custom font or default font "$Font2"  
p1,p2 (string/number): "L","B" / "L","T" / "C","C" / "C","B" / "C","T" / "R","T" / "R","B" or 0.35,0.45  
transparent (number):  opacity value of colors  0.0~1.0
color1 (table): color of value bar  
color2 (table): color of trough bar/background   
color3 (table): textcolor {255,0,123} or {255,0,0,120}  


