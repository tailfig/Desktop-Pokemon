t(input){
	global tstrings
	if(tstrings[input]){
		return tstrings[input]
	}
	return input
}

menu(wparam,lparam,msg,hwnd){
	global shift
	coordmode menu,screen
	getcurrent(a,hwnd)
	aid:=a.id
	if(getkeystate("shift")){
		n:=random(1,3)
		text:=t("secretclose" n)
		menu tray%aid%,rename,% t("close_pokemon"),%text%
		shift:=1
	}
	x:=lparam&65535
	y:=(lparam>>16)&65535
	menu tray%aid%,show,%x%,%y%
	if(shift){
		menu tray%aid%,rename,%text%,% t("close_pokemon")
		shift:=0
	}
}

contextmenu(byref a){
	global speedmenu
	addmore:=0
	aid:=a.id
	menu tray%aid%,add,% t("add_pokemon"),addeevee
	menu tray%aid%,add
	loop % a.eeveesmenu.length(){
		name:=a.eeveesmenu[a_index]
		if(a.eevees[name].more){
			menu more%aid%,add,% a.eevees[name].name,appearance
			if(!addmore){
				menu tray%aid%,add,% t("more_dropdown"),:more%aid%
				addmore:=1
			}
		}else{
			menu tray%aid%,add,% a.eevees[name].name,appearance
		}
	}
	menu tray%aid%,add
	menu tray%aid%,add,% t("size_larger"),larger
	menu tray%aid%,add,% t("size_smaller"),smaller
	menu tray%aid%,add
	loop % speedmenu.length(){
		menu speed%aid%,add,% speedmenu[speedmenu.length()-a_index+1][1],setspeed
	}
	menu tray%aid%,add,% t("speed_dropdown"),:speed%aid%
	menu tray%aid%,add,% t("stop_running_around"),sit
	if(a.sitstate){
		menu tray%aid%,check,% t("stop_running_around")
	}
	menu tray%aid%,add,% t("close_pokemon"),closeeevee
}

appearance(b:=0,c:=0,d:=0,byref a:=0,thismenu:=0,noconfig:=0){
	global defaulteeveesmenu
	if(!a){
		tray:=substr(a_thismenu,1,4)
		getcurrent(a,a_thismenu,tray)
		loop % a.eeveesmenu.length(){
			thismenu:=a.eevees[a.eeveesmenu[a_index]]
			if(a_thismenuitem=thismenu.name){
				break
			}
		}
	}
	if(a){
		aid:=a.id
		if(a.appearance){
			trayaid:=a.appearance.trayaid
			menu %trayaid%,uncheck,% a.appearance.name
		}else{
			a.appearance:={}
		}
		if(thismenu.more){
			trayaid:="more" aid
		}else{
			trayaid:="tray" aid
		}
		a.appearance:={trayaid:trayaid,name:thismenu.name}
		if(thismenu.custom){
			a.eevee:=loadfromfile(thismenu.id)
		}else{
			a.eevee:=loadimage(thismenu.id)
		}
		menu %trayaid%,check,% thismenu.name
		a.mode:=thismenu.mode
		a.dragging:=0
		if(!noconfig){
			a.updateconfig:=1
		}
	}
}

larger(b:=0,c:=0,d:=0,byref a:=0){
	if(a||getcurrent(a,a_thismenu,"tray")){
		if(a.zoomcurrent<a.zoommodes.length()){
			a.changezoom:=1
			a.updateconfig:=1
		}
		a.dragging:=0
	}
}
smaller(b:=0,c:=0,d:=0,byref a:=0){
	if(a||getcurrent(a,a_thismenu,"tray")){
		if(a.zoomcurrent>1){
			a.changezoom:=-1
			a.updateconfig:=1
		}
		a.dragging:=0
	}
}
setspeed(b:=0,c:=0,d:=0,byref a:=0,thismenu:=0){
	global speedmenu
	if(!a){
		thismenu:=a_thismenuitem
		getcurrent(a,a_thismenu,"speed")
	}
	if(a){
		aid:=a.id
		loop % speedmenu.length(){
			if(speedmenu[a_index][1]=thismenu){
				menu speed%aid%,check,% thismenu
				a.speedms:=speedmenu[a_index][2]
			}else{
				menu speed%aid%,uncheck,% speedmenu[a_index][1]
			}
		}
	}
}
sit(){
	if(getcurrent(a,a_thismenu,"tray")){
		menu % "tray" a.id,togglecheck,% t("stop_running_around")
		a.sitstate:=!a.sitstate
		a.dragging:=0
	}
}

getcurrent(byref a,hwnd:=0,menu:=0){
	global alleevees
	if(!hwnd){
		hwnd:=winexist("a")
	}
	if(hwnd){
		loop % alleevees.length(){
			if(menu&&hwnd=menu alleevees[a_index].id||hwnd=alleevees[a_index].hwnd){
				a:=alleevees[a_index]
				return 1
			}
		}
	}
}

closeeevee(b:=0,c:=0,d:=0,byref a:=0){
	global alleevees,shift
	if(a){
		thismenu:="tray" a.id
	}else if(shift){
		n:=random(1,3)
		text:=t("secretclose_msg" n)
		msgbox 262404,% t("sercetclose_title"),% text
		if(a_msgboxresult="Yes"){
			exitapp
		}else if(a_msgboxresult=""){
			ifmsgbox yes
				exitapp
		}
		return
	}else{
		thismenu:=a_thismenu
	}
	loop % alleevees.length(){
		aid:=alleevees[a_index].id
		if(a_thismenu="tray" aid){
			gui %aid%:destroy
			alleevees.removeat(a_index)
			break
		}
	}
	if(!alleevees.length()){
		exitapp
	}
}