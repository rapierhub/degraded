local a={cache={}}do do local b=function()return{Builds={[13622622708]=319,[
5468388011]=391},Native={ReplicatorModule='ReplicatorService',BulletModule=
'BulletService',FirearmModule='FirearmInventory',ControllerModule=
'CharacterController',ClientModule='ClientService',StandingHeightState=0,
ActorAttribute='ActorUID',ProtectedTag='PreventPlayerFire',SurrenderEmote=
'Surrender',BulletCollisionGroup='9',Gravity=32.2,RootToHeadTop=4,RootToFeet=0.9
,NpcLabel='NPC',NpcItemPrefix='^AI_',HealthScale=100},Aim={Enabled=true,
FovRadius=150,TargetPart='Head',ClosestParts={'Head','UpperTorso','LowerTorso'},
MaxDistance=1500,VisibleCheck=true,TeamCheck=true,SkipPassive=true,Prediction=
true,MaxTargetSpeed=80,HitChance=100,Kinds={NPC=true,Player=false}},Esp={Enabled
=true,Kinds={NPC=true,Player=true},TeamCheck=false,ShowPassive=true,Boxes=true,
Names=true,Health=false,Distance=true,HeldItem=true,Tracers=false,Skeleton=false
,MaxDistance=1500,Colors={NPC=Color3.fromRGB(255,70,70),Passive=Color3.fromRGB(
255,210,70),Player=Color3.fromRGB(255,140,60),Team=Color3.fromRGB(80,170,255)}},
Movement={Fly=false,FlySpeed=40,FlyKey=Enum.KeyCode.F4,FlyUpKey=Enum.KeyCode.
Space,FlyDownKey=Enum.KeyCode.LeftControl,Speed=false,SpeedMultiplier=1.5,
SprintFire=true},Visuals={ShowFov=true,ShowTargetHighlight=true,FovColor=Color3.
fromRGB(255,255,255),LockedColor=Color3.fromRGB(255,80,80)},Perf={EntityInterval
=0.15,TargetSelectInterval=0.05,ResolveInterval=2,MaxActors=2000},Name=
'Pandemonium',WindowIcon='rbxassetid://132509022802512',LoadUi=true,UiSource=
[[https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee]],
PartModes={'Head','UpperTorso','LowerTorso','Closest'}}end function a.a()local c
=a.cache.a if not c then c={c=b()}a.cache.a=c end return c.c end end do local b=
function()return{Players=game:GetService'Players',RunService=game:GetService
'RunService',UserInputService=game:GetService'UserInputService'}end function a.b
()local c=a.cache.b if not c then c={c=b()}a.cache.b=c end return c.c end end do
local b=function()local b={Loaded=true,Connections={},Errors={},BuildMismatch=
nil,Target=nil,SelectAt=-math.huge,Stats={Shots=0,Redirected=0},LastRedirectAt=-
math.huge,Entities={},EntitiesAt=-math.huge,EntitiesGen=0}function b.connect(c,d
)local e=c:Connect(d)table.insert(b.Connections,e)return e end function b.
guarded(c,d)return function(...)local e,f=xpcall(d,debug.traceback,...)if not e
then b.Errors[c]={message=tostring(f),at=os.clock()}end end end return b end
function a.c()local c=a.cache.c if not c then c={c=b()}a.cache.c=c end return c.
c end end do local b=function()local b,c,d,e,f,g,h,i,j,k=a.a(),a.c(),{Replicator
=nil,Bullets=nil,Firearm=nil,Controller=nil,Clients=nil,ResolvedAt=-math.huge},{
'Replicator','Bullets','Firearm','Controller','Clients'},function(b,c)for d,e in
ipairs(getloadedmodules())do if e.Name==b then local f,g=pcall(require,e)if f
and type(g)=='table'and c(g)then return g end end end return nil end,function(b)
return type(rawget(b,'Actors'))=='table'and type(b.GetFromBodyPart)=='function'
end,function(b)return type(b.GetInfo)=='function'and type(b.Discharge)==
'function'end,function(b)return type(rawget(b,'Discharge'))=='function'and type(
rawget(b,'GetMuzzleCFrame'))=='function'and not table.isfrozen(b)end,function(b)
return type(rawget(b,'Update'))=='function'and type(rawget(b,'_accelerate'))==
'function'and not table.isfrozen(b)end,function(b)return type(rawget(b,'Clients'
))=='table'end function d.complete()for l,m in ipairs(e)do if not d[m]then
return false end end return true end function d.aimReady()return d.Replicator~=
nil and d.Bullets~=nil and d.Firearm~=nil end function d.resolve(l)if d.
complete()or l-d.ResolvedAt<b.Perf.ResolveInterval then return end d.ResolvedAt=
l local m=b.Native d.Replicator=d.Replicator or f(m.ReplicatorModule,g)d.Bullets
=d.Bullets or f(m.BulletModule,h)d.Firearm=d.Firearm or f(m.FirearmModule,i)d.
Controller=d.Controller or f(m.ControllerModule,j)d.Clients=d.Clients or f(m.
ClientModule,k)local n={}for o,p in ipairs(e)do if not d[p]then table.insert(n,p
)end end c.Errors.native=#n>0 and{message='unresolved: '..table.concat(n,', '),
at=l}or nil end return d end function a.d()local c=a.cache.d if not c then c={c=
b()}a.cache.d=c end return c.c end end do local b=function()local b,c,d,e,f=a.a(
),a.c(),a.d(),{},function(b)return typeof(b)=='Vector3'and b.X==b.X and b.Y==b.Y
and b.Z==b.Z and math.abs(b.X)<1e6 and math.abs(b.Y)<1e6 and math.abs(b.Z)<1e6
end e.finiteVector=f function e.refresh(g)if g-c.EntitiesAt<b.Perf.
EntityInterval then return end c.EntitiesAt=g local h,i={},d.Replicator if i
then local j,k=rawget(i,'_uid'),0 for l,m in pairs(i.Actors)do k=k+1 if k>b.Perf
.MaxActors then break end if type(m)=='table'and type(l)=='string'and l~=j and m
.IsLocalPlayer~=true then local n=m.Owner local o=typeof(n)=='Instance'and n:IsA
'Player'table.insert(h,{actor=m,uid=l,kind=o and'Player'or'NPC',label=o and n.
DisplayName or b.Native.NpcLabel,player=o and n or nil})end end end c.Entities=h
c.EntitiesGen=c.EntitiesGen+1 end function e.alive(g)local h=d.Replicator return
h~=nil and h.Actors[g.uid]==g.actor and g.actor.Alive==true end function e.
isTeammate(g)local h=d.Clients if not(h and g.player)then return false end local
i,j=h.LocalClient,h.Clients[g.player]local k=type(i)=='table'and i.Squad return
type(k)=='string'and k~=''and type(j)=='table'and j.Squad==k end function e.
position(g)local h=g.actor local i=h.UseClient and h.Position or h.
ServerPosition return f(i)and i or nil end function e.loaded(g)local h=g.actor.
Character if typeof(h)=='Instance'and h:IsDescendantOf(workspace)then return h
end return nil end function e.passive(g)local h=g.actor if h.Downed==true or h.
_ziptiedHostage~=nil then return true end local i=h.CurrentState if type(i)==
'table'and(i.Hostage or i.Emote==b.Native.SurrenderEmote)then return true end
local j=h.Character return typeof(j)=='Instance'and j:HasTag(b.Native.
ProtectedTag)end function e.health(g)local h=tonumber(g.actor.Health)return h
and h==h and h or nil end function e.heldItem(g)local h=g.actor local i,j=h.
_inventory,h._equipped local k=type(i)=='table'and j~=nil and i[j]local l=type(k
)=='table'and k._firearm local m=type(l)=='table'and l.Name if type(m)~='string'
or m==''then return nil end return(m:gsub(b.Native.NpcItemPrefix,''))end
function e.ownerOf(g)local h=g:GetAttribute(b.Native.ActorAttribute)return type(
h)=='string'and h or nil end function e.rayParams()local g=RaycastParams.new()g.
FilterType=Enum.RaycastFilterType.Exclude g.CollisionGroup=b.Native.
BulletCollisionGroup local h,i={workspace.CurrentCamera},d.Replicator local j=i
and i.LocalActor local k=type(j)=='table'and j.Character if typeof(k)==
'Instance'then table.insert(h,k)end g.FilterDescendantsInstances=h return g end
return e end function a.e()local c=a.cache.e if not c then c={c=b()}a.cache.e=c
end return c.c end end do local b=function()local b={}function b.finite(c)return
type(c)=='number'and c==c and math.abs(c)<1e9 end function b.launchAngle(c,d,e,f
)if c<1e-3 then return d>=0 and math.pi/2 or-math.pi/2,math.abs(d)/e end local g
=e*e local h=g*g-f*(f*c*c+2*d*g)if h<0 then return nil end local i=math.atan((g-
math.sqrt(h))/(f*c))return i,c/(e*math.cos(i))end function b.solve(c,d,e,f,g,h,i
,j,k,l,m,n)local o,p,q,r,s=f,g,h for t=1,n do local u,v=o-c,q-e r,s=b.
launchAngle(math.sqrt(u*u+v*v),p-d,l,m)if not r then return nil end if t<n then
o,p,q=f+i*s,g+j*s,h+k*s end end return r,math.atan2(-(o-c),-(q-e)),s end
function b.zeroAngle(c,d,e)local f=c*e/(d*d)if f~=f or math.abs(f)>1 then return
0 end return math.asin(f)*0.5 end return b end function a.f()local c=a.cache.f
if not c then c={c=b()}a.cache.f=c end return c.c end end do local b=function()
local b,c,d,e,f,g=a.b(),a.a(),a.c(),a.f(),a.d(),a.e()local h,i,j,k,l,m,n,o,p,q,r
,s=b.UserInputService,workspace.CurrentCamera,{},false,-1,(setmetatable({},{
__mode='k'}))function j.origin2D()if h.MouseBehavior==Enum.MouseBehavior.
LockCenter then return i.ViewportSize/2 end return h:GetMouseLocation()end local
t,u=function(t,u)local v,w=i:WorldToViewportPoint(t)if not w or v.Z<=0 then
return math.huge end return(Vector2.new(v.X,v.Y)-u).Magnitude end,function(t,u)
local v=t:FindFirstChild(u)return v and v:IsA'BasePart'and v or nil end j.part=u
local v,w,x=function(v,w,x)if not c.Aim.VisibleCheck then return true end if s==
nil or l~=d.EntitiesGen then s=g.rayParams()l=d.EntitiesGen end x=x or i.CFrame.
Position local y=workspace:Raycast(x,w.Position-x,s)return y==nil or g.ownerOf(y
.Instance)==v.uid end,function(v,w)local x=c.Aim if x.TargetPart~='Closest'then
local y=u(v,x.TargetPart)or u(v,'UpperTorso')return y,y and t(y.Position,w)or
math.huge end local y,z=(math.huge)for A,B in ipairs(x.ClosestParts)do local C=
u(v,B)if C then local D=t(C.Position,w)if D<y then z,y=C,D end end end return z,
y end,function(v)local w=c.Aim return w.Kinds[v.kind]==true and g.alive(v)and
not(w.TeamCheck and g.isTeammate(v))and not(w.SkipPassive and g.passive(v))end
local y=function(y,z)if not y or not y.part.Parent or not x(y.entity)or g.
loaded(y.entity)==nil then return false end if(y.part.Position-i.CFrame.Position
).Magnitude>c.Aim.MaxDistance then return false end return t(y.part.Position,z)
<=c.Aim.FovRadius and v(y.entity,y.part)end function j.selectTarget()local z,A,B
,C,D=c.Aim,j.origin2D(),i.CFrame.Position,(math.huge)for E,F in ipairs(d.
Entities)do local G=x(F)and g.loaded(F)if G then local H,I=w(G,A)if H and I<=z.
FovRadius and I<C and(H.Position-B).Magnitude<=z.MaxDistance then if not v(F,H)
then H=nil for J,K in ipairs(z.ClosestParts)do local L=u(G,K)if L and v(F,L)then
H=L break end end end if H then D,C={entity=F,part=H},I end end end end return D
end function j.track(z)local A=d.Target if not A then return end local B=g.
position(A.entity)if not B then return end local C=m[A.entity.actor]if not C
then m[A.entity.actor]={pos=B,at=z,velocity=Vector3.zero}return end local D=z-C.
at if D<0.05 then return end local E=D>0.5 and Vector3.zero or(B-C.pos)/D if E.
Magnitude>c.Aim.MaxTargetSpeed then E=Vector3.zero end C.velocity=C.velocity:
Lerp(E,0.5)C.pos=B C.at=z end local z,A=function(z,A)local B=m[z.actor]if not(c.
Aim.Prediction and B)or A-B.at>0.5 then return Vector3.zero end return B.
velocity end,function()local z,A=c.Aim,d.Target if not y(A,j.origin2D())then A=j
.selectTarget()end if not A or(z.HitChance<100 and math.random()*100>=z.
HitChance)then return nil end return A end local B=function(B,C)local D,E=f.
Bullets,type(B._firearm)=='table'and B._firearm.Tune if not(D and type(E)==
'table')then return nil end local F,G,H=D:GetInfo(E.Caliber,E.Barrel)if not(e.
finite(F)and F>1)then return nil end local I=A()if not I then return nil end
local J,K=C.Position,I.part.Position if not(g.finiteVector(J)and g.finiteVector(
K))then return nil end local L=(K-J).Magnitude if L<0.5 or(e.finite(H)and H>0
and L>H)then return nil end if not v(I.entity,I.part,J)then return nil end local
M,N=z(I.entity,os.clock()),c.Native.Gravity local O,P=e.solve(J.X,J.Y,J.Z,K.X,K.
Y,K.Z,M.X,M.Y,M.Z,F,N,3)if not O then return nil end local Q=B._actor local R=
type(Q)=='table'and Q.ADS and Q.ViewModel local S=type(R)=='table'and R.Zero if
type(S)=='table'then S=S[4]end if e.finite(S)then O=O-e.zeroAngle(S,F,N)end
return CFrame.new(J)*CFrame.fromOrientation(O,P,0)end function j.install()local
C=f.Firearm if k or not C then return k end n=C.Discharge o=C.GetMuzzleCFrame p=
function(D,...)local E=r r=D local F=table.pack(pcall(n,D,...))r=E if not F[1]
then error(F[2],0)end return table.unpack(F,2,F.n)end q=function(D,...)local E=
table.pack(o(D,...))if r==D and d.Loaded and c.Aim.Enabled and typeof(E[1])==
'CFrame'then d.Stats.Shots=d.Stats.Shots+1 local F,G=pcall(B,D,E[1])if F and G
then d.Stats.Redirected=d.Stats.Redirected+1 d.LastRedirectAt=os.clock()E[1]=G
elseif not F then d.Errors.silentAim={message=tostring(G),at=os.clock()}end end
return table.unpack(E,1,E.n)end C.Discharge=p C.GetMuzzleCFrame=q k=true return
true end function j.cleanup()local C=f.Firearm if not(k and C)then return end if
C.Discharge==p then C.Discharge=n end if C.GetMuzzleCFrame==q then C.
GetMuzzleCFrame=o end k=false end return j end function a.g()local c=a.cache.g
if not c then c={c=b()}a.cache.g=c end return c.c end end do local b=function()
local b,c,d,e,f=a.b(),a.a(),a.c(),a.d(),a.e()local g,h,i,j,k,l=b.
UserInputService,{},{installed=false},{installed=false},function(g)local h=g.
_localActor if type(h)~='table'or h.Alive~=true or h.Downed then return false
end if h.Seat or h.OldSeat or h.Rappelling or h.Ladder or g._startPhysics then
return false end local i=h.CurrentState return not(type(i)=='table'and i.Dragged
)end local m=function(m,n,o)local p,q,r,s=c.Movement,m._localActor,m._position,m
._groundHitbox if typeof(s)=='Instance'and s:IsA'BasePart'then r=s.CFrame:
PointToWorldSpace(r)end if not f.finiteVector(r)then error(
'controller position is not a finite Vector3',0)end local t=workspace.
CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(n.X,0,n.Y))if g:
GetFocusedTextBox()==nil then if g:IsKeyDown(p.FlyUpKey)then t=t+Vector3.yAxis
end if g:IsKeyDown(p.FlyDownKey)then t=t-Vector3.yAxis end end if t.Magnitude>1
then t=t.Unit end local u=r+t*p.FlySpeed*math.clamp(o,0,0.1)if not f.
finiteVector(u)then error('fly target is not a finite Vector3',0)end local v=c.
Native.StandingHeightState m._position=u m._lastSafePosition=u m._groundHitbox=
nil m._groundTimer=nil m.VelocityGravity=0 m.MoveSpeed=0 m.IsGrounded=false m.
IsSliding=false m.IsSprinting=false m.HeightState=v m._lastMovement=n q.
HeightState=v q.Platform=nil q.Grounded=true q.Sliding=false q.Sprinting=false q
.SimulatedPosition=u end local n,o=function()local n=e.Controller if i.installed
or not n then return end i.update=n.Update i.accelerate=n._accelerate i.
updateWrapper=function(o,p,q,...)local r=c.Movement if d.Loaded and r.Fly and
typeof(p)=='Vector2'and type(q)=='number'and k(o)then local s,t=pcall(m,o,p,q)if
s then return end d.Errors.fly={message=tostring(t),at=os.clock()}end local s=
table.pack(i.update(o,p,q,...))if d.Loaded and r.SprintFire and l and l._active
then local t=o._localActor if type(t)=='table'then t.Sprinting=false end end
return table.unpack(s,1,s.n)end i.accelerateWrapper=function(o,p,...)local q,r=c
.Movement,o._weightMulti local s=q.SpeedMultiplier if not(d.Loaded and q.Speed
and type(r)=='number'and type(p)=='number'and type(s)=='number'and s>0 and s~=1)
then return i.accelerate(o,p,...)end o._weightMulti=r*s local t=table.pack(
pcall(i.accelerate,o,p*s,...))o._weightMulti=r if not t[1]then error(t[2],0)end
return table.unpack(t,2,t.n)end n.Update=i.updateWrapper n._accelerate=i.
accelerateWrapper i.installed=true end,function()local n=e.Firearm if j.
installed or not n or type(rawget(n,'_discharge'))~='function'then return end j.
discharge=n._discharge j.wrapper=function(o,p,...)l=p and o or nil if p and d.
Loaded and c.Movement.SprintFire then local q=o._actor if type(q)=='table'then q
.Sprinting=false end end return j.discharge(o,p,...)end n._discharge=j.wrapper j
.installed=true end function h.install()n()o()end function h.cleanup()local p,q=
e.Controller,e.Firearm if i.installed and p then if p.Update==i.updateWrapper
then p.Update=i.update end if p._accelerate==i.accelerateWrapper then p.
_accelerate=i.accelerate end i.installed=false end if j.installed and q then if
q._discharge==j.wrapper then q._discharge=j.discharge end j.installed=false end
l=nil end return h end function a.h()local c=a.cache.h if not c then c={c=b()}a.
cache.h=c end return c.c end end do local b=function()local b,c,d,e,f,g,h,i,j,k,
l,m,n,o,p,q=a.a(),a.c(),a.e(),a.g(),workspace.CurrentCamera,{},Color3.fromRGB(
255,60,60),Color3.fromRGB(60,255,90),200,0.9,0.12,0.45,{{'Head','UpperTorso'},{
'UpperTorso','LowerTorso'},{'UpperTorso','LeftUpperArm'},{'LeftUpperArm',
'LeftLowerArm'},{'LeftLowerArm','LeftHand'},{'UpperTorso','RightUpperArm'},{
'RightUpperArm','RightLowerArm'},{'RightLowerArm','RightHand'},{'LowerTorso',
'LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{
'LowerTorso','RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg'
,'RightFoot'}},{'Head','UpperTorso','LowerTorso','LeftHand','RightHand',
'LeftFoot','RightFoot','LeftLowerArm','RightLowerArm'},{},-1 local r,s,t,u,v=
function(r)local s=f:WorldToViewportPoint(r)return s.X,s.Y,s.Z end,function(r,s)
local t=Drawing.new(r)for u,v in pairs(s)do t[u]=v end t.Visible=false return{d=
t,shown=false}end,function(r,s)if r.shown~=s then r.shown=s r.d.Visible=s end
end,function(r,s,t)if r[s]~=t then r[s]=t r.d[s]=t end end,function(r)if r then
pcall(r.d.Remove,r.d)end end local w,x=function()return{box=s('Square',{
Thickness=1.5,Filled=false}),name=s('Text',{Size=13,Center=true,Outline=true}),
info=s('Text',{Size=12,Center=true,Outline=true}),hpBack=s('Square',{Filled=true
,Color=Color3.new(0,0,0),Transparency=0.6}),hpFill=s('Square',{Filled=true}),
hpText=s('Text',{Size=11,Center=false,Outline=true}),tracer=nil,bones=nil,
visible=false}end,function(w,x)x(w.box)x(w.name)x(w.info)x(w.hpBack)x(w.hpFill)
x(w.hpText)if w.tracer then x(w.tracer)end if w.bones then for y,z in ipairs(w.
bones)do x(z)end end end local y,z,A,B,C,D=function(y)if y and y.visible then y.
visible=false x(y,function(z)t(z,false)end)end end,function(y)local z=p[y]if z
then x(z,v)p[y]=nil end end,function(y)local z=y:FindFirstChild'Head'if not(z
and z:IsA'BasePart')then return nil end local A,B,C,D,E=math.huge,math.huge,-
math.huge,-math.huge,0 local F=function(F)local G,H,I=r(F)if I<=0 then return
false end A,B,C,D=math.min(A,G),math.min(B,H),math.max(C,G),math.max(D,H)return
true end if not F(z.Position+Vector3.yAxis*k)then return nil end for G,H in
ipairs(o)do local I=y:FindFirstChild(H)if I and I:IsA'BasePart'then if not F(I.
Position)then return nil end E=E+1 end end if E<3 then return nil end local G,H=
(C-A)*l+2,(D-B)*l*0.5 return A-G,B-H,C+G,D+H end,function(y)local z=b.Native
local A,B,C=r(y+Vector3.yAxis*z.RootToHeadTop)local D,E,F=r(y-Vector3.yAxis*z.
RootToFeet)if C<=0 or F<=0 then return nil end local G,H=math.min(B,E),math.max(
B,E)local I,J=math.max((H-G)*m*0.5,1.5),(A+D)*0.5 return J-I,G,J+I,H end,
function(y,z,A)if not y.bones then y.bones={}for B=1,#n do y.bones[B]=s('Line',{
Thickness=1})end end for B,C in ipairs(n)do local D,E,F,G=y.bones[B],e.part(z,C[
1]),e.part(z,C[2]),false if E and F then local H,I,J=r(E.Position)local K,L,M=r(
F.Position)if J>0 and M>0 then D.d.From=Vector2.new(H,I)D.d.To=Vector2.new(K,L)
u(D,'Color',A)G=true end end t(D,G)end end,function(y)if y.bones then for z,A in
ipairs(y.bones)do t(A,false)end end end local E=function(E,F,G,H,I)local J,K=b.
Esp,E.actor local L,M=p[K],d.position(E)local N=M and(M-H).Magnitude if not M or
N>J.MaxDistance then y(L)return end local O,P,Q,R,S=(d.loaded(E))if O then P,Q,R
,S=A(O)end if not P then O=nil P,Q,R,S=B(M)end if not P or R<-j or S<-j or P>I.X
+j or Q>I.Y+j then y(L)return end if not L then L=w()p[K]=L end L.visible=true
local T=F and J.Colors.Passive or G and J.Colors.Team or J.Colors[E.kind]t(L.box
,J.Boxes)if J.Boxes then u(L.box,'Color',T)L.box.d.Position=Vector2.new(P,Q)L.
box.d.Size=Vector2.new(R-P,S-Q)end t(L.name,J.Names)if J.Names then u(L.name,
'Text',J.Distance and('%s [%d]'):format(E.label,math.floor(N+0.5))or E.label)u(L
.name,'Color',T)L.name.d.Position=Vector2.new((P+R)*0.5,Q-16)end local U=J.
HeldItem and d.heldItem(E)or nil t(L.info,U~=nil)if U then u(L.info,'Text',U)u(L
.info,'Color',T)L.info.d.Position=Vector2.new((P+R)*0.5,S+2)end local V=J.Health
and d.health(E)or nil local W=V~=nil t(L.hpBack,W)t(L.hpFill,W)t(L.hpText,W)if V
then local X,Y=math.clamp(V/b.Native.HealthScale,0,1),S-Q local Z=h:Lerp(i,X)L.
hpBack.d.Position=Vector2.new(P-6,Q)L.hpBack.d.Size=Vector2.new(3,Y)u(L.hpFill,
'Color',Z)L.hpFill.d.Position=Vector2.new(P-6,Q+Y*(1-X))L.hpFill.d.Size=Vector2.
new(3,Y*X)u(L.hpText,'Text',tostring(math.floor(V+0.5)))u(L.hpText,'Color',Z)
local _=L.hpText.d.TextBounds L.hpText.d.Position=Vector2.new(P-9-(_ and _.X or
0),Q+Y*(1-X)-6)end if J.Tracers then if not L.tracer then L.tracer=s('Line',{
Thickness=1})end t(L.tracer,true)u(L.tracer,'Color',T)L.tracer.d.From=Vector2.
new(I.X*0.5,I.Y)L.tracer.d.To=Vector2.new((P+R)*0.5,S)elseif L.tracer then t(L.
tracer,false)end if J.Skeleton and O then C(L,O,T)else D(L)end end function g.
draw()local F,G,H,I=b.Esp,f.CFrame.Position,f.ViewportSize,q~=c.EntitiesGen and{
}or nil for J,K in ipairs(c.Entities)do if I then I[K.actor]=true end local L=F.
Enabled and F.Kinds[K.kind]==true and d.alive(K)local M,N=L and d.passive(K),L
and d.isTeammate(K)if L and not(M and not F.ShowPassive)and not(N and F.
TeamCheck)then E(K,M,N,G,H)else y(p[K.actor])end end if I then q=c.EntitiesGen
for J in pairs(p)do if not I[J]then z(J)end end end end function g.cleanup()for
F in pairs(p)do z(F)end end return g end function a.i()local c=a.cache.i if not
c then c={c=b()}a.cache.i=c end return c.c end end do local b=function()local b,
c,d,e,f,g=a.a(),a.c(),a.e(),a.g(),{},Drawing.new'Circle'g.Thickness=1.5 g.
NumSides=64 g.Filled=false g.Transparency=0.8 g.Visible=false local h=Instance.
new'Highlight'h.FillTransparency=1 h.DepthMode=Enum.HighlightDepthMode.
AlwaysOnTop h.OutlineColor=b.Visuals.LockedColor local i h.Parent=(gethui and
gethui())or game:GetService'CoreGui'function f.update()local j,k=b.Visuals,b.Aim
local l=j.ShowFov and k.Enabled g.Visible=l if l then g.Position=e.origin2D()g.
Radius=k.FovRadius g.Color=c.Target and j.LockedColor or j.FovColor end local m=
(j.ShowTargetHighlight and c.Target)and d.loaded(c.Target.entity)or nil if i~=m
then i=m pcall(function()h.OutlineColor=j.LockedColor h.Adornee=m end)end end
function f.cleanup()pcall(g.Remove,g)pcall(h.Destroy,h)end return f end function
a.j()local c=a.cache.j if not c then c={c=b()}a.cache.j=c end return c.c end end
do local b=function()local b,c,d=a.a(),a.c(),{}function d.build()local e=
loadstring(game:HttpGet(b.UiSource))()local f=e:Window{Name=b.Name,Icon=b.
WindowIcon}local g,h,i=f:Page{Icon='crosshair',Columns=2},f:Page{Icon='eye',
Columns=2},f:Page{Icon='wind',Columns=2}e:CreateSettingsPage(f)local j,k,l,m=
function(j,k,l,m,n)return j:Toggle{Name=k,Flag=l,Default=m,Callback=n}end,
function(j,k,l,m,n,o,p,q,r)return j:Slider{Name=k,Flag=l,Default=m,Min=n,Max=o,
Decimals=p,Suffix=q,Callback=r}end,function(j,k,l,m,n,o)return j:Dropdown{Name=k
,Flag=l,Default=m,Items=n,MaxSize=100,Callback=o}end,function(j,k,l,m,n)return j
:Label(k):Colorpicker{Flag=l,Default=m,Callback=n}end local n,o,p,q,r,s=function
(n,o,p,q,r)return j(n,o,p,q[r],function(s)q[r]=s end)end,b.Aim,b.Visuals,b.Esp,g
:Section{Name='Silent Aim',Icon='crosshair',Side=1},g:Section{Name=
'Field of View',Icon='circle',Side=2}j(r,'Enabled','SAEnabled',o.Enabled,
function(t)o.Enabled=t if not t then c.Target=nil end end)l(r,'Aim Part',
'SAPart',o.TargetPart,b.PartModes,function(t)o.TargetPart=t end)k(r,'Hit Chance'
,'SAHitChance',o.HitChance,0,100,1,'%',function(t)o.HitChance=t end)k(r,
'Max Distance','SAMaxDist',o.MaxDistance,50,3000,10,' studs',function(t)o.
MaxDistance=t end)n(r,'Visibility Check','SAVisible',o,'VisibleCheck')n(r,
'Team Check','SATeam',o,'TeamCheck')n(r,'Lead Moving Targets','SAPrediction',o,
'Prediction')n(r,'Skip Hostages / Surrendered','SAPassive',o,'SkipPassive')n(r,
'Target NPCs','SANpc',o.Kinds,'NPC')n(r,'Target Players','SAPlayer',o.Kinds,
'Player')k(s,'Radius','SAFov',o.FovRadius,10,800,1,'px',function(t)o.FovRadius=t
end)n(s,'Show Circle','SAShowFov',p,'ShowFov')n(s,'Highlight Target',
'SAHighlight',p,'ShowTargetHighlight')m(s,'Circle Color','SAFovColor',p.FovColor
,function(t)p.FovColor=t end)m(s,'Locked Color','SALockedColor',p.LockedColor,
function(t)p.LockedColor=t end)local t,u=h:Section{Name='ESP',Icon='eye',Side=1}
,h:Section{Name='Colors',Icon='palette',Side=2}n(t,'Enabled','FXEsp',q,'Enabled'
)n(t,'NPCs','FXNpc',q.Kinds,'NPC')n(t,'Players','FXPlayer',q.Kinds,'Player')n(t,
'Hide Teammates','FXTeam',q,'TeamCheck')n(t,'Hostages / Surrendered','FXPassive'
,q,'ShowPassive')n(t,'Boxes','FXBoxes',q,'Boxes')n(t,'Skeleton','FXSkeleton',q,
'Skeleton')n(t,'Tracers','FXTracers',q,'Tracers')n(t,'Names','FXNames',q,'Names'
)n(t,'Health','FXHealth',q,'Health')n(t,'Distance','FXDistance',q,'Distance')n(t
,'Held Weapon','FXHeldItem',q,'HeldItem')k(t,'Max Distance','FXEspDist',q.
MaxDistance,50,7000,10,' studs',function(v)q.MaxDistance=v end)m(u,'NPCs',
'FXColNpc',q.Colors.NPC,function(v)q.Colors.NPC=v end)m(u,
'Hostages / Surrendered','FXColPassive',q.Colors.Passive,function(v)q.Colors.
Passive=v end)m(u,'Players','FXColPlayer',q.Colors.Player,function(v)q.Colors.
Player=v end)m(u,'Teammates','FXColTeam',q.Colors.Team,function(v)q.Colors.Team=
v end)local v,w,x=b.Movement,i:Section{Name='Fly',Icon='plane',Side=1},i:Section
{Name='Ground',Icon='zap',Side=2}n(w,'Enabled','MVFly',v,'Fly')pcall(function()w
:Label'Toggle Key':Keybind{Flag='MVFlyKey',Default=v.FlyKey,Mode='Toggle',
Callback=function(y)v.Fly=y==true end}end)k(w,'Speed','MVFlySpeed',v.FlySpeed,5,
300,1,' studs/s',function(y)v.FlySpeed=y end)n(x,'Speed Multiplier','MVSpeed',v,
'Speed')k(x,'Multiplier','MVSpeedMult',v.SpeedMultiplier,1,10,0.1,'x',function(y
)v.SpeedMultiplier=y end)n(x,'Shoot While Sprinting','MVSprintFire',v,
'SprintFire')return e end function d.destroy(e)if type(e)=='table'and type(e.
Unload)=='function'then pcall(e.Unload,e)end end return d end function a.k()
local c=a.cache.k if not c then c={c=b()}a.cache.k=c end return c.c end end do
local b=function()local b,c,d,e,f,g,h,i,j,k=a.b(),a.a(),a.c(),a.d(),a.e(),a.g(),
a.h(),a.i(),a.j(),a.k()local l=b.RunService return function()local m=c.Builds[
game.PlaceId]if m~=game.PlaceVersion then d.BuildMismatch={place=game.PlaceId,
measured=m,current=game.PlaceVersion}end local n local o,p=function()if not d.
Loaded then return end d.Loaded=false for o,p in ipairs(d.Connections)do pcall(p
.Disconnect,p)end table.clear(d.Connections)g.cleanup()h.cleanup()i.cleanup()j.
cleanup()k.destroy(n and n.Library)getgenv()[c.Name]=nil end,function()local o=
os.clock()e.resolve(o)if e.aimReady()then g.install()end h.install()f.refresh(o)
if not c.Aim.Enabled then d.Target=nil elseif o-d.SelectAt>=c.Perf.
TargetSelectInterval then d.SelectAt=o d.Target=g.selectTarget()end g.track(o)j.
update()i.draw()end d.connect(l.RenderStepped,d.guarded('render',p))n={Config=c,
State=d,Native=e,SelectTarget=g.selectTarget,Unload=o}getgenv()[c.Name]=n if c.
LoadUi then local q,r=pcall(k.build)if q then n.Library=r else d.Errors.ui={
message=tostring(r),at=os.clock()}end end end end function a.l()local c=a.cache.
l if not c then c={c=b()}a.cache.l=c end return c.c end end end local b=a.a()
local c=getgenv()[b.Name]if c and c.Unload then pcall(c.Unload)end local d=a.l()
d()
