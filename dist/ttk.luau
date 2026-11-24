local a={cache={}}do do local b=function()return{Build={PlaceId=120189115846709,
PlaceVersion=1953},Native={BulletControllerPath={'Modules','Client',
'Controllers','BulletController'},FriendlyFirePath={'Modules','Shared','Combat',
'FriendlyFire'},HitboxFolder='MercPlayers',HitboxPrefix='MercHitboxes_',
VisualPrefix='MercVisual_',HitZoneSuffix='HitZone'},Aim={Enabled=true,FovRadius=
150,TargetPart='Head',ClosestParts={'Head','UpperTorso','LowerTorso'},
MaxDistance=1500,VisibleCheck=true,TeamCheck=true,SkipProtected=true,HitChance=
100},Esp={Enabled=true,TeamCheck=true,Kinds={Player=true},Boxes=true,Names=true,
Health=false,HideStale=true,StaleSeconds=3,MaxRigDrift=15,Distance=true,HeldItem
=true,Tracers=false,Skeleton=false,MaxDistance=3000,Colors={Player=Color3.
fromRGB(255,70,70),Team=Color3.fromRGB(80,170,255)}},Visuals={ShowFov=true,
ShowTargetHighlight=true,FovColor=Color3.fromRGB(255,255,255),LockedColor=Color3
.fromRGB(255,80,80)},Perf={EntityInterval=0.15,TargetSelectInterval=0.05},Name=
'Pandemonium',WindowIcon='rbxassetid://132509022802512',LoadUi=true,UiSource=
[[https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee]],
RayIgnoreFolders={'Ignore','_CosmeticProjectiles','_CosmeticBulletHoles',
'_GlassDebris','WeaponDrops','WeaponDropModels'},PartModes={'Head','UpperTorso',
'LowerTorso','Closest'},Kinds={'Player'}}end function a.a()local c=a.cache.a if
not c then c={c=b()}a.cache.a=c end return c.c end end do local b=function()
return{Players=game:GetService'Players',RunService=game:GetService'RunService',
UserInputService=game:GetService'UserInputService',ReplicatedStorage=game:
GetService'ReplicatedStorage'}end function a.b()local c=a.cache.b if not c then
c={c=b()}a.cache.b=c end return c.c end end do local b=function()local b={Loaded
=true,Connections={},Errors={},BuildMismatch=nil,Target=nil,SelectAt=-math.huge,
Stats={Shots=0,Redirected=0,Hits=0,HitsRedirected=0,HitsNormal=0},LastRedirectAt
=-math.huge,Entities={},EntitiesAt=-math.huge,EntitiesGen=0}function b.connect(c
,d)local e=c:Connect(d)table.insert(b.Connections,e)return e end function b.
guarded(c,d)return function(...)local e,f=xpcall(d,debug.traceback,...)if not e
then b.Errors[c]={message=tostring(f),at=os.clock()}end end end return b end
function a.c()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.
c end end do local b=function()local b,c,d=a.b(),a.a(),a.c()local e=b.Players
local f,g,h,i,j=e.LocalPlayer,{},setmetatable({},{__mode='k'}),function(f,g)
local h=f for i,j in ipairs(g)do h=h and h:FindFirstChild(j)end return h end g.
findPath=i local k=function()if j==nil then local k,l,m=i(b.ReplicatedStorage,c.
Native.FriendlyFirePath),false if k and k:IsA'ModuleScript'then l,m=pcall(
require,k)end j=(l and type(m)=='table'and type(m.Affects)=='function')and m or
false end return j or nil end function g.refresh(l)if l-d.EntitiesAt<c.Perf.
EntityInterval then return end d.EntitiesAt=l local m,n=workspace:
FindFirstChild(c.Native.HitboxFolder),{}for o,p in ipairs(e:GetPlayers())do
local q=p~=f and p.Character local r=q and q:FindFirstChildOfClass'Humanoid'
local s=r and m and m:FindFirstChild(c.Native.HitboxPrefix..p.Name)if s and s:
IsA'Model'then table.insert(n,{model=s,character=q,humanoid=r,kind='Player',
label=p.DisplayName,player=p})end end d.Entities=n d.EntitiesGen=d.EntitiesGen+1
end function g.isTeammate(l)local m=k()if not m then return false end local n,o=
pcall(m.Affects,'Damage',f,l.player)return n and o==false end function g.alive(l
)local m=l.model if m.Parent==nil or l.character.Parent==nil or l.humanoid.
Parent~=l.character or l.humanoid.Health<=0 then return false end return m:
GetAttribute'Dead'~=true and m:GetAttribute'Ragdolled'~=true and l.player:
GetAttribute'InWorld'~=false end function g.fresh(l,m)local n,o=l.model:
FindFirstChild'Head',l.character:FindFirstChild'HumanoidRootPart'if not(n and n:
IsA'BasePart')then return false end if o and o:IsA'BasePart'and(n.Position-o.
Position).Magnitude>c.Esp.MaxRigDrift then return false end local p=h[l.model]if
not p then p={cf=nil,movedAt=m}h[l.model]=p end local q=n.CFrame if p.cf~=q then
p.cf=q p.movedAt=m end return m-p.movedAt<=c.Esp.StaleSeconds end function g.
protected(l)return l.player:GetAttribute'SpawnProtected'==true or l.player:
GetAttribute'Godmode'==true end function g.heldItem(l)local m=l.player:
GetAttribute'CurrentWeapon'return type(m)=='string'and m~=''and m or nil end
function g.ownerOf(l)local m=l:GetAttribute'OwnerUserId'if typeof(m)=='number'
then return m end local n=l:FindFirstAncestorOfClass'Model'm=n and n:
GetAttribute'OwnerUserId'return typeof(m)=='number'and m or nil end function g.
rayParams()local l=RaycastParams.new()l.FilterType=Enum.RaycastFilterType.
Exclude l.IgnoreWater=true local m={workspace.CurrentCamera}for n,o in ipairs(e:
GetPlayers())do if o.Character then table.insert(m,o.Character)end end local n=
workspace:FindFirstChild(c.Native.HitboxFolder)if n then for o,p in ipairs{c.
Native.HitboxPrefix,c.Native.VisualPrefix}do local q=n:FindFirstChild(p..f.Name)
if q then table.insert(m,q)end end end for o,p in ipairs(c.RayIgnoreFolders)do
local q=workspace:FindFirstChild(p)if q then table.insert(m,q)end end local o=
workspace:FindFirstChild'ActiveMap'for p,q in ipairs{'Touchables','Ignore'}do
local r=o and o:FindFirstChild(q)if r then table.insert(m,r)end end l.
FilterDescendantsInstances=m return l end return g end function a.d()local c=a.
cache.d if not c then c={c=b()}a.cache.d=c end return c.c end end do local b=
function()local b,c,d,e=a.b(),a.a(),a.c(),a.d()local f,g,h,i,j,k,l,m=b.
UserInputService,workspace.CurrentCamera,{},e.rayParams(),(-1)function h.
origin2D()if f.MouseBehavior==Enum.MouseBehavior.LockCenter then return g.
ViewportSize/2 end return f:GetMouseLocation()end local n,o=function(n,o)local p
,q=g:WorldToViewportPoint(n)if not q or p.Z<=0 then return math.huge end return(
Vector2.new(p.X,p.Y)-o).Magnitude end,function(n,o)local p=n:FindFirstChild(o)if
not(p and p:IsA'BasePart')then return nil end local q=p:FindFirstChild(o..c.
Native.HitZoneSuffix)return q and q:IsA'BasePart'and q or p end h.part=o local p
,q,r=function(p,q,r)if not c.Aim.VisibleCheck then return true end if j~=d.
EntitiesGen then i=e.rayParams()j=d.EntitiesGen end r=r or g.CFrame.Position
local s=workspace:Raycast(r,q.Position-r,i)return s==nil or e.ownerOf(s.Instance
)==p.player.UserId end,function(p,q)local r=c.Aim if r.TargetPart~='Closest'then
local s=o(p,r.TargetPart)or o(p,'UpperTorso')return s,s and n(s.Position,q)or
math.huge end local s,t=(math.huge)for u,v in ipairs(r.ClosestParts)do local w=
o(p,v)if w then local x=n(w.Position,q)if x<s then t,s=w,x end end end return t,
s end,function(p)local q=c.Aim return e.alive(p)and e.fresh(p,os.clock())and not
(q.TeamCheck and e.isTeammate(p))and not(q.SkipProtected and e.protected(p))end
local s=function(s,t)if not s or not s.part.Parent or not r(s.entity)then return
false end if(s.part.Position-g.CFrame.Position).Magnitude>c.Aim.MaxDistance then
return false end return n(s.part.Position,t)<=c.Aim.FovRadius and p(s.entity,s.
part)end function h.selectTarget()e.refresh(os.clock())local t,u,v,w,x=c.Aim,h.
origin2D(),g.CFrame.Position,(math.huge)for y,z in ipairs(d.Entities)do if r(z)
then local A,B=q(z.model,u)if A and B<=t.FovRadius and B<w and(A.Position-v).
Magnitude<=t.MaxDistance then if not p(z,A)then A=nil for C,D in ipairs(t.
ClosestParts)do local E=o(z.model,D)if E and p(z,E)then A=E break end end end if
A then x,w={entity=z,part=A},B end end end end return x end local t,u=function(t
)return typeof(t)=='Vector3'and t.X==t.X and t.Y==t.Y and t.Z==t.Z and math.abs(
t.X)<1e6 and math.abs(t.Y)<1e6 and math.abs(t.Z)<1e6 end,function()local t,u=c.
Aim,d.Target if not s(u,h.origin2D())then u=h.selectTarget()end if not u or(t.
HitChance<100 and math.random()*100>=t.HitChance)then return nil end return u
end local v=function(v,w)local x=u()if not x then return nil end local y,z=x.
part.Position,(typeof(w)=='CFrame'and t(w.Position)and(w.Position-v).Magnitude<
10)and w.Position or v local A=y-z if not t(y)or A.Magnitude<0.5 then return nil
end return A.Unit end function h.install()local w,x,y=e.findPath(b.
ReplicatedStorage,c.Native.BulletControllerPath),false if w and w:IsA
'ModuleScript'then x,y=pcall(require,w)end if not(x and type(y)=='table'and
type(y.Discharge)=='function')or table.isfrozen(y)then d.Errors.install={message
='BulletController.Discharge not found',at=os.clock()}return false end k=y l=y.
Discharge m=function(z,A,B,C,D,...)if d.Loaded and c.Aim.Enabled and typeof(B)==
'Vector3'and typeof(C)=='Vector3'then d.Stats.Shots=d.Stats.Shots+1 local E,F=
pcall(v,B,D)if E and F then d.Stats.Redirected=d.Stats.Redirected+1 d.
LastRedirectAt=os.clock()C=F*math.max(C.Magnitude,1e-3)elseif not E then d.
Errors.silentAim={message=tostring(F),at=os.clock()}end end return l(z,A,B,C,D,
...)end y.Discharge=m if type(y.HitConfirmed)=='table'and type(y.HitConfirmed.
Connect)=='function'then d.connect(y.HitConfirmed,function()d.Stats.Hits=d.Stats
.Hits+1 local z=os.clock()-d.LastRedirectAt<0.6 and'HitsRedirected'or
'HitsNormal'd.Stats[z]=d.Stats[z]+1 end)end return true end function h.cleanup()
if k and k.Discharge==m then k.Discharge=l end end return h end function a.e()
local c=a.cache.e if not c then c={c=b()}a.cache.e=c end return c.c end end do
local b=function()local b,c,d,e,f,g,h,i,j,k,l,m=a.a(),a.c(),a.d(),a.e(),
workspace.CurrentCamera,{},Color3.fromRGB(255,60,60),Color3.fromRGB(60,255,90),
200,{{'Head','UpperTorso'},{'UpperTorso','LowerTorso'},{'UpperTorso',
'LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm','LeftHand'},{
'UpperTorso','RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'RightLowerArm'
,'RightHand'},{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{
'LeftLowerLeg','LeftFoot'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg',
'RightLowerLeg'},{'RightLowerLeg','RightFoot'}},{},-1 local n,o,p,q,r=function(n
)local o=f:WorldToViewportPoint(n)return o.X,o.Y,o.Z end,function(n,o)local p=
Drawing.new(n)for q,r in pairs(o)do p[q]=r end p.Visible=false return{d=p,shown=
false}end,function(n,o)if n.shown~=o then n.shown=o n.d.Visible=o end end,
function(n,o,p)if n[o]~=p then n[o]=p n.d[o]=p end end,function(n)if n then
pcall(n.d.Remove,n.d)end end local s,t=function()return{box=o('Square',{
Thickness=1.5,Filled=false}),name=o('Text',{Size=13,Center=true,Outline=true}),
info=o('Text',{Size=12,Center=true,Outline=true}),hpBack=o('Square',{Filled=true
,Color=Color3.new(0,0,0),Transparency=0.6}),hpFill=o('Square',{Filled=true}),
hpText=o('Text',{Size=11,Center=false,Outline=true}),tracer=nil,bones=nil,
visible=false}end,function(s,t)t(s.box)t(s.name)t(s.info)t(s.hpBack)t(s.hpFill)
t(s.hpText)if s.tracer then t(s.tracer)end if s.bones then for u,v in ipairs(s.
bones)do t(v)end end end local u,v,w,x,y=function(u)if u.visible then u.visible=
false t(u,function(v)p(v,false)end)end end,function(u)local v=l[u]if v then t(v,
r)l[u]=nil end end,{'Head','UpperTorso','LowerTorso','LeftHand','RightHand',
'LeftFoot','RightFoot','LeftLowerArm','RightLowerArm'},0.9,0.12 local z,A=
function(z)local A=z:FindFirstChild'Head'if not(A and A:IsA'BasePart')then
return nil end local B,C,D,E,F,G=math.huge,math.huge,-math.huge,-math.huge,
Vector3.zero,0 local H=function(H)local I,J,K=n(H)if K<=0 then return false end
B,C,D,E=math.min(B,I),math.min(C,J),math.max(D,I),math.max(E,J)return true end
if not H(A.Position+Vector3.yAxis*x)then return nil end for I,J in ipairs(w)do
local K=z:FindFirstChild(J)if K and K:IsA'BasePart'then if not H(K.Position)then
return nil end F,G=F+K.Position,G+1 end end if G<3 then return nil end local I,J
=(D-B)*y+2,(E-C)*y*0.5 return B-I,C-J,D+I,E+J,F/G end,function(z,A,B)if not z.
bones then z.bones={}for C=1,#k do z.bones[C]=o('Line',{Thickness=1})end end for
C,D in ipairs(k)do local E,F,G,H=z.bones[C],e.part(A,D[1]),e.part(A,D[2]),false
if F and G then local I,J,K=n(F.Position)local L,M,N=n(G.Position)if K>0 and N>0
then E.d.From=Vector2.new(I,J)E.d.To=Vector2.new(L,M)q(E,'Color',B)H=true end
end p(E,H)end end local B=function(B,C,D)local E,F,G=b.Esp,B.model,B.humanoid
local H=l[F]if not H then H=s()l[F]=H end local I,J,K,L,M=z(F)if not I then u(H)
return end local N=(M-C).Magnitude if N>E.MaxDistance or K<-j or L<-j or I>D.X+j
or J>D.Y+j then u(H)return end H.visible=true local O=d.isTeammate(B)and E.
Colors.Team or E.Colors[B.kind]p(H.box,E.Boxes)if E.Boxes then q(H.box,'Color',O
)H.box.d.Position=Vector2.new(I,J)H.box.d.Size=Vector2.new(K-I,L-J)end p(H.name,
E.Names)if E.Names then q(H.name,'Text',E.Distance and('%s [%d]'):format(B.label
,math.floor(N+0.5))or B.label)q(H.name,'Color',O)H.name.d.Position=Vector2.new((
I+K)*0.5,J-16)end local P=E.HeldItem and d.heldItem(B)p(H.info,P~=nil and P~=
false)if P then q(H.info,'Text',P)q(H.info,'Color',O)H.info.d.Position=Vector2.
new((I+K)*0.5,L+2)end local Q=E.Health and B.kind=='Player'p(H.hpBack,Q)p(H.
hpFill,Q)p(H.hpText,Q)if Q then local R,S=math.clamp(G.Health/math.max(G.
MaxHealth,1),0,1),L-J local T=h:Lerp(i,R)H.hpBack.d.Position=Vector2.new(I-6,J)H
.hpBack.d.Size=Vector2.new(3,S)q(H.hpFill,'Color',T)H.hpFill.d.Position=Vector2.
new(I-6,J+S*(1-R))H.hpFill.d.Size=Vector2.new(3,S*R)q(H.hpText,'Text',tostring(
math.floor(G.Health+0.5)))q(H.hpText,'Color',T)local U=H.hpText.d.TextBounds H.
hpText.d.Position=Vector2.new(I-9-(U and U.X or 0),J+S*(1-R)-6)end if E.Tracers
then if not H.tracer then H.tracer=o('Line',{Thickness=1})end p(H.tracer,true)q(
H.tracer,'Color',O)H.tracer.d.From=Vector2.new(D.X*0.5,D.Y)H.tracer.d.To=Vector2
.new((I+K)*0.5,L)elseif H.tracer then p(H.tracer,false)end if E.Skeleton then A(
H,F,O)elseif H.bones then for R,S in ipairs(H.bones)do p(S,false)end end end
function g.draw()local C,D,E,F,G=b.Esp,f.CFrame.Position,f.ViewportSize,os.
clock(),m~=c.EntitiesGen and{}or nil for H,I in ipairs(c.Entities)do if G then G
[I.model]=true end if C.Enabled and C.Kinds[I.kind]and d.alive(I)and not(C.
TeamCheck and d.isTeammate(I))and(not C.HideStale or d.fresh(I,F))then B(I,D,E)
else local J=l[I.model]if J then u(J)end end end if G then m=c.EntitiesGen for H
in pairs(l)do if not G[H]then v(H)end end end end function g.cleanup()for C in
pairs(l)do v(C)end end return g end function a.f()local c=a.cache.f if not c
then c={c=b()}a.cache.f=c end return c.c end end do local b=function()local b,c,
d,e,f=a.a(),a.c(),a.e(),{},Drawing.new'Circle'f.Thickness=1.5 f.NumSides=64 f.
Filled=false f.Transparency=0.8 f.Visible=false local g=Instance.new'Highlight'g
.FillTransparency=1 g.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop g.
OutlineColor=b.Visuals.LockedColor local h g.Parent=(gethui and gethui())or game
:GetService'CoreGui'function e.update()local i,j=b.Visuals,b.Aim local k=i.
ShowFov and j.Enabled f.Visible=k if k then f.Position=d.origin2D()f.Radius=j.
FovRadius f.Color=c.Target and i.LockedColor or i.FovColor end local l=(i.
ShowTargetHighlight and c.Target)and c.Target.entity.model or nil if h~=l then h
=l pcall(function()g.Adornee=l end)end end function e.cleanup()pcall(f.Remove,f)
pcall(g.Destroy,g)end return e end function a.g()local c=a.cache.g if not c then
c={c=b()}a.cache.g=c end return c.c end end do local b=function()local b,c,d=a.
a(),a.c(),{}function d.build()local e=loadstring(game:HttpGet(b.UiSource))()
local f=e:Window{Name=b.Name,Icon=b.WindowIcon}local g,h=f:Page{Icon='crosshair'
,Columns=2},f:Page{Icon='eye',Columns=2}e:CreateSettingsPage(f)local i,j,k,l=
function(i,j,k,l,m)return i:Toggle{Name=j,Flag=k,Default=l,Callback=m}end,
function(i,j,k,l,m,n,o,p,q)return i:Slider{Name=j,Flag=k,Default=l,Min=m,Max=n,
Decimals=o,Suffix=p,Callback=q}end,function(i,j,k,l,m,n)return i:Dropdown{Name=j
,Flag=k,Default=l,Items=m,MaxSize=100,Callback=n}end,function(i,j,k,l,m)return i
:Label(j):Colorpicker{Flag=k,Default=l,Callback=m}end local m,n,o,p,q,r=function
(m,n,o,p,q)return i(m,n,o,p[q],function(r)p[q]=r end)end,b.Aim,b.Visuals,b.Esp,g
:Section{Name='Silent Aim',Icon='crosshair',Side=1},g:Section{Name=
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
p,'Health')m(s,'Hide Out-of-Date','FXHideStale',p,'HideStale')m(s,'Distance',
'FXDistance',p,'Distance')m(s,'Held Weapon','FXHeldItem',p,'HeldItem')j(s,
'Max Distance','FXEspDist',p.MaxDistance,50,5000,10,' studs',function(u)p.
MaxDistance=u end)l(t,'Enemies','FXColPlayer',p.Colors.Player,function(u)p.
Colors.Player=u end)l(t,'Teammates','FXColTeam',p.Colors.Team,function(u)p.
Colors.Team=u end)return e end function d.destroy(e)if type(e)=='table'and type(
e.Unload)=='function'then pcall(e.Unload,e)end end return d end function a.h()
local c=a.cache.h if not c then c={c=b()}a.cache.h=c end return c.c end end do
local b=function()local b,c,d,e,f,g,h,i=a.b(),a.a(),a.c(),a.d(),a.e(),a.f(),a.g(
),a.h()local j=b.RunService return function()if game.PlaceVersion~=c.Build.
PlaceVersion then d.BuildMismatch={measured=c.Build.PlaceVersion,current=game.
PlaceVersion}end local k local l,m=function()if not d.Loaded then return end d.
Loaded=false for l,m in ipairs(d.Connections)do pcall(m.Disconnect,m)end table.
clear(d.Connections)f.cleanup()g.cleanup()h.cleanup()i.destroy(k and k.Library)
getgenv()[c.Name]=nil end,function()local l=os.clock()e.refresh(l)if not c.Aim.
Enabled then d.Target=nil elseif l-d.SelectAt>=c.Perf.TargetSelectInterval then
d.SelectAt=l d.Target=f.selectTarget()end h.update()g.draw()end f.install()local
n=workspace:FindFirstChild(c.Native.HitboxFolder)if n then local o=function()d.
EntitiesAt=-math.huge end d.connect(n.ChildAdded,o)d.connect(n.ChildRemoved,o)
end d.connect(j.RenderStepped,d.guarded('render',m))k={Config=c,State=d,
SelectTarget=f.selectTarget,Unload=l}getgenv()[c.Name]=k if c.LoadUi then local
o,p=pcall(i.build)if o then k.Library=p else d.Errors.ui={message=tostring(p),at
=os.clock()}end end end end function a.i()local c=a.cache.i if not c then c={c=
b()}a.cache.i=c end return c.c end end end local b=a.a()local c=getgenv()[b.Name
]if c and c.Unload then pcall(c.Unload)end local d=a.i()d()
