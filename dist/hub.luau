local a,b=[[https://raw.githubusercontent.com/rapierhub/degraded/main/dist/]],{{
name='Degraded',file='degraded.luau',places={107088339391423,107103871057311}},{
name='Voxel Wars',file='voxelwars.luau',places={78884249003161}},{name='TTK',
file='ttk.luau',places={120189115846709}},{name='Grapple Sniper Arena',file=
'grapplesniper.luau',places={75407502025821}},{name='Blackhawk Rescue Mission 5'
,file='brm5.luau',places={13622622708,5468388011}}}local c=function()for c,d in
ipairs(b)do for e,f in ipairs(d.places)do if f==game.PlaceId then return d end
end end return nil end local d=c()if not d then error((
'hub: no script for PlaceId %d'):format(game.PlaceId),0)end local e,f=pcall(game
.HttpGet,game,a..d.file)if not e or type(f)~='string'or f==''then error(
'hub: failed to download '..d.file,0)end local g,h=loadstring(f,'='..d.name)if
not g then error('hub: '..tostring(h),0)end g()
