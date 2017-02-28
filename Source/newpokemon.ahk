newpokemon(args:=0,force:=0){
	global id,alleevees,defaulteevees,defaulteeveesmenu,modenames,zoomnames,speedmenu
	if(alleevees.length()>=99){
		return
	}
	a:={}
	alleevees.push(a)
	a.id:="eevee" id
	id++
	a.eevees:=defaulteevees.clone()
	a.eeveesmenu:=defaulteeveesmenu.clone()
	a.zoomcurrent:=5
	a.speed:=2
	a.mode:=modenames[1]
	a.filename:=[]
	if(!args){
		args:=[]
	}
	skipnext:=0
	skipnum:=0
	skipsize:=0
	loop % args.length(){
		if(skipnext){
			skipnext:=0
			continue
		}
		arg:=strlower(args[a_index])
		nextarg:=strlower(args[a_index+1])
		firstsymbol:=substr(arg,1,1)
		if(firstsymbol="/"||firstsymbol="-"){
			argname:=substr(arg,2)
			if(argname="sit"){
				a.sitstate:=1
			}else if(argname="speed"){
				loop % speedmenu.length(){
					if(strlower(strreplace(speedmenu[a_index][1],"&"))=nextarg){
						a.speed:=a_index
						break
					}
				}
				skipnext:=1
			}else if(argname="mode"){
				loop % modenames.length(){
					if(modenames[a_index]=nextarg){
						a.mode:=nextarg
						break
					}
				}
				skipnext:=1
			}else if(argname="fork"){
				skipnext:=1
			}
		}else{
			if(arg="random"||a.eevees[arg]){
				if(!skipnum){
					a.loadnum:=arg
					skipnum:=1
				}
			}else if(zoomnames[arg]){
				if(!skipsize){
					a.zoomcurrent:=zoomnames[arg]
					skipsize:=1
				}
			}else{
				a.filename.push(args[a_index])
			}
		}
	}
	
	allpngs:={}
	loop files,%a_scriptdir%\*.png
	{
		loop % modenames.length(){
			modename:=modenames[a_index]
			if(substr(a_loopfilename,1,strlen(modename))=modename){
				if(!allpngs[modename]){
					allpngs[modename]:=[]
				}
				allpngs[modename].push(a_loopfilename)
				break
			}
		}
	}
	loop % modenames.length(){
		i:=modenames.length()-a_index+1
		modename:=modenames[i]
		if(allpngs[modename]){
			thismode:=allpngs[modename]
			loop % thismode.length(){
				j:=thismode.length()-a_index+1
				a.eevees[thismode[j]]
					:={name:thismode[j]
					,mode:modenames[i]
					,id:thismode[j]
					,custom:1}
				a.eeveesmenu.insertat(1,thismode[j])
			}
		}
	}
	loop % a.filename.length(){
		thisfile:=a.filename[a_index]
		if(fileexist(thisfile)){
			shortname:=regexreplace(thisfile,".*[\\/]","")
			a.eevees[shortname]
				:={name:shortname
				,mode:a.mode
				,id:thisfile
				,custom:1}
			a.eeveesmenu.insertat(1,shortname)
		}
	}
	if(a.loadnum="random"){
		a.eeveenum:=a.eeveesmenu[random(1,a.eeveesmenu.length())]
	}else if(a.loadnum){
		a.eeveenum:=a.eevees[a.loadnum].id
	}
	addmore:=0
	aid:=a.id
	contextmenu(a)
	if(a.loadnum){
		appearance(,,,a,a.eevees[a.eeveenum],1)
	}else{
		appearance(,,,a,a.eevees[a.eeveesmenu[1]],1)
	}
	config(a,1)
	a.timer:=a_tickcount
	if(!force){
		checkprocess()
	}
	gui %aid%:show,% "na x" a.winx " y" a.winy " w" a.winwidth " h" a.winheight,Desktop Pokemon
	setspeed(,,,a,speedmenu[a.speed][1])
}