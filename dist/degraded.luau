local a={cache={}}do do local b=function()return{Build={PlaceId=107088339391423,
PlaceVersion=49},Native={FirearmsSource='FirearmsClient',FirearmsShotName=
'tryShoot',FirearmsToolUpvalue=1,FirearmsStatsUpvalue=3,FirearmsStateUpvalue=6,
FirearmsConfigUpvalue=12,FirearmsDefaultSpeed=1000,FirearmsDefaultGravity=60,
DoubleBarrelSource='DoubleBarrelClient',DoubleBarrelShotName='fire',
DoubleBarrelShellStatsUpvalue=9,DoubleBarrelConfigUpvalue=13,
DoubleBarrelAmmoTypes={'Buckshot','Slug'},DoubleBarrelDefaultSpeed=804,
DoubleBarrelDefaultGravity=35,UpvalueScanMax=40,StackScanFrom=2,StackScanTo=7,
RescanInterval=5,RescanIdleInterval=30},Aim={Enabled=true,FovRadius=120,
TargetPart='Head',ClosestParts={'Head','UpperTorso','LowerTorso',
'HumanoidRootPart'},MaxDistance=800,VisibleCheck=true,HitChance=100,Prediction=
true,StickyTarget=false,Kinds={Player=true,Scientist=true,Animal=true,Sleeper=
false}},NoSpread={Enabled=true,PelletSpreadMult=0},NoRecoil={Enabled=true,
NoCameraShake=true,NoFovPunch=true},Esp={Enabled=true,Kinds={Player=true,
Scientist=true,Animal=true,Sleeper=false},Boxes=true,Names=true,Health=true,
Distance=true,Tracers=false,Skeleton=false,LookDirection=false,LookLength=6,
MaxDistance=1500,DropMarker=true,HeldItem=true,StatusTags=true,Statuses={{
'Downed','DOWNED'},{'GunAim','AIM'},{'Sprinting','RUN'},{'Crouching','CROUCH'}},
Colors={Player=Color3.fromRGB(255,70,70),Scientist=Color3.fromRGB(255,190,60),
Animal=Color3.fromRGB(120,200,255),Sleeper=Color3.fromRGB(170,170,170),Marker=
Color3.fromRGB(80,255,120)}},Crates={Enabled=true,Distance=true,MaxDistance=600,
Folder='WorldLoot',Kinds={Military=true,Food=true,Regular=true},Names={
MilitaryCrate='Military',FoodCrate='Food',RationBox='Food',Crate='Regular'},
KitNames={Resources_MilitaryCrate='Military',Resources_Crate='Regular'},Labels={
Military='Military Crate',Food='Food Crate',Regular='Crate'},Colors={Military=
Color3.fromRGB(110,200,90),Food=Color3.fromRGB(255,170,80),Regular=Color3.
fromRGB(200,170,120)}},Events={Enabled=true,Distance=true,MaxDistance=5000,
Folders={Airdrop='Airdrops',Heli='PatrolHeli',Bradley='BradleyAPC'},Kinds={
Airdrop=true,Heli=true,Bradley=true},Labels={Airdrop='Airdrop',Heli=
'Patrol Heli',Bradley='Bradley APC'},Colors={Airdrop=Color3.fromRGB(80,220,255),
Heli=Color3.fromRGB(255,80,200),Bradley=Color3.fromRGB(255,120,40)}},Traps={
Enabled=true,Distance=true,Health=true,MaxDistance=300,Folder='Traps',Kinds={
AutoTurret=true,FlameTurret=true,ShotgunTrap=true,BearTrap=true,TinCanAlarm=true
},Labels={AutoTurret='Auto Turret',FlameTurret='Flame Turret',ShotgunTrap=
'Shotgun Trap',BearTrap='Bear Trap',TinCanAlarm='Tin Can Alarm'},Order={
'AutoTurret','FlameTurret','ShotgunTrap','BearTrap','TinCanAlarm'},Color=Color3.
fromRGB(255,90,90)},Skins={Enabled=false,Skin='DegradeRed',Module='GunSkins',
Interval=0.25},CameraFov={Enabled=false,Value=90},FullBright={Enabled=true,
Brightness=2,ClockTime=12,Ambient=Color3.fromRGB(178,178,178),OutdoorAmbient=
Color3.fromRGB(178,178,178),ExposureCompensation=0,NoFog=true,NoShadows=true,
NoAtmosphere=true,DisableEffects={'DayNightGrade','Bloom','SunRays',
'DepthOfField'}},Visuals={ShowFov=true,ShowTargetHighlight=true,FovColor=Color3.
fromRGB(255,255,255),LockedColor=Color3.fromRGB(255,80,80)},Perf={EntityInterval
=1,TargetSelectInterval=0.05,PatchInterval=0.5,MarkerInterval=0.05,MarkerStep=
2.5E-2},Name='Pandemonium',WindowIcon='rbxassetid://132509022802512',LoadUi=true
,UiSource=
[[https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee]],
RayIgnoreFolders={'FirearmsTracers','DroppedItems','ShotgunEffects',
'PipePistolEffects','FirearmsPings'},MarkerRayIgnoreExtra={'StuckArrows'},
NpcFolders={Scientist='Scientists',Animal='Animals',Sleeper='Sleepers'},
PartModes={'Head','UpperTorso','HumanoidRootPart','Closest'},Kinds={'Player',
'Scientist','Animal','Sleeper'}}end function a.a()local c=a.cache.a if not c
then c={c=b()}a.cache.a=c end return c.c end end do local b=function()return{
Players=game:GetService'Players',RunService=game:GetService'RunService',
UserInputService=game:GetService'UserInputService',ReplicatedStorage=game:
GetService'ReplicatedStorage',Lighting=game:GetService'Lighting',HttpService=
game:GetService'HttpService'}end function a.b()local c=a.cache.b if not c then c
={c=b()}a.cache.b=c end return c.c end end do local b=function()local b={Loaded=
true,Connections={},Errors={},BuildMismatch=nil,Target=nil,SelectAt=-math.huge,
OriginalHeld=nil,Wrapper=nil,Shots={},Stats={Calls=0,Redirected=0,Skipped=0},
FirearmsClosures={},DoubleBarrelClosures={},FaStats={},FaStates={},FaConfigs={},
DbConfigs={},DbShellFns={},LastScanAt=-math.huge,LastPatchAt=-math.huge,
RescanQueued=false,Patched=0,Entities={},EntitiesAt=-math.huge,EntitiesGen=0,
Crates={},CratesAt=-math.huge,CratesGen=0,MarkerAt=-math.huge,Objects={},
ObjectsAt=-math.huge,ObjectsGen=0}function b.connect(c,d)local e=c:Connect(d)
table.insert(b.Connections,e)return e end function b.guarded(c,d)return function
(...)local e,f=pcall(d,...)if not e then b.Errors[c]={message=tostring(f),at=os.
clock()}end end end return b end function a.c()local c=a.cache.c if not c then c
={c=b()}a.cache.c=c end return c.c end end do local b=function()local b={}
function b.finiteVec(c)return c.X==c.X and c.Y==c.Y and c.Z==c.Z and math.abs(c.
X)<1e6 and math.abs(c.Y)<1e6 and math.abs(c.Z)<1e6 end function b.solveBallistic
(c,d,e,f,g,h)if f<=0 then return d,0 end local i,j=(d-c).Magnitude/f,d for k=1,h
or 5 do local l=d+e*i j=l+Vector3.new(0,0.5*g*i*i,0)i=(j-c).Magnitude/f end
return j,i end function b.simulateImpact(c,d,e,f,g,h,i)i=i or
8.333333333333334E-3 local j,k,l,m=c,d*e,0,Vector3.new(0,-f*i,0)while l<g do
local n=k+m local o=(k+n)*(0.5*i)local p=h(j,o)if p then return p,l end j,k,l=j+
o,n,l+i end return nil end local c={}for d,e in ipairs{-1,1}do for f,g in ipairs
{-1,1}do for h,i in ipairs{-1,1}do table.insert(c,Vector3.new(e,g,i))end end end
function b.screenBounds(d,e,f)local g,h,i,j,k=e*0.5,math.huge,math.huge,-math.
huge,-math.huge for l=1,8 do local m,n,o=f(d:PointToWorldSpace(c[l]*g))if o<=0
then return nil end h,j=math.min(h,m),math.max(j,m)i,k=math.min(i,n),math.max(k,
n)end return h,i,j,k end return b end function a.d()local c=a.cache.d if not c
then c={c=b()}a.cache.d=c end return c.c end end do local b=function()local b,c=
a.b(),a.a()local d,e,f=b.Players.LocalPlayer,workspace.CurrentCamera,{}function
f.up(g,h)local i,j=pcall(getupvalue,g,h)return i and j or nil end function f.
findUpvalue(g,h,i)if h then local j=f.up(g,h)if i(j)then return j end end for j=
1,c.Native.UpvalueScanMax do local k=f.up(g,j)if i(k)then return k end end
return nil end function f.equippedTool()local g=d.Character return g and g:
FindFirstChildOfClass'Tool'end function f.project(g)local h=e:
WorldToViewportPoint(g)return h.X,h.Y,h.Z end function f.largestPart(g)local h,i
=(-1)for j,k in ipairs(g:GetDescendants())do if k:IsA'BasePart'then local l=k.
Size local m=l.X*l.Y*l.Z if m>h then i,h=k,m end end end return i end function f
.makeRayParams(g)local h=RaycastParams.new()h.FilterType=Enum.RaycastFilterType.
Exclude h.IgnoreWater=true local i=function()local i={e}if d.Character then
table.insert(i,d.Character)end for j,k in ipairs(g)do for l,m in ipairs(k)do
local n=workspace:FindFirstChild(m)if n then table.insert(i,n)end end end h.
FilterDescendantsInstances=i end return h,i end function f.setIfDifferent(g,h,i)
if g[h]~=i then g[h]=i end end return f end function a.e()local c=a.cache.e if
not c then c={c=b()}a.cache.e=c end return c.c end end do local b=function()
local b,c,d,e=a.b(),a.a(),a.c(),a.e()local f,g,h,i=b.Players.LocalPlayer,{},e.
makeRayParams{c.RayIgnoreFolders}local j,k=e.makeRayParams{c.RayIgnoreFolders,c.
MarkerRayIgnoreExtra}g.aimRay=h g.markerRay=j function g.refresh(l)if l-d.
EntitiesAt<c.Perf.EntityInterval then return end d.EntitiesAt=l local m={}for n,
o in ipairs(b.Players:GetPlayers())do local p=o~=f and o.Character local q=p and
p:FindFirstChildOfClass'Humanoid'if q then table.insert(m,{model=p,humanoid=q,
kind='Player',label=o.DisplayName})end end for n,o in pairs(c.NpcFolders)do
local p=workspace:FindFirstChild(o)if p then for q,r in ipairs(p:GetChildren())
do local s=r:IsA'Model'and r:FindFirstChildOfClass'Humanoid'if s then table.
insert(m,{model=r,humanoid=s,kind=n,label=r.Name})end end end end d.Entities=m d
.EntitiesGen=d.EntitiesGen+1 i()k()end function g.alive(l)return l.model.Parent
~=nil and l.humanoid.Parent==l.model and l.humanoid.Health>0 end return g end
function a.f()local c=a.cache.f if not c then c={c=b()}a.cache.f=c end return c.
c end end do local b=function()local b,c,d,e,f,g=a.b(),a.a(),a.c(),a.e(),a.d(),a
.f()local h,i,j,k,l,m,n,o,p,q=b.Players.LocalPlayer,b.UserInputService,workspace
.CurrentCamera,getrenv().shared,b.ReplicatedStorage:FindFirstChild
'DoubleBarrelRemotes',e.up,e.findUpvalue,f.finiteVec,{},setmetatable({},{__mode=
'k'})local r=function(r,s)local t=r:FindFirstChild(s)if t and t:IsA'BasePart'
then return t end local u=r:FindFirstChild('Suit_'..s)if not u then return nil
end if u:IsA'BasePart'then return u end local v=q[u]if v and v.Parent and v:
IsDescendantOf(u)then return v end local w=e.largestPart(u)q[u]=w return w end p
.bodyPart=r local s=function(s)return r(s,'HumanoidRootPart')or s.PrimaryPart or
e.largestPart(s)end function p.origin2D()if i.MouseBehavior==Enum.MouseBehavior.
LockCenter then return j.ViewportSize/2 end return i:GetMouseLocation()end local
t,u=function(t,u)local v,w=j:WorldToViewportPoint(t)if not w or v.Z<=0 then
return math.huge end return(Vector2.new(v.X,v.Y)-u).Magnitude end,function(t,u)
if not c.Aim.VisibleCheck then return true end local v=j.CFrame.Position local w
=workspace:Raycast(v,u.Position-v,g.aimRay)return w==nil or w.Instance:
IsDescendantOf(t)end local v,w=function(v,w)local x=c.Aim.TargetPart if x~=
'Closest'then local y=r(v,x)or s(v)if y then return y,t(y.Position,w)end return
nil,math.huge end local y,z=(math.huge)for A,B in ipairs(c.Aim.ClosestParts)do
local C=r(v,B)if C then local D=t(C.Position,w)if D<y then z,y=C,D end end end
if not z then z=s(v)y=z and t(z.Position,w)or math.huge end return z,y end,
function(v,w)if not v or not v.model.Parent or not v.part.Parent or v.humanoid.
Health<=0 then return false end if(v.part.Position-j.CFrame.Position).Magnitude>
c.Aim.MaxDistance then return false end if t(v.part.Position,w)>c.Aim.FovRadius
then return false end return u(v.model,v.part)end function p.selectTarget()g.
refresh(os.clock())local x,y=c.Aim,p.origin2D()if x.StickyTarget and w(d.Target,
y)then return d.Target end local z,A,B=j.CFrame.Position,(math.huge)for C,D in
ipairs(d.Entities)do if x.Kinds[D.kind]and g.alive(D)and not D.model:
IsDescendantOf(j)then local E,F=v(D.model,y)if E and F<=x.FovRadius and F<A and(
E.Position-z).Magnitude<=x.MaxDistance and u(D.model,E)then B,A={model=D.model,
part=E,humanoid=D.humanoid},F end end end return B end local x,y=function()local
x=c.Native for y=x.StackScanFrom,x.StackScanTo do local z,A,B=debug.info(y,'snf'
)if z==nil then break end if A==x.FirearmsShotName and z:find(x.FirearmsSource,1
,true)then return'firearms',B elseif A==x.DoubleBarrelShotName and z:find(x.
DoubleBarrelSource,1,true)then return'doublebarrel',B end end return nil end,
function(x)return type(x)=='table'and type(x.speed)=='number'and type(x.gravity)
=='number'end function p.isToolHolder(z)return type(z)=='table'and typeof(
rawget(z,'tool'))=='Instance'end function p.doubleBarrelShell(z,A)local B=m(z,c.
Native.DoubleBarrelShellStatsUpvalue)if type(B)~='function'or not A then return
nil end local C=A:GetAttribute'LoadedType'or A:GetAttribute'AmmoType'or
'Buckshot'local D,E=pcall(B,C)if D and type(E)=='table'and tonumber(E.speed)then
return E end return nil end function p.doubleBarrelGravity()return(l and l:
GetAttribute'Gravity')or c.Native.DoubleBarrelDefaultGravity end local z,A=
function(z,A)local B=c.Native if z=='firearms'then local C=n(A,B.
FirearmsStatsUpvalue,y)if C then return C.speed,C.gravity,tostring(C.id or'?')
end return B.FirearmsDefaultSpeed,B.FirearmsDefaultGravity,'?'end local C=n(A,
nil,p.isToolHolder)local D=(C and C.tool)or e.equippedTool()local E=p.
doubleBarrelShell(A,D)return E and E.speed or B.DoubleBarrelDefaultSpeed,p.
doubleBarrelGravity(),'DoubleBarrel'end,function(z)table.insert(d.Shots,z)if#d.
Shots>32 then table.remove(d.Shots,1)end end local B=function(B,C,D)local E,F,G=
c.Aim,p.origin2D(),d.Target if not w(G,F)then G=p.selectTarget()end if not G or(
E.HitChance<100 and math.random()*100>=E.HitChance)then return nil end local H,I
,J,K,L=B.Position,G.part.Position,z(C,D)local M=0 if E.Prediction then local N=G
.part.AssemblyLinearVelocity if not o(N)or N.Magnitude>300 then N=Vector3.zero
end I,M=f.solveBallistic(H,G.part.Position,N,J,K,5)end if not o(I)or(I-H).
Magnitude<1e-3 then return nil end local N=CFrame.lookAt(H,I,B.UpVector)A{at=os.
clock(),kind=C,weapon=L,target=G.model.Name,part=G.part.Name,dist=(G.part.
Position-H).Magnitude,speed=J,gravity=K,flight=M,angle=math.deg(math.acos(math.
clamp(B.LookVector:Dot(N.LookVector),-1,1)))}return N end local C=function(C)
return function(D,...)local E=D if type(C)=='function'then local F,G=pcall(C,D,
...)if F and typeof(G)=='CFrame'then E=G end end if typeof(E)~='CFrame'or not c.
Aim.Enabled then return E end local F,G=x()if not F then return E end d.Stats.
Calls=d.Stats.Calls+1 local H,I=pcall(B,E,F,G)if H and I then d.Stats.Redirected
=d.Stats.Redirected+1 return I end if not H then d.Errors.silentAim={message=
tostring(I),at=os.clock()}end d.Stats.Skipped=d.Stats.Skipped+1 return E end end
function p.installWrapper()local D=k.HeldViewCFrame if d.Wrapper~=nil and D==d.
Wrapper then return end d.OriginalHeld=D d.Wrapper=C(D)k.HeldViewCFrame=d.
Wrapper end function p.cleanup()if k.HeldViewCFrame==d.Wrapper then k.
HeldViewCFrame=d.OriginalHeld end end return p end function a.g()local c=a.cache
.g if not c then c={c=b()}a.cache.g=c end return c.c end end do local b=function
()local b,c,d,e=a.b(),a.a(),a.c(),a.e()local f,g,h,i,j,k=e.up,e.findUpvalue,b.
ReplicatedStorage:FindFirstChild'DoubleBarrelRemotes',{},{},{}local l,m,n,o,p=
function(l,m,n)if type(l)~='table'or l[m]==nil then return end local o=j[l]if
not o then o={}j[l]=o end if o[m]==nil then o[m]=l[m]end if l[m]~=n then l[m]=n
d.Patched=d.Patched+1 end end,function(l,m)local n=j[l]if n and n[m]~=nil then l
[m]=n[m]n[m]=nil end end,function(l,m)local n=j[l]if n and n[m]~=nil then return
n[m]end return l[m]end,function(l,m,n)local o=k[l]if not o then o={}k[l]=o end
if not o[m]then o[m]={value=l:GetAttribute(m)}end if l:GetAttribute(m)~=n then l
:SetAttribute(m,n)end end,function(l,m)local n=k[l]if n and n[m]then l:
SetAttribute(m,n[m].value)n[m]=nil end end function i.restoreAll()for q,r in
pairs(j)do for s,t in pairs(r)do q[s]=t end end table.clear(j)for q,r in pairs(k
)do for s,t in pairs(r)do pcall(q.SetAttribute,q,s,t.value)end end table.clear(k
)end local q,r,s,t=function(q)return type(q)=='table'and type(q.hipSpread)==
'number'and type(q.recoilMult)=='number'end,function(q)return type(q)=='table'
and type(q.bloom)=='number'and q.lastShot~=nil end,function(q)return type(q)==
'table'and type(q.MoveSpreadHip)=='number'and type(q.AirSpread)=='number'end,
function(q)return type(q)=='table'and type(q.CameraKick)=='number'and type(q.
KickUp)=='number'end function i.scanClosures()local u,v,w=c.Native,{},{}for x,y
in ipairs(getgc())do if type(y)=='function'and islclosure(y)then local z,A=
pcall(debug.info,y,'n')if z and(A==u.FirearmsShotName or A==u.
DoubleBarrelShotName)then local B=debug.info(y,'s')if B then if A==u.
FirearmsShotName and B:find(u.FirearmsSource,1,true)then table.insert(v,y)elseif
A==u.DoubleBarrelShotName and B:find(u.DoubleBarrelSource,1,true)then table.
insert(w,y)end end end end end local x,y,z={},{},{}for A,B in ipairs(v)do local
C,D,E=g(B,u.FirearmsStatsUpvalue,q),g(B,u.FirearmsStateUpvalue,r),g(B,u.
FirearmsConfigUpvalue,s)if C then x[C]=true end if D then y[D]=true end if E
then z[E]=true end end local A,B={},{}for C,D in ipairs(w)do local E=g(D,u.
DoubleBarrelConfigUpvalue,t)if E then A[E]=true end local F=f(D,u.
DoubleBarrelShellStatsUpvalue)if type(F)=='function'and debug.info(F,'n')==
'shellStats'then B[F]=true end end d.FirearmsClosures,d.DoubleBarrelClosures=v,w
d.FaStats,d.FaStates,d.FaConfigs=x,y,z d.DbConfigs,d.DbShellFns=A,B d.LastScanAt
=os.clock()end local u pcall(function()u=require(b.ReplicatedStorage:
WaitForChild('CameraShake',5))end)local v,w,x,y,z,A=function()end,{'hipSpread',
'adsSpread','bloomPerShot'},{'recoilMult','kick','kickSide','adsKick','kickBack'
,'kickTilt','recoilPitch','recoilYaw'},{'MoveSpreadHip','MoveSpreadAds',
'AirSpread','AdsBloom'},{'CameraKick','KickUp','KickBack','KickRoll'},function(v
)if typeof(v)=='Vector2'then return Vector2.zero elseif typeof(v)=='Vector3'then
return Vector3.zero elseif type(v)=='number'then return 0 end return nil end
local B,C=function(B,C,D)for E,F in ipairs(C)do local G=D and A(n(B,F))or nil if
G~=nil then l(B,F,G)else m(B,F)end end end,function()local B,C=table.clone(c.
Native.DoubleBarrelAmmoTypes),e.equippedTool()if C then for D,E in ipairs{
'LoadedType','AmmoType'}do local F=C:GetAttribute(E)if type(F)=='string'and not
table.find(B,F)then table.insert(B,F)end end end return B end function i.apply()
local D,E,F=c.NoSpread.Enabled,c.NoRecoil.Enabled,c.NoSpread.PelletSpreadMult
for G in pairs(d.FaStats)do B(G,w,D)local H=n(G,'pelletSpread')if D and type(H)
=='number'then l(G,'pelletSpread',H*F)else m(G,'pelletSpread')end B(G,x,E)end
for G in pairs(d.FaStates)do if D then G.bloom=0 end if E and c.NoRecoil.
NoFovPunch and type(G.fovPunch)=='number'then G.fovPunch=0 end end for G in
pairs(d.FaConfigs)do B(G,y,D)end for G in pairs(d.DbConfigs)do B(G,z,E)end if
next(d.DbShellFns)then local G=C()for H in pairs(d.DbShellFns)do for I,J in
ipairs(G)do local K,L=pcall(H,J)if K and type(L)=='table'and type(L.spread)==
'number'then if D then l(L,'spread',n(L,'spread')*F)else m(L,'spread')end end
end end end if h then for G,H in ipairs{'HipCone','AdsCone'}do if D then o(h,H,0
)else p(h,H)end end end if type(u)=='table'and type(n(u,'gun'))=='function'then
if E and c.NoRecoil.NoCameraShake then l(u,'gun',v)else m(u,'gun')end end end
function i.queueRescan()if d.RescanQueued then return end d.RescanQueued=true
task.delay(0.25,function()d.RescanQueued=false if d.Loaded then i.scanClosures()
i.apply()end end)end function i.tick(D)local E,F=c.Native,#d.FirearmsClosures+#d
.DoubleBarrelClosures>0 if D-d.LastScanAt>(F and E.RescanIdleInterval or E.
RescanInterval)then i.scanClosures()end if D-d.LastPatchAt>=c.Perf.PatchInterval
then d.LastPatchAt=D i.apply()end end return i end function a.h()local c=a.cache
.h if not c then c={c=b()}a.cache.h=c end return c.c end end do local aa=
function()local b,c,d,e,f,g,h=a.a(),a.c(),a.e(),a.d(),a.f(),a.g(),workspace.
CurrentCamera local i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x=d.project,d.up,d.findUpvalue
,{},Color3.fromRGB(255,60,60),Color3.fromRGB(60,255,90),200,{{'Head',
'UpperTorso'},{'UpperTorso','LowerTorso'},{'UpperTorso','LeftUpperArm'},{
'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm','LeftHand'},{'UpperTorso',
'RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'RightLowerArm','RightHand'}
,{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg',
'LeftFoot'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{
'RightLowerLeg','RightFoot'}},{{'Head','Torso'},{'Torso','Left Arm'},{'Torso',
'Right Arm'},{'Torso','Left Leg'},{'Torso','Right Leg'}},{},-1,{},-1,function(i,
j)local k=Drawing.new(i)for l,m in pairs(j)do k[l]=m end k.Visible=false return
k end,function(i,j)if i.shown~=j then i.shown=j i.d.Visible=j end end,function(i
,j,k)if i[j]~=k then i[j]=k i.d[j]=k end end local y,z=function(y,z)return{d=v(y
,z),shown=false}end,function(y)if y then pcall(y.d.Remove,y.d)end end local A,B=
function()return{box=y('Square',{Thickness=1.5,Filled=false}),name=y('Text',{
Size=13,Center=true,Outline=true}),hpBack=y('Square',{Filled=true,Color=Color3.
new(0,0,0),Transparency=0.6}),hpFill=y('Square',{Filled=true}),info=y('Text',{
Size=12,Center=true,Outline=true}),tracer=nil,look=nil,bones=nil,gen=-1,
boneParts=nil,headPart=nil,bounds=nil,visible=false}end,function(A,B)B(A.box)B(A
.name)B(A.hpBack)B(A.hpFill)B(A.info)if A.tracer then B(A.tracer)end if A.look
then B(A.look)end if A.bones then for C,D in ipairs(A.bones)do B(D)end end end
local C,D,E,F,G,H=function(C)if C.visible then C.visible=false B(C,function(D)w(
D,false)end)end end,function(C)local D=r[C]if D then B(D,z)r[C]=nil end end,
function(C,D,E)local F,G=E.RigType==Enum.HumanoidRigType.R6 and q or p,{}for H,I
in ipairs(F)do local J,K=g.bodyPart(D,I[1]),g.bodyPart(D,I[2])if J and K then G[
H]={J,K}end end C.boneParts=G C.boneCount=#F C.headPart=g.bodyPart(D,'Head')or g
.bodyPart(D,'HumanoidRootPart')local H,I,J=pcall(D.GetBoundingBox,D)if H and J.
Magnitude>0 and J.Magnitude<200 then C.bounds={offset=D:GetPivot():
ToObjectSpace(I),size=J}else C.bounds=nil end C.gen=c.EntitiesGen end,function(C
,D)if not C.bones then C.bones={}for E=1,#p do C.bones[E]=y('Line',{Thickness=1}
)end end for E,F in ipairs(C.bones)do local G,H=E<=C.boneCount and C.boneParts[E
],false if G and G[1].Parent and G[2].Parent then local I,J,K=i(G[1].Position)
local L,M,N=i(G[2].Position)if K>0 and N>0 then F.d.From=Vector2.new(I,J)F.d.To=
Vector2.new(L,M)x(F,'Color',D)H=true end end w(F,H)end end,function(C)if C then
for D,E in ipairs(C)do w(E,false)end end end,function(C,D)if not C.look then C.
look=y('Line',{Thickness=1.5})end local E,F=C.headPart,false if E and E.Parent
then local G=E.Position local H,I,J=i(G)local K,L,M=i(G+E.CFrame.LookVector*b.
Esp.LookLength)if J>0 and M>0 then C.look.d.From=Vector2.new(H,I)C.look.d.To=
Vector2.new(K,L)x(C.look,'Color',D)F=true end end w(C.look,F)end local aa,ab=
function(I,J,K,L)local M,N,O=b.Esp,I.model,I.humanoid local P=r[N]if not P then
P=A()r[N]=P end if P.gen~=c.EntitiesGen then E(P,N,O)end local Q=P.bounds if not
Q then C(P)return end local R=N:GetPivot()*Q.offset local S=R.Position local T=(
S-K).Magnitude if T>M.MaxDistance then C(P)return end local U,V,W=i(S)if W<=0 or
U<-o or V<-o or U>L.X+o or V>L.Y+o then C(P)return end local X,Y,Z,_=e.
screenBounds(R,Q.size,i)if not X then C(P)return end P.visible=true local aa=M.
Colors[I.kind]or M.Colors.Sleeper w(P.box,M.Boxes)if M.Boxes then x(P.box,
'Color',aa)P.box.d.Position=Vector2.new(X,Y)P.box.d.Size=Vector2.new(Z-X,_-Y)end
w(P.name,M.Names)if M.Names then x(P.name,'Text',M.Distance and('%s [%d]'):
format(I.label,math.floor(T+0.5))or I.label)x(P.name,'Color',aa)P.name.d.
Position=Vector2.new((X+Z)*0.5,Y-16)end w(P.hpBack,M.Health)w(P.hpFill,M.Health)
if M.Health then local ab,ac=math.clamp(O.Health/math.max(O.MaxHealth,1),0,1),_-
Y P.hpBack.d.Position=Vector2.new(X-6,Y)P.hpBack.d.Size=Vector2.new(3,ac)x(P.
hpFill,'Color',m:Lerp(n,ab))P.hpFill.d.Position=Vector2.new(X-6,Y+ac*(1-ab))P.
hpFill.d.Size=Vector2.new(3,ac*ab)end local ab if M.HeldItem or M.StatusTags
then local ac={}if M.HeldItem then local ad=N:FindFirstChildOfClass'Tool'if ad
then table.insert(ac,ad.Name)end end if M.StatusTags then for ad,ae in ipairs(M.
Statuses)do if N:GetAttribute(ae[1])==true then table.insert(ac,ae[2])end end
end if#ac>0 then ab=table.concat(ac,' | ')end end w(P.info,ab~=nil)if ab then x(
P.info,'Text',ab)x(P.info,'Color',aa)P.info.d.Position=Vector2.new((X+Z)*0.5,_+2
)end if M.Tracers then if not P.tracer then P.tracer=y('Line',{Thickness=1})end
w(P.tracer,true)x(P.tracer,'Color',aa)P.tracer.d.From=Vector2.new(L.X*0.5,L.Y)P.
tracer.d.To=Vector2.new((X+Z)*0.5,_)elseif P.tracer then w(P.tracer,false)end if
M.Skeleton then F(P,aa)else G(P.bones)end if M.LookDirection then H(P,aa)elseif
P.look then w(P.look,false)end end,function(aa)local ab=b.Crates local ac=ab.
Names[aa.Name]if ac then return ac end local ad=aa:GetAttribute'KitDressed'
return type(ad)=='string'and ab.KitNames[ad]or nil end local ac,ad,ae,I,J=
function(ac)if ac-c.CratesAt<b.Perf.EntityInterval then return end c.CratesAt=ac
local ad,ae={},workspace:FindFirstChild(b.Crates.Folder)if ae then for I,J in
ipairs(ae:GetChildren())do local K=J:IsA'Model'and ab(J)if K and J:
FindFirstChildWhichIsA('BasePart',true)then local L,M=pcall(J.GetBoundingBox,J)
if L then table.insert(ad,{model=J,kind=K,pos=M.Position})end end end end c.
Crates=ad c.CratesGen=c.CratesGen+1 end,function(ac,ad)local ae,I=b.Crates,u~=c.
CratesGen and{}or nil for J,K in ipairs(c.Crates)do local L=t[K.model]if I then
I[K.model]=true end local M=false if ae.Enabled and ae.Kinds[K.kind]and K.model.
Parent then local N=(K.pos-ac).Magnitude if N<=ae.MaxDistance then local O,P,Q=
i(K.pos)if Q>0 and O>-o and P>-o and O<ad.X+o and P<ad.Y+o then if not L then L=
y('Text',{Size=13,Center=true,Outline=true})t[K.model]=L end local R=ae.Labels[K
.kind]if ae.Distance then R=('%s [%d]'):format(R,math.floor(N+0.5))end x(L,
'Text',R)x(L,'Color',ae.Colors[K.kind])L.d.Position=Vector2.new(O,P)M=true end
end end if L then w(L,M)end end if I then u=c.CratesGen for J,K in pairs(t)do if
not I[J]then z(K)t[J]=nil end end end end,{},-1,function(ac)if ac:IsA'BasePart'
then return ac.Position end if ac:IsA'Model'then local ad,ae=pcall(ac.
GetBoundingBox,ac)if ad then return ae.Position end end return nil end local K,L
=function(K)if K-c.ObjectsAt<b.Perf.EntityInterval then return end c.ObjectsAt=K
local L,M={},b.Events for N,O in pairs(M.Folders)do local P=workspace:
FindFirstChild(O)if P then for Q,R in ipairs(P:GetChildren())do if J(R)then
table.insert(L,{inst=R,group='Event',kind=N})end end end end local N=b.Traps
local O=workspace:FindFirstChild(N.Folder)if O then for P,Q in ipairs(O:
GetChildren())do local R=Q:GetAttribute'TrapKind'R=type(R)=='string'and R or Q.
Name if N.Labels[R]and J(Q)then table.insert(L,{inst=Q,group='Trap',kind=R})end
end end c.Objects=L c.ObjectsGen=c.ObjectsGen+1 end,function(K)if K.group==
'Event'then local L=b.Events if not(L.Enabled and L.Kinds[K.kind])then return
nil end return L.Labels[K.kind],L.Colors[K.kind],L.MaxDistance,L.Distance,false
end local L=b.Traps if not(L.Enabled and L.Kinds[K.kind])then return nil end
return L.Labels[K.kind],L.Color,L.MaxDistance,L.Distance,L.Health end local af,
ag,ah,ai,aj=function(M,N)local O=I~=c.ObjectsGen and{}or nil for P,Q in ipairs(c
.Objects)do local R=Q.inst local S=ae[R]if O then O[R]=true end local T,U,V,W,X,
Y=false,L(Q)local Z=U and R.Parent and J(R)if Z then local _=(Z-M).Magnitude if
_<=W then local af,ag,ah=i(Z)if ah>0 and af>-o and ag>-o and af<N.X+o and ag<N.Y
+o then if not S then S=y('Text',{Size=13,Center=true,Outline=true})ae[R]=S end
if Y then local ai,aj=tonumber(R:GetAttribute'ThingHealth'),tonumber(R:
GetAttribute'ThingMaxHealth')if ai and aj and aj>0 then U=('%s %d/%d'):format(U,
math.floor(ai+0.5),math.floor(aj+0.5))end end if X then U=('%s [%d]'):format(U,
math.floor(_+0.5))end x(S,'Text',U)x(S,'Color',V)S.d.Position=Vector2.new(af,ag)
T=true end end end if S then w(S,T)end end if O then I=c.ObjectsGen for af,ag in
pairs(ae)do if not O[af]then z(ag)ae[af]=nil end end end end,y('Circle',{Radius=
4,Filled=true,Thickness=1}),y('Text',{Size=13,Center=true,Outline=true}),
function()local af=d.equippedTool()if not af then return nil end local ag=b.
Native for ah=#c.FirearmsClosures,1,-1 do local ai=c.FirearmsClosures[ah]if j(ai
,ag.FirearmsToolUpvalue)==af then local aj=j(ai,ag.FirearmsStatsUpvalue)if type(
aj)=='table'and tonumber(aj.speed)and tonumber(aj.gravity)then return aj.speed,
aj.gravity,tonumber(aj.range)or 1500 end end end for ah,ai in ipairs(c.
DoubleBarrelClosures)do local aj=k(ai,3,g.isToolHolder)if aj and aj.tool==af
then local M=g.doubleBarrelShell(ai,af)if M then return M.speed,g.
doubleBarrelGravity(),tonumber(M.range)or 200 end end end return nil end,
function(af,ag)local ah=workspace:Raycast(af,ag,f.markerRay)return ah and ah.
Position end local M=function(M,N)if M-c.MarkerAt<b.Perf.MarkerInterval then
return end c.MarkerAt=M local O,P=b.Esp,false if O.Enabled and O.DropMarker then
local Q,R,S=ai()if Q and Q>0 then local T=N.Position local U,V=e.simulateImpact(
T,N.LookVector,Q,R,S/Q*1.15,aj,b.Perf.MarkerStep)if U then local W,X,Y=i(U)if Y>
0 then local Z=Vector2.new(W,X)x(ag,'Color',O.Colors.Marker)ag.d.Position=Z x(ah
,'Color',O.Colors.Marker)x(ah,'Text',('%d  %.2fs'):format(math.floor((U-T).
Magnitude+0.5),V))ah.d.Position=Z+Vector2.new(0,8)P=true end end end end w(ag,P)
w(ah,P)end function l.draw(N)local O,P=b.Esp,h.CFrame local Q,R,S=P.Position,h.
ViewportSize,s~=c.EntitiesGen and{}or nil for T,U in ipairs(c.Entities)do if S
then S[U.model]=true end if O.Enabled and O.Kinds[U.kind]and f.alive(U)then aa(U
,P,Q,R)else local V=r[U.model]if V then C(V)end end end if S then s=c.
EntitiesGen for T in pairs(r)do if not S[T]then D(T)end end end ac(N)ad(Q,R)K(N)
af(Q,R)M(N,P)end function l.cleanup()for N in pairs(r)do D(N)end for N,O in
pairs(t)do z(O)t[N]=nil end for N,O in pairs(ae)do z(O)ae[N]=nil end z(ag)z(ah)
end return l end function a.i()local ab=a.cache.i if not ab then ab={c=aa()}a.
cache.i=ab end return ab.c end end do local aa=function()local aa,ab,ac=a.b(),a.
a(),a.e()local ad,ae,af=aa.Lighting,ac.setIfDifferent,{}af.BIND=ab.Name..
'_FullBright'local ag,ah,ai,aj,b,c=1e9,{'Brightness','ClockTime','Ambient',
'OutdoorAmbient','ExposureCompensation','FogEnd','FogStart','GlobalShadows'},{},
{}local d=function()local d,e=ab.CameraFov,workspace.CurrentCamera if not e then
return end if d.Enabled then if not c then c=e.FieldOfView end ae(e,
'FieldOfView',math.clamp(d.Value,1,120))elseif c then e.FieldOfView=c c=nil end
end function af.enforce()d()local e=ab.FullBright if not e.Enabled then return
end if not b then b={}for f,g in ipairs(ah)do b[g]=ad[g]end end ae(ad,
'Brightness',e.Brightness)ae(ad,'ClockTime',e.ClockTime)ae(ad,'Ambient',e.
Ambient)ae(ad,'OutdoorAmbient',e.OutdoorAmbient)ae(ad,'ExposureCompensation',e.
ExposureCompensation)if e.NoFog then ae(ad,'FogEnd',ag)ae(ad,'FogStart',ag)end
if e.NoShadows then ae(ad,'GlobalShadows',false)end for f,g in ipairs(e.
DisableEffects)do local h=ad:FindFirstChild(g)if h and h:IsA'PostEffect'then if
ai[h]==nil then ai[h]=h.Enabled end ae(h,'Enabled',false)end end if e.
NoAtmosphere then local f=ad:FindFirstChildOfClass'Atmosphere'if f then if aj[f]
==nil then aj[f]=f.Density end ae(f,'Density',0)end end end function af.
restoreFov()if c and workspace.CurrentCamera then pcall(function()workspace.
CurrentCamera.FieldOfView=c end)end c=nil end function af.restore()if b then for
e,f in pairs(b)do pcall(function()ad[e]=f end)end b=nil end for e,f in pairs(ai)
do pcall(function()e.Enabled=f end)end table.clear(ai)for e,f in pairs(aj)do
pcall(function()e.Density=f end)end table.clear(aj)end function af.set(e)ab.
FullBright.Enabled=e and true or false if not e then af.restore()end end return
af end function a.j()local ab=a.cache.j if not ab then ab={c=aa()}a.cache.j=ab
end return ab.c end end do local aa=function()local aa,ab,ac,ad,ae,af=a.b(),a.a(
),a.c(),a.g(),{},Instance.new'ScreenGui'af.Name=ab.Name af.IgnoreGuiInset=true
af.ResetOnSpawn=false af.DisplayOrder=1000 if not pcall(function()af.Parent=(
gethui and gethui())or game:GetService'CoreGui'end)then af.Parent=aa.Players.
LocalPlayer:WaitForChild'PlayerGui'end local ag=Instance.new'Frame'ag.
AnchorPoint=Vector2.new(0.5,0.5)ag.BackgroundTransparency=1 ag.Parent=af local
ah=Instance.new'UICorner'ah.CornerRadius=UDim.new(1,0)ah.Parent=ag local ai=
Instance.new'UIStroke'ai.Thickness=1.5 ai.Transparency=0.2 ai.Parent=ag local aj
=Instance.new'Highlight'aj.FillTransparency=1 aj.DepthMode=Enum.
HighlightDepthMode.AlwaysOnTop aj.Parent=af function ae.update()local b,c,d=ab.
Visuals,ab.Aim,ad.origin2D()ag.Visible=b.ShowFov and c.Enabled ag.Size=UDim2.
fromOffset(c.FovRadius*2,c.FovRadius*2)ag.Position=UDim2.fromOffset(d.X,d.Y)ai.
Color=ac.Target and b.LockedColor or b.FovColor aj.OutlineColor=b.LockedColor
local e=(b.ShowTargetHighlight and ac.Target)and ac.Target.model or nil if aj.
Adornee~=e then aj.Adornee=e end end function ae.cleanup()pcall(af.Destroy,af)
end return ae end function a.k()local ab=a.cache.k if not ab then ab={c=aa()}a.
cache.k=ab end return ab.c end end do local aa=function()local aa,ab,ac,ad,ae,af
,ag=a.b(),a.a(),a.e(),{},setmetatable({},{__mode='k'}),(-math.huge)local ah=
function()if ag==nil then local ah,ai,aj=aa.ReplicatedStorage:FindFirstChild(ab.
Skins.Module),false if ah and ah:IsA'ModuleScript'then ai,aj=pcall(require,ah)
end if ai and type(aj)=='table'and type(aj.apply)=='function'and type(aj.
toolName)=='function'and type(aj.Skins)=='table'then ag=aj else ag=false end end
return ag or nil end function ad.list()local ai,aj,b=ah(),{},{}if ai then for c,
d in ipairs(ai.Skins)do if type(d)=='table'and type(d.id)=='string'and type(d.
name)=='string'then table.insert(aj,d.name)b[d.name]=d.id end end end return aj,
b end local ai=function(ai,aj,b)aj:SetAttribute('Skin',b)pcall(ai.apply,aj,aj.
Name,b)end function ad.restore()local aj=ah()for b,c in pairs(ae)do if aj and b.
Parent then ai(aj,b,c.skin)end ae[b]=nil end end function ad.tick(aj)local b=ab.
Skins if aj-af<b.Interval then return end af=aj if not b.Enabled or not b.Skin
then if next(ae)then ad.restore()end return end local c,d=ah(),ac.equippedTool()
if not(c and d and c.toolName(d.Name)and c.skin(b.Skin))then return end if d:
GetAttribute'Skin'~=b.Skin then if not ae[d]then ae[d]={skin=d:GetAttribute
'Skin'}end ai(c,d,b.Skin)end end return ad end function a.l()local ab=a.cache.l
if not ab then ab={c=aa()}a.cache.l=ab end return ab.c end end do local aa=
function()local aa,ab,ac,ad,ae=a.a(),a.c(),a.j(),a.l(),{}function ae.build()
local af=loadstring(game:HttpGet(aa.UiSource))()if type(aa.WindowIcon)=='string'
and aa.WindowIcon:find('rbxasset',1,true)then local ag=game:GetService
'ContentProvider'pcall(ag.PreloadAsync,ag,{aa.WindowIcon})end local ag=af:Window
{Name=aa.Name,Icon=aa.WindowIcon}local ah,ai=ag:Page{Icon='crosshair',Columns=2}
,ag:Page{Icon='eye',Columns=2}af:CreateSettingsPage(ag)local aj,b,c,d=function(
aj,b,c,d,e)return aj:Toggle{Name=b,Flag=c,Default=d,Callback=e}end,function(aj,b
,c,d,e,f,g,h,i)return aj:Slider{Name=b,Flag=c,Default=d,Min=e,Max=f,Decimals=g,
Suffix=h,Callback=i}end,function(aj,b,c,d,e,f)return aj:Dropdown{Name=b,Flag=c,
Default=d,Items=e,MaxSize=100,Callback=f}end,function(aj,b,c,d,e)return aj:
Label(b):Colorpicker{Flag=c,Default=d,Callback=e}end local e,f,g,h,i,j,k,l,m,n,o
=function(e,f,g,h,i)return aj(e,f,g,h[i],function(j)h[i]=j end)end,aa.Aim,aa.
Visuals,aa.NoSpread,aa.NoRecoil,aa.Esp,aa.FullBright,ah:Section{Name=
'Silent Aim',Icon='crosshair',Side=1},ah:Section{Name='Targets',Icon='users',
Side=1},ah:Section{Name='Field of View',Icon='circle',Side=2},ah:Section{Name=
'Weapon',Icon='target',Side=2}aj(l,'Enabled','SAEnabled',f.Enabled,function(p)f.
Enabled=p if not p then ab.Target=nil end end)c(l,'Aim Part','SAPart',f.
TargetPart,aa.PartModes,function(p)f.TargetPart=p end)b(l,'Hit Chance',
'SAHitChance',f.HitChance,0,100,1,'%',function(p)f.HitChance=p end)b(l,
'Max Distance','SAMaxDist',f.MaxDistance,50,2000,10,' studs',function(p)f.
MaxDistance=p end)e(l,'Visibility Check','SAVisible',f,'VisibleCheck')e(l,
'Prediction','SAPrediction',f,'Prediction')e(l,'Sticky Target','SASticky',f,
'StickyTarget')for p,q in ipairs(aa.Kinds)do e(m,q..'s','SA'..q..'s',f.Kinds,q)
end b(n,'Radius','SAFov',f.FovRadius,10,800,1,'px',function(p)f.FovRadius=p end)
e(n,'Show Circle','SAShowFov',g,'ShowFov')e(n,'Highlight Target','SAHighlight',g
,'ShowTargetHighlight')d(n,'Circle Color','SAFovColor',g.FovColor,function(p)g.
FovColor=p end)d(n,'Locked Color','SALockedColor',g.LockedColor,function(p)g.
LockedColor=p end)e(o,'No Spread','FXSpread',h,'Enabled')b(o,
'Pellet Spread Keep','FXPelletMult',h.PelletSpreadMult,0,1,0.05,'x',function(p)h
.PelletSpreadMult=p end)e(o,'No Recoil','FXRecoil',i,'Enabled')e(o,
'No Camera Shake','FXShake',i,'NoCameraShake')e(o,'No FOV Punch','FXFovPunch',i,
'NoFovPunch')local p,q,r,s=aa.Skins,ah:Section{Name='Skin Changer',Icon='brush',
Side=2},ad.list()local t=r[1]for u,v in pairs(s)do if v==p.Skin then t=u end end
p.Skin=t and s[t]or nil aj(q,'Enabled','SkinEnabled',p.Enabled,function(u)p.
Enabled=u end)if#r>0 then c(q,'Skin','SkinPick',t,r,function(u)if s[u]then p.
Skin=s[u]end end)end local u,v,w,x,y=ai:Section{Name='ESP',Icon='eye',Side=1},ai
:Section{Name='ESP Targets',Icon='users',Side=1},ai:Section{Name='Crates',Icon=
'package',Side=1},ai:Section{Name='World',Icon='sun',Side=2},ai:Section{Name=
'Colors',Icon='palette',Side=2}e(u,'Enabled','FXEsp',j,'Enabled')e(u,'Boxes',
'FXBoxes',j,'Boxes')e(u,'Skeleton','FXSkeleton',j,'Skeleton')e(u,'Tracers',
'FXTracers',j,'Tracers')e(u,'Look Direction','FXLook',j,'LookDirection')e(u,
'Names','FXNames',j,'Names')e(u,'Health','FXHealth',j,'Health')e(u,'Distance',
'FXDistance',j,'Distance')e(u,'Drop Marker','FXDrop',j,'DropMarker')e(u,
'Held Item','FXHeldItem',j,'HeldItem')e(u,'Status Tags','FXStatus',j,
'StatusTags')b(u,'Look Length','FXLookLen',j.LookLength,1,30,1,' studs',function
(z)j.LookLength=z end)b(u,'Max Distance','FXEspDist',j.MaxDistance,50,5000,10,
' studs',function(z)j.MaxDistance=z end)for z,A in ipairs(aa.Kinds)do e(v,A..'s'
,'FXEsp'..A..'s',j.Kinds,A)d(y,A..'s','FXCol'..A,j.Colors[A],function(B)j.Colors
[A]=B end)end d(y,'Drop Marker','FXColMarker',j.Colors.Marker,function(z)j.
Colors.Marker=z end)local z=aa.Crates e(w,'Enabled','CrateEsp',z,'Enabled')e(w,
'Military Crates','CrateMilitary',z.Kinds,'Military')e(w,'Food Crates',
'CrateFood',z.Kinds,'Food')e(w,'Regular Crates','CrateRegular',z.Kinds,'Regular'
)e(w,'Distance','CrateDistance',z,'Distance')b(w,'Max Distance','CrateMaxDist',z
.MaxDistance,50,3000,10,' studs',function(A)z.MaxDistance=A end)for A,B in
ipairs{'Military','Food','Regular'}do d(y,z.Labels[B],'CrateCol'..B,z.Colors[B],
function(C)z.Colors[B]=C end)end local A,B,C,D,E=aa.Events,aa.Traps,aa.CameraFov
,ai:Section{Name='Events',Icon='plane',Side=1},ai:Section{Name='Traps / Turrets'
,Icon='shield',Side=2}e(D,'Enabled','EvEsp',A,'Enabled')for F,G in ipairs{
'Airdrop','Heli','Bradley'}do e(D,A.Labels[G],'Ev'..G,A.Kinds,G)d(y,A.Labels[G],
'EvCol'..G,A.Colors[G],function(H)A.Colors[G]=H end)end e(D,'Distance',
'EvDistance',A,'Distance')b(D,'Max Distance','EvMaxDist',A.MaxDistance,100,10000
,50,' studs',function(F)A.MaxDistance=F end)e(E,'Enabled','TrapEsp',B,'Enabled')
for F,G in ipairs(B.Order)do e(E,B.Labels[G],'Trap'..G,B.Kinds,G)end e(E,
'Health','TrapHealth',B,'Health')e(E,'Distance','TrapDistance',B,'Distance')b(E,
'Max Distance','TrapMaxDist',B.MaxDistance,25,2000,5,' studs',function(F)B.
MaxDistance=F end)d(y,'Traps','TrapCol',B.Color,function(F)B.Color=F end)e(x,
'Camera FOV','FXCamFov',C,'Enabled')b(x,'FOV','FXCamFovValue',C.Value,30,120,1,
'\u{b0}',function(F)C.Value=F end)aj(x,'Full Bright','FXFullBright',k.Enabled,ac
.set)b(x,'Brightness','FXBrightness',k.Brightness,0,5,0.1,nil,function(F)k.
Brightness=F end)b(x,'Clock Time','FXClock',k.ClockTime,0,24,0.5,'h',function(F)
k.ClockTime=F end)e(x,'No Fog','FXNoFog',k,'NoFog')e(x,'No Shadows',
'FXNoShadows',k,'NoShadows')e(x,'No Atmosphere','FXNoAtm',k,'NoAtmosphere')d(x,
'Ambient','FXAmbient',k.Ambient,function(F)k.Ambient=F k.OutdoorAmbient=F end)
return af end function ae.destroy(af)if type(af)=='table'and type(af.Unload)==
'function'then pcall(af.Unload,af)end end return ae end function a.m()local ab=a
.cache.m if not ab then ab={c=aa()}a.cache.m=ab end return ab.c end end do local
aa=function()local aa,ab,ac,ad,ae,af,ag,ah,ai,aj,b,c=a.b(),a.a(),a.c(),a.d(),a.
f(),a.g(),a.h(),a.i(),a.j(),a.k(),a.l(),a.m()local d,e=aa.RunService,aa.Players.
LocalPlayer return function()if game.PlaceVersion~=ab.Build.PlaceVersion then ac
.BuildMismatch={measured=ab.Build.PlaceVersion,current=game.PlaceVersion}end
local f local g,h,i,j=function()if not ac.Loaded then return end ac.Loaded=false
for g,h in ipairs(ac.Connections)do pcall(h.Disconnect,h)end table.clear(ac.
Connections)pcall(d.UnbindFromRenderStep,d,ai.BIND)af.cleanup()ag.restoreAll()ai
.restore()ai.restoreFov()b.restore()ah.cleanup()aj.cleanup()c.destroy(f and f.
Library)getgenv()[ab.Name]=nil end,function()local g=os.clock()ae.refresh(g)if
not ab.Aim.Enabled then ac.Target=nil elseif g-ac.SelectAt>=ab.Perf.
TargetSelectInterval then ac.SelectAt=g ac.Target=af.selectTarget()end aj.
update()ah.draw(g)end,function()af.installWrapper()ag.tick(os.clock())b.tick(os.
clock())end,function(g)ac.connect(g.ChildAdded,function(h)if h:IsA'Tool'then ag.
queueRescan()end end)end af.installWrapper()ag.scanClosures()ag.apply()if e.
Character then j(e.Character)end ac.connect(e.CharacterAdded,j)ac.connect(d.
RenderStepped,ac.guarded('render',h))ac.connect(d.Heartbeat,ac.guarded(
'heartbeat',i))d:BindToRenderStep(ai.BIND,Enum.RenderPriority.Last.Value+1,ac.
guarded('fullbright',ai.enforce))f={Config=ab,State=ac,SelectTarget=af.
selectTarget,SetFullBright=ai.set,Unload=g,Math=ad}getgenv()[ab.Name]=f if ab.
LoadUi then local k,l=pcall(c.build)if k then f.Library=l else ac.Errors.ui={
message=tostring(l),at=os.clock()}end end end end function a.n()local ab=a.cache
.n if not ab then ab={c=aa()}a.cache.n=ab end return ab.c end end end local aa=a
.a()local ab=getgenv()[aa.Name]if ab and ab.Unload then pcall(ab.Unload)end
local ac=a.n()ac()
