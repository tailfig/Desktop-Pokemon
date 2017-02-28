#notrayicon
#singleinstance off
#maxhotkeysperinterval 99000000
#hotkeyinterval 99000000
#keyhistory 0
listlines off
setbatchlines -1
setwindelay -1

initial()
defaulteevees:={}
defaulteeveesmenu:=[]
loop % initialconfig.length(){
	defaulteevees[initialconfig[a_index].id]:=initialconfig[a_index]
	defaulteeveesmenu.push(initialconfig[a_index].id)
}
for name,dest in aliases{
	defaulteevees[name]:=defaulteevees[dest]
}
gdip_startup()
id:=0
if(!a_args){
	a_args:=[]
	loop %0%{
		a_args.push(%a_index%)
	}
}
alleevees:=[]
loadedimg:={}
thispid:=dllcall("GetCurrentProcessId")
checkprocess()
pokemonargs(a_args)
onmessage(513,"drag")
onmessage(274,"close")
onmessage(123,"menu")
onmessage(74,"addeevee")
settimer update,50

return

#include ..\Build\initial.ahk
#include newpokemon.ahk
#include animation.ahk
#include config.ahk

#include parseargs.ahk
#include windowevent.ahk
#include contextmenu.ahk
#include singleprocess.ahk

#include loadimage.ahk
#include compatibility.ahk
#include ..\Libs\gdip.ahk