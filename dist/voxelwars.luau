local a={cache={}}do do local b=function()return{Build={PlaceId=78884249003161,
PlaceVersion=2675},Native={VRPath={'Voxel','VR'},BallisticsPath={'Voxel',
'Ballistics'},SniperScript='SniperClient',SniperScopedAlpha=0.6,GunRecoilPath={
'Voxel','GunRecoil'},ViewmodelPath={'Voxel','Viewmodel'},AimTimeAttribute=
'GsAimTime',ShotFunction='shoot',BotFolder='BotRigs',HitConfirmPath={'Game',
'Remotes','HitConfirm'}},Aim={Enabled=true,FovRadius=150,TargetPart='Head',
ClosestParts={'Head','UpperTorso','LowerTorso','HumanoidRootPart'},MaxDistance=
1500,VisibleCheck=true,TeamCheck=true,SkipProtected=true,HitChance=100,
Prediction=true,Kinds={Player=true,Bot=true}},Mods={NoRecoil=false,NoSpread=
false,InstantAds=false,AdsTime=0.01},Esp={Enabled=true,TeamCheck=true,Kinds={
Player=true,Bot=true},Boxes=true,Names=true,Health=true,Distance=true,HeldItem=
true,Tracers=false,Skeleton=false,MaxDistance=3000,Colors={Player=Color3.
fromRGB(255,70,70),Bot=Color3.fromRGB(255,190,60),Team=Color3.fromRGB(80,170,255
)}},Visuals={ShowFov=true,ShowTargetHighlight=true,FovColor=Color3.fromRGB(255,
255,255),LockedColor=Color3.fromRGB(255,80,80)},Perf={EntityInterval=0.5,
TargetSelectInterval=0.05},Name='Pandemonium',WindowIcon=
'rbxassetid://132509022802512',LoadUi=true,UiSource=
[[https://raw.githubusercontent.com/WraithTheWise/yohaha/refs/heads/main/ee]],
RayIgnoreFolders={'VoxelChips','VoxelLoose','VoxelFalling','GroundMarks',
'SniperRounds','GroundFireFX'},PartModes={'Head','UpperTorso','HumanoidRootPart'
,'Closest'},Kinds={'Player','Bot'}}end function a.a()local c=a.cache.a if not c
then c={c=b()}a.cache.a=c end return c.c end end do local b=function()return{
Players=game:GetService'Players',RunService=game:GetService'RunService',
UserInputService=game:GetService'UserInputService',ReplicatedStorage=game:
GetService'ReplicatedStorage'}end function a.b()local c=a.cache.b if not c then
c={c=b()}a.cache.b=c end return c.c end end do local b=function()local b={Loaded
=true,Connections={},Errors={},BuildMismatch=nil,Target=nil,SelectAt=-math.huge,
Hook=nil,OriginalNamecall=nil,Stats={Shots=0,Redirected=0,Hits=0,HitsRedirected=
0,HitsNormal=0,SniperShots=0,SniperNoTarget=0},LastRedirectAt=-math.huge,
Entities={},EntitiesAt=-math.huge,EntitiesGen=0}function b.connect(c,d)local e=c
:Connect(d)table.insert(b.Connections,e)return e end function b.guarded(c,d)
return function(...)local e,f=pcall(d,...)if not e then b.Errors[c]={message=
tostring(f),at=os.clock()}end end end return b end function a.c()local c=a.cache
.c if not c then c={c=b()}a.cache.c=c end return c.c end end do local b=function
()local b,c,d=a.b(),a.a(),a.c()local e=b.Players local f,g=e.LocalPlayer,{}local
h=function()return f.Team and f.Team.Name or nil end function g.refresh(i)if i-d
.EntitiesAt<c.Perf.EntityInterval then return end d.EntitiesAt=i local j={}for k
,l in ipairs(e:GetPlayers())do local m=l~=f and l.Character local n=m and m:
FindFirstChildOfClass'Humanoid'if n then table.insert(j,{model=m,humanoid=n,kind
='Player',label=l.DisplayName,player=l})end end local k=workspace:
FindFirstChild(c.Native.BotFolder)if k then for l,m in ipairs(k:GetChildren())do
local n=m:IsA'Model'and m:FindFirstChildOfClass'Humanoid'if n then table.insert(
j,{model=m,humanoid=n,kind='Bot',label=m.Name})end end end d.Entities=j d.
EntitiesGen=d.EntitiesGen+1 end function g.teamOf(i)if i.player then return i.
player.Team and i.player.Team.Name or nil end local j=i.model:GetAttribute'Team'
return type(j)=='string'and j or nil end function g.isTeammate(i)local j=h()
return j~=nil and g.teamOf(i)==j end function g.alive(i)if i.model.Parent==nil
or i.humanoid.Parent~=i.model or i.humanoid.Health<=0 then return false end
return i.model:GetAttribute'Alive'~=false end function g.protected(i)return i.
model:GetAttribute'Protected'==true end function g.rayParams()local i=
RaycastParams.new()i.FilterType=Enum.RaycastFilterType.Exclude i.IgnoreWater=
true local j={workspace.CurrentCamera}if f.Character then table.insert(j,f.
Character)end for k,l in ipairs(c.RayIgnoreFolders)do local m=workspace:
FindFirstChild(l)if m then table.insert(j,m)end end i.FilterDescendantsInstances
=j return i end return g end function a.d()local c=a.cache.d if not c then c={c=
b()}a.cache.d=c end return c.c end end do local b=function()local b,c,d,e=a.b(),
a.a(),a.c(),a.d()local f,g,h,i,j,k,l,m,n,o,p,q,r,s,t=b.UserInputService,
workspace.CurrentCamera,{},-math.huge,e.rayParams(),-1,function(f,g)local h=f
for i,j in ipairs(g)do h=h and h:FindFirstChild(j)end return h end function h.
origin2D()if f.MouseBehavior==Enum.MouseBehavior.LockCenter then return g.
ViewportSize/2 end return f:GetMouseLocation()end local u,v=function(u,v)local w
,x=g:WorldToViewportPoint(u)if not x or w.Z<=0 then return math.huge end return(
Vector2.new(w.X,w.Y)-v).Magnitude end,function(u,v)local w=u:FindFirstChild(v)
return w and w:IsA'BasePart'and w or nil end h.part=v local w,x,y=function(w,x)
if not c.Aim.VisibleCheck then return true end if k~=d.EntitiesGen then j=e.
rayParams()k=d.EntitiesGen end local y=g.CFrame.Position local z=workspace:
Raycast(y,x.Position-y,j)return z==nil or z.Instance:IsDescendantOf(w)end,
function(w,x)local y=c.Aim if y.TargetPart~='Closest'then local z=v(w,y.
TargetPart)or v(w,'HumanoidRootPart')return z,z and u(z.Position,x)or math.huge
end local z,A=(math.huge)for B,C in ipairs(y.ClosestParts)do local D=v(w,C)if D
then local E=u(D.Position,x)if E<z then A,z=D,E end end end return A,z end,
function(w)local x=c.Aim return x.Kinds[w.kind]and e.alive(w)and not(x.TeamCheck
and e.isTeammate(w))and not(x.SkipProtected and e.protected(w))end local z=
function(z,A)if not z or not z.part.Parent or not y(z.entity)then return false
end if(z.part.Position-g.CFrame.Position).Magnitude>c.Aim.MaxDistance then
return false end return u(z.part.Position,A)<=c.Aim.FovRadius and w(z.entity.
model,z.part)and(z.part.Name==c.Aim.TargetPart or c.Aim.TargetPart=='Closest'or
not w(z.entity.model,v(z.entity.model,c.Aim.TargetPart)or z.part))end function h
.selectTarget()e.refresh(os.clock())local A,B,C,D,E=c.Aim,h.origin2D(),g.CFrame.
Position,(math.huge)for F,G in ipairs(d.Entities)do if y(G)then local H,I=x(G.
model,B)if H and I<=A.FovRadius and I<D and(H.Position-C).Magnitude<=A.
MaxDistance then if not w(G.model,H)then H=nil for J,K in ipairs(A.ClosestParts)
do local L=v(G.model,K)if L and w(G.model,L)then H=L break end end end if H then
E,D={entity=G,part=H},I end end end end return E end local A,B=function(A)return
typeof(A)=='Vector3'and A.X==A.X and A.Y==A.Y and A.Z==A.Z and math.abs(A.X)<1e6
and math.abs(A.Y)<1e6 and math.abs(A.Z)<1e6 end,function()local A,B=c.Aim,d.
Target if not z(B,h.origin2D())then B=h.selectTarget()end if not B or(A.
HitChance<100 and math.random()*100>=A.HitChance)then return nil end return B
end local C,D,E=function(C,D)D=D or B()if not D then return nil end local E=D.
part.Position if not A(E)or(E-C.Position).Magnitude<0.5 then return nil end
return CFrame.lookAt(C.Position,E,C.UpVector)end,function()local C,D=r,b.Players
.LocalPlayer.Character local E=D and D:FindFirstChildOfClass'Tool'if not(C and E
and tonumber(C.RIFLE_SPEED)and type(C.RIFLE_ARC)=='table'and tonumber(C.ZERO))
then return nil end local F=E:GetAttribute'GsVelocity'return C.RIFLE_SPEED*(
type(F)=='number'and F or 1),C.RIFLE_ARC,C.ZERO end,function(C,D,E)local F=r.
launch(Vector3.zero,Vector3.new(C,0,0),D,E)if not A(F)or F.X<=1e-4 then return 0
end return C*F.Y/F.X end local F,G=function(F,G)local H,I,J=D()if not H then
return C(F,G)end local K,L=F.Position,G.part.Position if c.Aim.Prediction then
local M=G.part.AssemblyLinearVelocity if A(M)and M.Magnitude<200 then for N=1,3
do local O,P=pcall(r.flightTime,(L-K).Magnitude,H,I)if not O or type(P)~=
'number'or P~=P or P>5 then break end L=G.part.Position+M*P end end end local M=
L-K local N=M.Magnitude if not A(L)or N<0.5 then return nil end local O,P=
Vector3.yAxis,s and s.current local Q,R,S=type(P)=='table'and tonumber(P.
aimAlpha)or 1,type(P)=='table'and P.muzzleWorld if Q<c.Native.SniperScopedAlpha
and A(R)and(R-K).Magnitude<10 then local T=L-R local U=(T+O*E(T.Magnitude,H,I)).
Unit local V=R+U*J-O*E(J,H,I)S=(V-K).Unit else local T=(M+O*E(N,H,I)).Unit S=(T*
J-O*E(J,H,I)).Unit end if not A(S)then return nil end return CFrame.lookAt(K,K+S
,F.UpVector)end,function(F)local G,H=debug.info(F,'sn')return H==c.Native.
ShotFunction and type(G)=='string'and G:find(c.Native.SniperScript,1,true)~=nil
end function h.install()local H,I,J=l(b.ReplicatedStorage,c.Native.VRPath),false
if H and H:IsA'ModuleScript'then I,J=pcall(require,H)end if not(I and type(J)==
'table'and type(J.frame)=='function')then d.Errors.install={message=
'VR.frame not found',at=os.clock()}return false end m=J n=J.frame local K=c.
Native.ShotFunction o=function(L,...)local M=n(L,...)if d.Loaded and c.Aim.
Enabled and typeof(M)=='CFrame'and debug.info(2,'n')==K then d.Stats.Shots=d.
Stats.Shots+1 local N=t t=nil local O,P if N then O,P=pcall(F,M,N)else O,P=
pcall(C,M)end if O and P then d.Stats.Redirected=d.Stats.Redirected+1 d.
LastRedirectAt=os.clock()return P elseif not O then d.Errors.silentAim={message=
tostring(P),at=os.clock()}end end return M end J.frame=o r=nil local L=l(b.
ReplicatedStorage,c.Native.BallisticsPath)if L and L:IsA'ModuleScript'then local
M,N=pcall(require,L)if M and type(N)=='table'and type(N.launch)=='function'and
type(N.flightTime)=='function'then r=N end end local M=l(b.ReplicatedStorage,c.
Native.ViewmodelPath)if M and M:IsA'ModuleScript'then local N,O=pcall(require,M)
s=N and type(O)=='table'and O or nil end if type(J.on)=='function'then p=J.on q=
function(...)local N=p(...)if N or not(d.Loaded and c.Aim.Enabled)then return N
end if os.clock()-i>0.1 and G(3)then d.Stats.SniperShots=d.Stats.SniperShots+1
local O,P=pcall(B)if not O then d.Errors.sniper={message=tostring(P),at=os.
clock()}elseif not P then d.Stats.SniperNoTarget=d.Stats.SniperNoTarget+1 end if
O and P then t=P i=os.clock()return true end end return N end J.on=q end local N
=l(b.ReplicatedStorage,c.Native.HitConfirmPath)if N and N:IsA'RemoteEvent'then d
.connect(N.OnClientEvent,function()d.Stats.Hits=d.Stats.Hits+1 local O=os.clock(
)-d.LastRedirectAt<0.6 and'HitsRedirected'or'HitsNormal'd.Stats[O]=d.Stats[O]+1
end)end return true end function h.cleanup()if m and m.frame==o then m.frame=n
end if m and q and m.on==q then m.on=p end end return h end function a.e()local
c=a.cache.e if not c then c={c=b()}a.cache.e=c end return c.c end end do local b
=function()local b,c,d,e,f,g,h,i,j,k,l,m=a.a(),a.c(),a.d(),a.e(),workspace.
CurrentCamera,{},Color3.fromRGB(255,60,60),Color3.fromRGB(60,255,90),200,{{
'Head','UpperTorso'},{'UpperTorso','LowerTorso'},{'UpperTorso','LeftUpperArm'},{
'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm','LeftHand'},{'UpperTorso',
'RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'RightLowerArm','RightHand'}
,{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg',
'LeftFoot'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{
'RightLowerLeg','RightFoot'}},{},-1 local n,o,p,q,r=function(n)local o=f:
WorldToViewportPoint(n)return o.X,o.Y,o.Z end,function(n,o)local p=Drawing.new(n
)for q,r in pairs(o)do p[q]=r end p.Visible=false return{d=p,shown=false}end,
function(n,o)if n.shown~=o then n.shown=o n.d.Visible=o end end,function(n,o,p)
if n[o]~=p then n[o]=p n.d[o]=p end end,function(n)if n then pcall(n.d.Remove,n.
d)end end local s,t=function()return{box=o('Square',{Thickness=1.5,Filled=false}
),name=o('Text',{Size=13,Center=true,Outline=true}),info=o('Text',{Size=12,
Center=true,Outline=true}),hpBack=o('Square',{Filled=true,Color=Color3.new(0,0,0
),Transparency=0.6}),hpFill=o('Square',{Filled=true}),hpText=o('Text',{Size=11,
Center=false,Outline=true}),tracer=nil,bones=nil,visible=false}end,function(s,t)
t(s.box)t(s.name)t(s.info)t(s.hpBack)t(s.hpFill)t(s.hpText)if s.tracer then t(s.
tracer)end if s.bones then for u,v in ipairs(s.bones)do t(v)end end end local u,
v,w,x=function(u)if u.visible then u.visible=false t(u,function(v)p(v,false)end)
end end,function(u)local v=l[u]if v then t(v,r)l[u]=nil end end,function(u)local
v,w,x=pcall(u.GetBoundingBox,u)if not v or x.Magnitude<=0 or x.Magnitude>50 then
return nil end local y,z,A,B,C,D,E=x.X/2,x.Y/2,x.Z/2,math.huge,math.huge,-math.
huge,-math.huge for F,G in ipairs{-1,1}do for H,I in ipairs{-1,1}do for J,K in
ipairs{-1,1}do local L,M,N=n((w*CFrame.new(G*y,I*z,K*A)).Position)if N<=0 then
return nil end B,C,D,E=math.min(B,L),math.min(C,M),math.max(D,L),math.max(E,M)
end end end return B,C,D,E,w.Position end,function(u,v,w)if not u.bones then u.
bones={}for x=1,#k do u.bones[x]=o('Line',{Thickness=1})end end for x,y in
ipairs(k)do local z,A,B,C=u.bones[x],e.part(v,y[1]),e.part(v,y[2]),false if A
and B then local D,E,F=n(A.Position)local G,H,I=n(B.Position)if F>0 and I>0 then
z.d.From=Vector2.new(D,E)z.d.To=Vector2.new(G,H)q(z,'Color',w)C=true end end p(z
,C)end end local y=function(y,z,A)local B,C,D=b.Esp,y.model,y.humanoid local E=l
[C]if not E then E=s()l[C]=E end local F,G,H,I,J=w(C)if not F then u(E)return
end local K=(J-z).Magnitude if K>B.MaxDistance or H<-j or I<-j or F>A.X+j or G>A
.Y+j then u(E)return end E.visible=true local L=d.isTeammate(y)and B.Colors.Team
or B.Colors[y.kind]p(E.box,B.Boxes)if B.Boxes then q(E.box,'Color',L)E.box.d.
Position=Vector2.new(F,G)E.box.d.Size=Vector2.new(H-F,I-G)end p(E.name,B.Names)
if B.Names then q(E.name,'Text',B.Distance and('%s [%d]'):format(y.label,math.
floor(K+0.5))or y.label)q(E.name,'Color',L)E.name.d.Position=Vector2.new((F+H)*
0.5,G-16)end local M=B.HeldItem and C:FindFirstChildOfClass'Tool'p(E.info,M~=nil
and M~=false)if M then q(E.info,'Text',M.Name)q(E.info,'Color',L)E.info.d.
Position=Vector2.new((F+H)*0.5,I+2)end local N=B.Health and y.kind=='Player'p(E.
hpBack,N)p(E.hpFill,N)p(E.hpText,N)if N then local O,P=math.clamp(D.Health/math.
max(D.MaxHealth,1),0,1),I-G local Q=h:Lerp(i,O)E.hpBack.d.Position=Vector2.new(F
-6,G)E.hpBack.d.Size=Vector2.new(3,P)q(E.hpFill,'Color',Q)E.hpFill.d.Position=
Vector2.new(F-6,G+P*(1-O))E.hpFill.d.Size=Vector2.new(3,P*O)q(E.hpText,'Text',
tostring(math.floor(D.Health+0.5)))q(E.hpText,'Color',Q)local R=E.hpText.d.
TextBounds E.hpText.d.Position=Vector2.new(F-9-(R and R.X or 0),G+P*(1-O)-6)end
if B.Tracers then if not E.tracer then E.tracer=o('Line',{Thickness=1})end p(E.
tracer,true)q(E.tracer,'Color',L)E.tracer.d.From=Vector2.new(A.X*0.5,A.Y)E.
tracer.d.To=Vector2.new((F+H)*0.5,I)elseif E.tracer then p(E.tracer,false)end if
B.Skeleton then x(E,C,L)elseif E.bones then for O,P in ipairs(E.bones)do p(P,
false)end end end function g.draw()local z,A,B,C=b.Esp,f.CFrame.Position,f.
ViewportSize,m~=c.EntitiesGen and{}or nil for D,E in ipairs(c.Entities)do if C
then C[E.model]=true end if z.Enabled and z.Kinds[E.kind]and d.alive(E)and not(z
.TeamCheck and d.isTeammate(E))then y(E,A,B)else local F=l[E.model]if F then u(F
)end end end if C then m=c.EntitiesGen for D in pairs(l)do if not C[D]then v(D)
end end end end function g.cleanup()for z in pairs(l)do v(z)end end return g end
function a.f()local c=a.cache.f if not c then c={c=b()}a.cache.f=c end return c.
c end end do local b=function()local b,c,d,e,f,g=a.b(),a.a(),a.c(),a.e(),{},
Instance.new'ScreenGui'g.Name=c.Name g.IgnoreGuiInset=true g.ResetOnSpawn=false
g.DisplayOrder=1000 if not pcall(function()g.Parent=(gethui and gethui())or game
:GetService'CoreGui'end)then g.Parent=b.Players.LocalPlayer:WaitForChild
'PlayerGui'end local h=Instance.new'Frame'h.AnchorPoint=Vector2.new(0.5,0.5)h.
BackgroundTransparency=1 h.Parent=g local i=Instance.new'UICorner'i.CornerRadius
=UDim.new(1,0)i.Parent=h local j=Instance.new'UIStroke'j.Thickness=1.5 j.
Transparency=0.2 j.Parent=h local k=Instance.new'Highlight'k.FillTransparency=1
k.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop k.Parent=g function f.update()
local l,m,n=c.Visuals,c.Aim,e.origin2D()h.Visible=l.ShowFov and m.Enabled h.Size
=UDim2.fromOffset(m.FovRadius*2,m.FovRadius*2)h.Position=UDim2.fromOffset(n.X,n.
Y)j.Color=d.Target and l.LockedColor or l.FovColor k.OutlineColor=l.LockedColor
local o=(l.ShowTargetHighlight and d.Target)and d.Target.entity.model or nil if
k.Adornee~=o then k.Adornee=o end end function f.cleanup()pcall(g.Destroy,g)end
return f end function a.g()local c=a.cache.g if not c then c={c=b()}a.cache.g=c
end return c.c end end do local b=function()local b,c,d=a.b(),a.a(),a.c()local e
,f,g,h,i,j,k,l,m,n,o=b.Players.LocalPlayer,{},setmetatable({},{__mode='k'}),-
math.huge,function(e)local f=b.ReplicatedStorage for g,h in ipairs(e)do f=f and
f:FindFirstChild(h)end if not(f and f:IsA'ModuleScript')then return nil end
local g,h=pcall(require,f)return g and type(h)=='table'and h or nil end function
f.install()local p=c.Native j=i(p.GunRecoilPath)if j and type(j.shot)==
'function'then k=j.shot l=function(q,r,s,t,...)if d.Loaded and c.Mods.NoRecoil
and type(q)=='table'then local u=k(q,r,0,0,...)q.roll=0 return u end return k(q,
r,s,t,...)end j.shot=l else d.Errors.noRecoil={message=
'GunRecoil.shot not found',at=os.clock()}end m=i(p.ViewmodelPath)if m and type(m
.hipSpread)=='function'then n=m.hipSpread o=function(...)if d.Loaded and c.Mods.
NoSpread then return 0 end return n(...)end m.hipSpread=o else d.Errors.noSpread
={message='Viewmodel.hipSpread not found',at=os.clock()}end end local p=function
()for p,q in pairs(g)do if p.Parent then pcall(p.SetAttribute,p,c.Native.
AimTimeAttribute,q)end g[p]=nil end end function f.tick(q)if q-h<0.2 then return
end h=q local r,s=c.Mods,c.Native.AimTimeAttribute if not r.InstantAds then if
next(g)then p()end return end local t=e.Character local u=t and t:
FindFirstChildOfClass'Tool'if not u then return end local v=u:GetAttribute(s)if
type(v)~='number'or v==r.AdsTime then return end if g[u]==nil then g[u]=v end u:
SetAttribute(s,r.AdsTime)end function f.cleanup()if j and j.shot==l then j.shot=
k end if m and m.hipSpread==o then m.hipSpread=n end p()end return f end
function a.h()local c=a.cache.h if not c then c={c=b()}a.cache.h=c end return c.
c end end do local b=function()local b,c,d=a.a(),a.c(),{}function d.build()local
e=loadstring(game:HttpGet(b.UiSource))()local f=e:Window{Name=b.Name,Icon=b.
WindowIcon}local g,h=f:Page{Icon='crosshair',Columns=2},f:Page{Icon='eye',
Columns=2}e:CreateSettingsPage(f)local i,j,k,l=function(i,j,k,l,m)return i:
Toggle{Name=j,Flag=k,Default=l,Callback=m}end,function(i,j,k,l,m,n,o,p,q)return
i:Slider{Name=j,Flag=k,Default=l,Min=m,Max=n,Decimals=o,Suffix=p,Callback=q}end,
function(i,j,k,l,m,n)return i:Dropdown{Name=j,Flag=k,Default=l,Items=m,MaxSize=
100,Callback=n}end,function(i,j,k,l,m)return i:Label(j):Colorpicker{Flag=k,
Default=l,Callback=m}end local m,n,o,p,q,r,s=function(m,n,o,p,q)return i(m,n,o,p
[q],function(r)p[q]=r end)end,b.Aim,b.Visuals,b.Esp,g:Section{Name='Silent Aim',
Icon='crosshair',Side=1},g:Section{Name='Targets',Icon='users',Side=1},g:Section
{Name='Field of View',Icon='circle',Side=2}i(q,'Enabled','SAEnabled',n.Enabled,
function(t)n.Enabled=t if not t then c.Target=nil end end)k(q,'Aim Part',
'SAPart',n.TargetPart,b.PartModes,function(t)n.TargetPart=t end)j(q,'Hit Chance'
,'SAHitChance',n.HitChance,0,100,1,'%',function(t)n.HitChance=t end)j(q,
'Max Distance','SAMaxDist',n.MaxDistance,50,3000,10,' studs',function(t)n.
MaxDistance=t end)m(q,'Visibility Check','SAVisible',n,'VisibleCheck')m(q,
'Team Check','SATeam',n,'TeamCheck')m(q,'Skip Spawn Protected','SAProtected',n,
'SkipProtected')m(q,'Sniper Prediction','SAPrediction',n,'Prediction')for t,u in
ipairs(b.Kinds)do m(r,u..'s','SA'..u..'s',n.Kinds,u)end j(s,'Radius','SAFov',n.
FovRadius,10,800,1,'px',function(t)n.FovRadius=t end)m(s,'Show Circle',
'SAShowFov',o,'ShowFov')m(s,'Highlight Target','SAHighlight',o,
'ShowTargetHighlight')l(s,'Circle Color','SAFovColor',o.FovColor,function(t)o.
FovColor=t end)l(s,'Locked Color','SALockedColor',o.LockedColor,function(t)o.
LockedColor=t end)local t,u=b.Mods,g:Section{Name='Weapon Mods',Icon='target',
Side=2}m(u,'No Recoil','WMRecoil',t,'NoRecoil')m(u,'No Spread','WMSpread',t,
'NoSpread')m(u,'Instant ADS','WMAds',t,'InstantAds')local v,w,x=h:Section{Name=
'ESP',Icon='eye',Side=1},h:Section{Name='ESP Targets',Icon='users',Side=2},h:
Section{Name='Colors',Icon='palette',Side=2}m(v,'Enabled','FXEsp',p,'Enabled')m(
v,'Team Check','FXTeam',p,'TeamCheck')m(v,'Boxes','FXBoxes',p,'Boxes')m(v,
'Skeleton','FXSkeleton',p,'Skeleton')m(v,'Tracers','FXTracers',p,'Tracers')m(v,
'Names','FXNames',p,'Names')m(v,'Health','FXHealth',p,'Health')m(v,'Distance',
'FXDistance',p,'Distance')m(v,'Held Item','FXHeldItem',p,'HeldItem')j(v,
'Max Distance','FXEspDist',p.MaxDistance,50,5000,10,' studs',function(y)p.
MaxDistance=y end)for y,z in ipairs(b.Kinds)do m(w,z..'s','FXEsp'..z..'s',p.
Kinds,z)l(x,z..'s','FXCol'..z,p.Colors[z],function(A)p.Colors[z]=A end)end l(x,
'Teammates','FXColTeam',p.Colors.Team,function(y)p.Colors.Team=y end)return e
end function d.destroy(e)if type(e)=='table'and type(e.Unload)=='function'then
pcall(e.Unload,e)end end return d end function a.i()local c=a.cache.i if not c
then c={c=b()}a.cache.i=c end return c.c end end do local b=function()local b,c,
d,e,f,g,h,i,j=a.b(),a.a(),a.c(),a.d(),a.e(),a.f(),a.g(),a.h(),a.i()local k=b.
RunService return function()if game.PlaceVersion~=c.Build.PlaceVersion then d.
BuildMismatch={measured=c.Build.PlaceVersion,current=game.PlaceVersion}end local
l local m,n=function()if not d.Loaded then return end d.Loaded=false for m,n in
ipairs(d.Connections)do pcall(n.Disconnect,n)end table.clear(d.Connections)f.
cleanup()i.cleanup()g.cleanup()h.cleanup()j.destroy(l and l.Library)getgenv()[c.
Name]=nil end,function()local m=os.clock()e.refresh(m)if not c.Aim.Enabled then
d.Target=nil elseif m-d.SelectAt>=c.Perf.TargetSelectInterval then d.SelectAt=m
d.Target=f.selectTarget()end h.update()g.draw()end f.install()i.install()d.
connect(k.Heartbeat,d.guarded('mods',function()i.tick(os.clock())end))d.connect(
k.RenderStepped,d.guarded('render',n))l={Config=c,State=d,SelectTarget=f.
selectTarget,Unload=m}getgenv()[c.Name]=l if c.LoadUi then local o,p=pcall(j.
build)if o then l.Library=p else d.Errors.ui={message=tostring(p),at=os.clock()}
end end end end function a.j()local c=a.cache.j if not c then c={c=b()}a.cache.j
=c end return c.c end end end local b=a.a()local c=getgenv()[b.Name]if c and c.
Unload then pcall(c.Unload)end local d=a.j()d()
