local a={cache={}}do do local b=function()return{Build={PlaceId=75407502025821,
PlaceVersion=2221},Native={HitboxFolder='Bots',ShotFunction='fireOnce',ArenaZone
='Arena'},Aim={Enabled=true,FovRadius=150,TargetPart='Head',ClosestParts={'Head'
,'UpperTorso','LowerTorso','HumanoidRootPart'},MaxDistance=2000,VisibleCheck=
true,TeamCheck=true,SkipProtected=true,HitChance=100,Kinds={Player=true,Bot=true
}},Esp={Enabled=true,TeamCheck=true,Kinds={Player=true,Bot=true},Boxes=true,
Names=true,Health=true,Distance=true,HeldItem=true,Tracers=false,Skeleton=false,
HideStale=false,StaleSeconds=3,MaxRigDrift=15,MaxDistance=3000,Colors={Player=
Color3.fromRGB(255,70,70),Bot=Color3.fromRGB(255,190,60),Team=Color3.fromRGB(80,
170,255)}},Visuals={ShowFov=true,ShowTargetHighlight=true,FovColor=Color3.
fromRGB(255,255,255),LockedColor=Color3.fromRGB(255,80,80)},Perf={EntityInterval
=0.15,TargetSelectInterval=0.05},Name='Pandemonium',WindowIcon=
'rbxassetid://132509022802512',LoadUi=true,UiSource=
[[https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee]],
RayIgnoreFolders={'ProjectileFX','WeaponFX','ShotFeel','GrappleDebris',
'GrappleStyleDebris','WrapShells','HealthOrbs','BackWeapons','GuardFX',
'StatusEffects','OutlineHighlights','DamageNumbersFx'},PartModes={'Head',
'UpperTorso','HumanoidRootPart','Closest'},Kinds={'Player','Bot'}}end function a
.a()local c=a.cache.a if not c then c={c=b()}a.cache.a=c end return c.c end end
do local b=function()return{Players=game:GetService'Players',RunService=game:
GetService'RunService',UserInputService=game:GetService'UserInputService',
ReplicatedStorage=game:GetService'ReplicatedStorage'}end function a.b()local c=a
.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do local b=
function()local b={Loaded=true,Connections={},Errors={},BuildMismatch=nil,Target
=nil,SelectAt=-math.huge,Stats={Shots=0,Redirected=0,Hits=0,HitsRedirected=0,
HitsNormal=0},LastRedirectAt=-math.huge,Entities={},EntitiesAt=-math.huge,
EntitiesGen=0}function b.connect(c,d)local e=c:Connect(d)table.insert(b.
Connections,e)return e end function b.guarded(c,d)return function(...)local e,f=
xpcall(d,debug.traceback,...)if not e then b.Errors[c]={message=tostring(f),at=
os.clock()}end end end return b end function a.c()local c=a.cache.c if not c
then c={c=b()}a.cache.c=c end return c.c end end do local b=function()local b,c,
d=a.b(),a.a(),a.c()local e=b.Players local f,g,h=e.LocalPlayer,{},function(f,g,h
,i,j)local k=g:FindFirstChildOfClass'Humanoid'if k and g:FindFirstChild
'HumanoidRootPart'then table.insert(f,{model=g,character=g,humanoid=k,kind=h,
label=i,player=j})end end function g.refresh(i)if i-d.EntitiesAt<c.Perf.
EntityInterval then return end d.EntitiesAt=i local j={}for k,l in ipairs(e:
GetPlayers())do if l~=f and l.Character then h(j,l.Character,'Player',l.
DisplayName,l)end end local k=workspace:FindFirstChild(c.Native.HitboxFolder)if
k then for l,m in ipairs(k:GetChildren())do if m:IsA'Model'then local n=m:
GetAttribute'DisplayName'h(j,m,'Bot',type(n)=='string'and n or m.Name)end end
end d.Entities=j d.EntitiesGen=d.EntitiesGen+1 end local i=function(i)if i.
player then return i.player.Team and i.player.Team.Name or nil end local j=i.
model:GetAttribute'Team'return type(j)=='string'and j or nil end function g.
isTeammate(j)local k=f.Team and f.Team.Name return k~=nil and i(j)==k end
function g.alive(j)if j.model.Parent==nil or j.humanoid.Parent~=j.model or j.
humanoid.Health<=0 then return false end local k=j.model:GetAttribute'Zone'
return k==nil or k==c.Native.ArenaZone end function g.fresh()return true end
function g.protected(j)return j.model:FindFirstChildOfClass'ForceField'~=nil end
function g.heldItem(j)local k=j.model:GetAttribute'Weapon'return type(k)==
'string'and k~=''and k or nil end function g.ownerModel(j)local k=j:
FindFirstAncestorOfClass'Model'while k and k.Parent~=workspace and k.Parent~=
workspace:FindFirstChild(c.Native.HitboxFolder)do k=k:FindFirstAncestorOfClass
'Model'end return k end function g.rayParams()local j=RaycastParams.new()j.
FilterType=Enum.RaycastFilterType.Exclude j.IgnoreWater=true local k={workspace.
CurrentCamera}if f.Character then table.insert(k,f.Character)end for l,m in
ipairs(c.RayIgnoreFolders)do local n=workspace:FindFirstChild(m)if n then table.
insert(k,n)end end j.FilterDescendantsInstances=k return j end return g end
function a.d()local c=a.cache.d if not c then c={c=b()}a.cache.d=c end return c.
c end end do local b=function()local b,c,d,e=a.b(),a.a(),a.c(),a.d()local f,g,h,
i,j,k,l=b.UserInputService,workspace.CurrentCamera,{},false,e.rayParams(),(-1)
function h.origin2D()if f.MouseBehavior==Enum.MouseBehavior.LockCenter then
return g.ViewportSize/2 end return f:GetMouseLocation()end local m,n=function(m,
n)local o,p=g:WorldToViewportPoint(m)if not p or o.Z<=0 then return math.huge
end return(Vector2.new(o.X,o.Y)-n).Magnitude end,function(m,n)local o=m:
FindFirstChild(n)return o and o:IsA'BasePart'and o or nil end h.part=n local o,p
,q=function(o,p)if not c.Aim.VisibleCheck then return true end if k~=d.
EntitiesGen then j=e.rayParams()k=d.EntitiesGen end local q=g.CFrame.Position
local r=workspace:Raycast(q,p.Position-q,j)return r==nil or r.Instance:
IsDescendantOf(o.model)end,function(o,p)local q=c.Aim if q.TargetPart~='Closest'
then local r=n(o,q.TargetPart)or n(o,'HumanoidRootPart')return r,r and m(r.
Position,p)or math.huge end local r,s=(math.huge)for t,u in ipairs(q.
ClosestParts)do local v=n(o,u)if v then local w=m(v.Position,p)if w<r then s,r=v
,w end end end return s,r end,function(o)local p=c.Aim return p.Kinds[o.kind]and
e.alive(o)and not(p.TeamCheck and e.isTeammate(o))and not(p.SkipProtected and e.
protected(o))end local r=function(r,s)if not r or not r.part.Parent or not q(r.
entity)then return false end if(r.part.Position-g.CFrame.Position).Magnitude>c.
Aim.MaxDistance then return false end return m(r.part.Position,s)<=c.Aim.
FovRadius and o(r.entity,r.part)end function h.selectTarget()e.refresh(os.clock(
))local s,t,u,v,w=c.Aim,h.origin2D(),g.CFrame.Position,(math.huge)for x,y in
ipairs(d.Entities)do if q(y)then local z,A=p(y.model,t)if z and A<=s.FovRadius
and A<v and(z.Position-u).Magnitude<=s.MaxDistance then if not o(y,z)then z=nil
for B,C in ipairs(s.ClosestParts)do local D=n(y.model,C)if D and o(y,D)then z=D
break end end end if z then w,v={entity=y,part=z},A end end end end return w end
local s,t=function(s)return typeof(s)=='Vector3'and s.X==s.X and s.Y==s.Y and s.
Z==s.Z and math.abs(s.X)<1e6 and math.abs(s.Y)<1e6 and math.abs(s.Z)<1e6 end,
function()local s,t=c.Aim,d.Target if not r(t,h.origin2D())then t=h.
selectTarget()end if not t or(s.HitChance<100 and math.random()*100>=s.HitChance
)then return nil end return t end local u,v=function(u)local v=t()if not v then
return nil end local w=v.part.Position if not s(w)or(w-u.Position).Magnitude<0.5
then return nil end return CFrame.lookAt(u.Position,w,u.UpVector)end,function()
for u=3,4 do if debug.info(u,'n')==c.Native.ShotFunction then return true end
end return false end function h.install()if i or type(hookmetamethod)~=
'function'then d.Errors.install={message='hookmetamethod unavailable',at=os.
clock()}return false end i=true local w='CFrame'l=hookmetamethod(game,'__index',
newcclosure(function(x,y)local z=l(x,y)if y==w and d.Loaded and c.Aim.Enabled
and not checkcaller()and x==g and v()then d.Stats.Shots=d.Stats.Shots+1 local A,
B=pcall(u,z)if A and B then d.Stats.Redirected=d.Stats.Redirected+1 d.
LastRedirectAt=os.clock()return B elseif not A then d.Errors.silentAim={message=
tostring(B),at=os.clock()}end end return z end))return true end function h.
cleanup()end return h end function a.e()local c=a.cache.e if not c then c={c=b()
}a.cache.e=c end return c.c end end do local b=function()local b,c,d,e,f,g,h,i,j
,k,l,m=a.a(),a.c(),a.d(),a.e(),workspace.CurrentCamera,{},Color3.fromRGB(255,60,
60),Color3.fromRGB(60,255,90),200,{{'Head','UpperTorso'},{'UpperTorso',
'LowerTorso'},{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{
'LeftLowerArm','LeftHand'},{'UpperTorso','RightUpperArm'},{'RightUpperArm',
'RightLowerArm'},{'RightLowerArm','RightHand'},{'LowerTorso','LeftUpperLeg'},{
'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{'LowerTorso',
'RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg','RightFoot'}
},{},-1 local n,o,p,q,r=function(n)local o=f:WorldToViewportPoint(n)return o.X,o
.Y,o.Z end,function(n,o)local p=Drawing.new(n)for q,r in pairs(o)do p[q]=r end p
.Visible=false return{d=p,shown=false}end,function(n,o)if n.shown~=o then n.
shown=o n.d.Visible=o end end,function(n,o,p)if n[o]~=p then n[o]=p n.d[o]=p end
end,function(n)if n then pcall(n.d.Remove,n.d)end end local s,t=function()return
{box=o('Square',{Thickness=1.5,Filled=false}),name=o('Text',{Size=13,Center=true
,Outline=true}),info=o('Text',{Size=12,Center=true,Outline=true}),hpBack=o(
'Square',{Filled=true,Color=Color3.new(0,0,0),Transparency=0.6}),hpFill=o(
'Square',{Filled=true}),hpText=o('Text',{Size=11,Center=false,Outline=true}),
tracer=nil,bones=nil,visible=false}end,function(s,t)t(s.box)t(s.name)t(s.info)t(
s.hpBack)t(s.hpFill)t(s.hpText)if s.tracer then t(s.tracer)end if s.bones then
for u,v in ipairs(s.bones)do t(v)end end end local u,v,w,x,y=function(u)if u.
visible then u.visible=false t(u,function(v)p(v,false)end)end end,function(u)
local v=l[u]if v then t(v,r)l[u]=nil end end,{'Head','UpperTorso','LowerTorso',
'LeftHand','RightHand','LeftFoot','RightFoot','LeftLowerArm','RightLowerArm'},
0.9,0.12 local z,A=function(z)local A=z:FindFirstChild'Head'if not(A and A:IsA
'BasePart')then return nil end local B,C,D,E,F,G=math.huge,math.huge,-math.huge,
-math.huge,Vector3.zero,0 local H=function(H)local I,J,K=n(H)if K<=0 then return
false end B,C,D,E=math.min(B,I),math.min(C,J),math.max(D,I),math.max(E,J)return
true end if not H(A.Position+Vector3.yAxis*x)then return nil end for I,J in
ipairs(w)do local K=z:FindFirstChild(J)if K and K:IsA'BasePart'then if not H(K.
Position)then return nil end F,G=F+K.Position,G+1 end end if G<3 then return nil
end local I,J=(D-B)*y+2,(E-C)*y*0.5 return B-I,C-J,D+I,E+J,F/G end,function(z,A,
B)if not z.bones then z.bones={}for C=1,#k do z.bones[C]=o('Line',{Thickness=1})
end end for C,D in ipairs(k)do local E,F,G,H=z.bones[C],e.part(A,D[1]),e.part(A,
D[2]),false if F and G then local I,J,K=n(F.Position)local L,M,N=n(G.Position)if
K>0 and N>0 then E.d.From=Vector2.new(I,J)E.d.To=Vector2.new(L,M)q(E,'Color',B)H
=true end end p(E,H)end end local B=function(B,C,D)local E,F,G=b.Esp,B.model,B.
humanoid local H=l[F]if not H then H=s()l[F]=H end local I,J,K,L,M=z(F)if not I
then u(H)return end local N=(M-C).Magnitude if N>E.MaxDistance or K<-j or L<-j
or I>D.X+j or J>D.Y+j then u(H)return end H.visible=true local O=d.isTeammate(B)
and E.Colors.Team or E.Colors[B.kind]p(H.box,E.Boxes)if E.Boxes then q(H.box,
'Color',O)H.box.d.Position=Vector2.new(I,J)H.box.d.Size=Vector2.new(K-I,L-J)end
p(H.name,E.Names)if E.Names then q(H.name,'Text',E.Distance and('%s [%d]'):
format(B.label,math.floor(N+0.5))or B.label)q(H.name,'Color',O)H.name.d.Position
=Vector2.new((I+K)*0.5,J-16)end local P=E.HeldItem and d.heldItem(B)p(H.info,P~=
nil and P~=false)if P then q(H.info,'Text',P)q(H.info,'Color',O)H.info.d.
Position=Vector2.new((I+K)*0.5,L+2)end local Q=E.Health and B.kind=='Player'p(H.
hpBack,Q)p(H.hpFill,Q)p(H.hpText,Q)if Q then local R,S=math.clamp(G.Health/math.
max(G.MaxHealth,1),0,1),L-J local T=h:Lerp(i,R)H.hpBack.d.Position=Vector2.new(I
-6,J)H.hpBack.d.Size=Vector2.new(3,S)q(H.hpFill,'Color',T)H.hpFill.d.Position=
Vector2.new(I-6,J+S*(1-R))H.hpFill.d.Size=Vector2.new(3,S*R)q(H.hpText,'Text',
tostring(math.floor(G.Health+0.5)))q(H.hpText,'Color',T)local U=H.hpText.d.
TextBounds H.hpText.d.Position=Vector2.new(I-9-(U and U.X or 0),J+S*(1-R)-6)end
if E.Tracers then if not H.tracer then H.tracer=o('Line',{Thickness=1})end p(H.
tracer,true)q(H.tracer,'Color',O)H.tracer.d.From=Vector2.new(D.X*0.5,D.Y)H.
tracer.d.To=Vector2.new((I+K)*0.5,L)elseif H.tracer then p(H.tracer,false)end if
E.Skeleton then A(H,F,O)elseif H.bones then for R,S in ipairs(H.bones)do p(S,
false)end end end function g.draw()local C,D,E,F,G=b.Esp,f.CFrame.Position,f.
ViewportSize,os.clock(),m~=c.EntitiesGen and{}or nil for H,I in ipairs(c.
Entities)do if G then G[I.model]=true end if C.Enabled and C.Kinds[I.kind]and d.
alive(I)and not(C.TeamCheck and d.isTeammate(I))and(not C.HideStale or d.fresh(I
,F))then B(I,D,E)else local J=l[I.model]if J then u(J)end end end if G then m=c.
EntitiesGen for H in pairs(l)do if not G[H]then v(H)end end end end function g.
cleanup()for C in pairs(l)do v(C)end end return g end function a.f()local c=a.
cache.f if not c then c={c=b()}a.cache.f=c end return c.c end end do local b=
function()local b,c,d,e,f=a.a(),a.c(),a.e(),{},Drawing.new'Circle'f.Thickness=
1.5 f.NumSides=64 f.Filled=false f.Transparency=0.8 f.Visible=false local g=
Instance.new'Highlight'g.FillTransparency=1 g.DepthMode=Enum.HighlightDepthMode.
AlwaysOnTop g.OutlineColor=b.Visuals.LockedColor local h g.Parent=(gethui and
gethui())or game:GetService'CoreGui'function e.update()local i,j=b.Visuals,b.Aim
local k=i.ShowFov and j.Enabled f.Visible=k if k then f.Position=d.origin2D()f.
Radius=j.FovRadius f.Color=c.Target and i.LockedColor or i.FovColor end local l=
(i.ShowTargetHighlight and c.Target)and c.Target.entity.model or nil if h~=l
then h=l pcall(function()g.Adornee=l end)end end function e.cleanup()pcall(f.
Remove,f)pcall(g.Destroy,g)end return e end function a.g()local c=a.cache.g if
not c then c={c=b()}a.cache.g=c end return c.c end end do local b=function()
local b,c,d=a.a(),a.c(),{}function d.build()local e=loadstring(game:HttpGet(b.
UiSource))()local f=e:Window{Name=b.Name,Icon=b.WindowIcon}local g,h=f:Page{Icon
='crosshair',Columns=2},f:Page{Icon='eye',Columns=2}e:CreateSettingsPage(f)local
i,j,k,l=function(i,j,k,l,m)return i:Toggle{Name=j,Flag=k,Default=l,Callback=m}
end,function(i,j,k,l,m,n,o,p,q)return i:Slider{Name=j,Flag=k,Default=l,Min=m,Max
=n,Decimals=o,Suffix=p,Callback=q}end,function(i,j,k,l,m,n)return i:Dropdown{
Name=j,Flag=k,Default=l,Items=m,MaxSize=100,Callback=n}end,function(i,j,k,l,m)
return i:Label(j):Colorpicker{Flag=k,Default=l,Callback=m}end local m,n,o,p,q,r=
function(m,n,o,p,q)return i(m,n,o,p[q],function(r)p[q]=r end)end,b.Aim,b.Visuals
,b.Esp,g:Section{Name='Silent Aim',Icon='crosshair',Side=1},g:Section{Name=
'Field of View',Icon='circle',Side=2}i(q,'Enabled','SAEnabled',n.Enabled,
function(s)n.Enabled=s if not s then c.Target=nil end end)k(q,'Aim Part',
'SAPart',n.TargetPart,b.PartModes,function(s)n.TargetPart=s end)j(q,'Hit Chance'
,'SAHitChance',n.HitChance,0,100,1,'%',function(s)n.HitChance=s end)j(q,
'Max Distance','SAMaxDist',n.MaxDistance,50,3000,10,' studs',function(s)n.
MaxDistance=s end)m(q,'Visibility Check','SAVisible',n,'VisibleCheck')m(q,
'Team Check','SATeam',n,'TeamCheck')m(q,'Skip Spawn Protected','SAProtected',n,
'SkipProtected')j(r,'Radius','SAFov',n.FovRadius,10,800,1,'px',function(s)n.
FovRadius=s end)m(r,'Show Circle','SAShowFov',o,'ShowFov')m(r,'Highlight Target'
,'SAHighlight',o,'ShowTargetHighlight')l(r,'Circle Color','SAFovColor',o.
FovColor,function(s)o.FovColor=s end)l(r,'Locked Color','SALockedColor',o.
LockedColor,function(s)o.LockedColor=s end)local s,t=h:Section{Name='ESP',Icon=
'eye',Side=1},h:Section{Name='Colors',Icon='palette',Side=2}m(s,'Enabled',
'FXEsp',p,'Enabled')m(s,'Team Check','FXTeam',p,'TeamCheck')m(s,'Boxes',
'FXBoxes',p,'Boxes')m(s,'Skeleton','FXSkeleton',p,'Skeleton')m(s,'Tracers',
'FXTracers',p,'Tracers')m(s,'Names','FXNames',p,'Names')m(s,'Health','FXHealth',
p,'Health')m(s,'Distance','FXDistance',p,'Distance')m(s,'Held Weapon',
'FXHeldItem',p,'HeldItem')j(s,'Max Distance','FXEspDist',p.MaxDistance,50,5000,
10,' studs',function(u)p.MaxDistance=u end)for u,v in ipairs(b.Kinds)do m(q,
'Target '..v..'s','SA'..v..'s',n.Kinds,v)m(s,v..'s','FXEsp'..v..'s',p.Kinds,v)l(
t,v..'s','FXCol'..v,p.Colors[v],function(w)p.Colors[v]=w end)end l(t,'Teammates'
,'FXColTeam',p.Colors.Team,function(u)p.Colors.Team=u end)return e end function
d.destroy(e)if type(e)=='table'and type(e.Unload)=='function'then pcall(e.Unload
,e)end end return d end function a.h()local c=a.cache.h if not c then c={c=b()}a
.cache.h=c end return c.c end end do local b=function()local b,c,d,e,f,g,h,i=a.
b(),a.a(),a.c(),a.d(),a.e(),a.f(),a.g(),a.h()local j=b.RunService return
function()if game.PlaceVersion~=c.Build.PlaceVersion then d.BuildMismatch={
measured=c.Build.PlaceVersion,current=game.PlaceVersion}end local k local l,m=
function()if not d.Loaded then return end d.Loaded=false for l,m in ipairs(d.
Connections)do pcall(m.Disconnect,m)end table.clear(d.Connections)f.cleanup()g.
cleanup()h.cleanup()i.destroy(k and k.Library)getgenv()[c.Name]=nil end,function
()local l=os.clock()e.refresh(l)if not c.Aim.Enabled then d.Target=nil elseif l-
d.SelectAt>=c.Perf.TargetSelectInterval then d.SelectAt=l d.Target=f.
selectTarget()end h.update()g.draw()end f.install()local n=workspace:
FindFirstChild(c.Native.HitboxFolder)if n then local o=function()d.EntitiesAt=-
math.huge end d.connect(n.ChildAdded,o)d.connect(n.ChildRemoved,o)end d.connect(
j.RenderStepped,d.guarded('render',m))k={Config=c,State=d,SelectTarget=f.
selectTarget,Unload=l}getgenv()[c.Name]=k if c.LoadUi then local o,p=pcall(i.
build)if o then k.Library=p else d.Errors.ui={message=tostring(p),at=os.clock()}
end end end end function a.i()local c=a.cache.i if not c then c={c=b()}a.cache.i
=c end return c.c end end end local b=a.a()local c=getgenv()[b.Name]if c and c.
Unload then pcall(c.Unload)end local d=a.i()d()
