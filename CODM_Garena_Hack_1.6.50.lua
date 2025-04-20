
local pass = gg["alert"](" [ɢᴀʀᴇɴᴀ ʜᴀᴄᴋ 1.6.50 ʙʏ BᴜΙ͠ᴛᴇʀ] ", " [Enter] ", "", " [Exit] ")
if pass == nil then end
if pass == 1 then else
  if pass == 3 then os["exit"]()
    return end
end

function setvalue(address,flags,value) local tt={} tt[1]={} tt[1].address=address tt[1].flags=flags tt[1].value=value gg.setValues(tt) end
function setMemoryValue(address,flags,value)gg.setValues({{address=address,flags=flags,value=value}}) end
function setValues(address,flags,value)setMemoryValue(address,flags,value) end
function applyPatch(library,offset,edit,type)local ranges=gg.getRangesList(library)if #ranges>0 then setMemoryValue(ranges[1].start+offset,type,edit)else print("Library not found!")end end
local hex={} function patch(lib, offset, edit, type) local ranges=gg.getRangesList(lib) if #ranges==0 then gg.alert("Error: ".. lib .." not found") else local vx={} vx[1]={} vx[1].address=ranges[1].start + offset vx[1].flags=type vx[1].value=edit gg.setValues(vx) end end
local HexPatches = {} function HexPatches.MemoryPatch(Lib, Offset, Edit, Type) local Ranges = gg.getRangesList(Lib) if #Ranges == 0 then gg.alert("Error: ".. Lib .." not found") else local xy = {} xy[1] = {} xy[1].address = Ranges[1].start + Offset xy[1].flags = Type xy[1].value = Edit.."r" xy[1].freeze = true gg.setValues(xy) end end
function split(szFullString,szSeparator)local nFindStartIndex=1 local nSplitIndex=1 local nSplitArray={}while true do local nFindLastIndex=string.find(szFullString,szSeparator,nFindStartIndex)if not nFindLastIndex then nSplitArray[nSplitIndex]=string.sub(szFullString,nFindStartIndex,string.len(szFullString))break end nSplitArray[nSplitIndex]=string.sub(szFullString,nFindStartIndex,nFindLastIndex-1)nFindStartIndex=nFindLastIndex+string.len(szSeparator)nSplitIndex=nSplitIndex+1 end return nSplitArray end
function xgxc(szpy,qmxg)for x=1,#(qmxg)do local xgpy=szpy+qmxg[x]["offset"]local xglx=qmxg[x]["type"]local xgsz=qmxg[x]["value"]local xgdj=qmxg[x]["freeze"]if xgdj==nil or xgdj==""then gg.setValues({[1]={address=xgpy,flags=xglx,value=xgsz}})else gg.addListItems({[1]={address=xgpy,flags=xglx,freeze=xgdj,value=xgsz}})end xgsl=xgsl+1 xgjg=true end end
function xqmnb(qmnb)gg.clearResults()gg.setRanges(qmnb[1]["memory"])gg.searchNumber(qmnb[3]["value"],qmnb[3]["type"]) if gg.getResultCount()==0 then return end gg.refineNumber(qmnb[3]["value"],qmnb[3]["type"])gg.refineNumber(qmnb[3]["value"],qmnb[3]["type"])gg.refineNumber(qmnb[3]["value"],qmnb[3]["type"]) if gg.getResultCount()==0 then return end local sl=gg.getResults(999999) local sz=gg.getResultCount() xgsl=0 if sz>999999 then sz=999999 end for i=1,sz do local pdsz=true for v=4, #(qmnb) do if pdsz then local pysz={}pysz[1]={}pysz[1].address=sl[i].address+qmnb[v]["offset"]pysz[1].flags=qmnb[v]["type"] local szpy=gg.getValues(pysz) local pdpd=qmnb[v]["lv"]..";"..szpy[1].value local szpd=split(pdpd,";") local tzszpd=szpd[1] local pyszpd=szpd[2]if tzszpd==pyszpd then pdjg=true pdsz=true else pdjg=false pdsz=false end end end if pdjg then local szpy=sl[i].address xgxc(szpy,qmxg)end end if xgjg then end end

OFF="⚫" ON="🟡" turn0=OFF turn1=OFF turn2=OFF turn3=OFF turn4=OFF turn5=OFF turn6=OFF turn7=OFF turn8=OFF turn9=OFF turn10=OFF turn11=OFF turn12=OFF turn13=OFF turn14=OFF turn15=OFF turn16=OFF turn17=OFF turn18=OFF turn19=OFF turn20=OFF turn21=OFF turn22=OFF turn23=OFF turn24=OFF turn25=OFF turn26=OFF turn27=OFF turn28=OFF turn29=OFF turn30=OFF turn31=OFF


running=true
BUTTERCOW=1
function home()
  local qq=gg.choice({
    "["..turn0.."]ʙʏᴘᴀss ɢᴀʀᴇɴᴀ ʟᴏɢᴏ["..turn0.."]",
    "➪  ʜᴀᴄᴋ ᴍᴇɴᴜ  ➪",
    "💨  ᴇxɪᴛ  💨"
  }, nil, os["date"]("ɢᴀʀᴇɴᴀ ʜᴀᴄᴋ 1.6.50 ʙʏ এBᴜᴛᴛᴇʀ: %A, %d-%B-%Y [%H:%M] "))
  if qq==nil then
   else
    if qq==1 then A1()
    end
    if qq==2 then A2()
    end
    if qq==3 then exit()
    end
  end
  BUTTERCOW=-1
end

function A1()
  applyPatch("libanogs.so", 0x118AC8, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x135648, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2B57F0, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2B57F8, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2A0158, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2A0160, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4D60, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4D64, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4D68, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4D78, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4D90, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4DA8, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4F30, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4F84, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C4FC8, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C5000, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C5028, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x2C5050, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD45C, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD598, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD59C, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5A0, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5AC, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5B0, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5B4, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5B8, "h00 00 80 D2 C0 03 5F D6", 32)
  applyPatch("libanogs.so", 0x3DD5E0, "h00 00 80 D2 C0 03 5F D6", 32)
  gg['alert'](" 💫 Lᴏɢᴏ Bʏᴘᴀss ᴀᴄᴛɪᴠᴀᴛᴇᴅ ✓  💫 ")
  turn0 = ON
end

function A2()
  MENU = gg['multiChoice']({
    "["..turn1.."] ᴀɪᴍʙᴏᴛ",
    "["..turn2.."] ᴡᴀʟʟʜᴀᴄᴋ",
    "["..turn3.."] ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ",
    "["..turn4.."] ᴡᴀʟʟꜱʜᴏᴛ",
    "["..turn5.."] ɴᴏ ʀᴇᴄᴏɪʟ",
    "["..turn6.."] ɴᴏ ꜱᴘʀᴇᴀᴅ",
    "["..turn7.."] ɴᴏ ꜱʜᴀᴋᴇ",
    "["..turn8.."] ɴᴏ ʀᴇʟᴏᴀᴅ",
    "["..turn9.."] ʜɪᴛʙᴏx",
    "["..turn10.."] ꜱᴍᴏᴏᴛʜ ꜰᴘꜱ",
    "["..turn11.."] ɴᴏ ᴘᴀʀᴀᴄʜᴜᴛᴇ",
    "["..turn12.."] ꜰᴀʀ ᴇxᴇᴄᴜᴛɪᴏɴ",
    "["..turn13.."] ᴘʀᴇᴠᴇɴᴛ ᴏᴠᴇʀʜᴇᴀᴛ",
    "["..turn14.."] ꜰᴀꜱᴛ ꜱᴡᴛɪᴄʜ",
    "["..turn15.."] ꜰᴀꜱᴛ ꜱᴄᴏᴘᴇ",
    "["..turn16.."] ᴏɴᴇ ᴄᴏɴꜱᴜᴍᴇ ʙᴜʟʟᴇᴛ",
    "["..turn17.."] ᴇxᴛᴇɴᴅ ᴡᴇᴀᴘᴏɴ ʀᴀɴɢᴇ",
    "["..turn18.."] ᴜɴʟᴏᴄᴋ ꜰʀᴀᴍᴇʀᴀᴛᴇꜱ",
    "["..turn19.."] ᴀɴᴛɪ ꜰᴘꜱ",
    "["..turn20.."] 120 ꜰᴘꜱ",
    "["..turn21.."] ʙᴜꜰꜰ ᴅᴀᴍᴀɢᴇ",
    "["..turn22.."] ʀᴀᴘɪᴅ ꜰɪʀᴇ",
    "["..turn23.."] ʙʀ ᴛᴀɢꜱ",
    "["..turn24.."] ꜱᴘᴇᴄᴛᴀᴛᴏʀ ᴛᴀɢꜱ",
    "["..turn25.."] ʀᴀᴅᴀʀ ᴍᴀᴘ ʙʀ",
    "["..turn26.."] ɴᴏ ꜰʟᴀꜱʜʙᴀɴɢ",
    "["..turn27.."] ᴀᴅᴠᴀɴᴄᴇ ᴜᴀᴠ",
    "["..turn28.."] ᴡᴀʟᴋ ᴜɴᴅᴇʀ ᴡᴀᴛᴇʀ",
    "["..turn29.."] ꜱɴᴏᴡʙᴏᴀʀᴅ ʙᴏᴏꜱᴛ",
    "["..turn30.."] ʟᴏɴɢ ꜱʟɪᴅᴇ",
    "["..turn31.."] ᴍᴀᴛᴄʜ ᴡɪᴛʜ ᴇᴍᴜʟᴀᴛᴏʀ",
    "🔙  ʙᴀᴄᴋ  🔙",
  }, nil, os["date"]("ɢᴀʀᴇɴᴀ ʜᴀᴄᴋ 1.6.50 ʙʏ এBᴜᴛᴛᴇʀ: %A, %d-%B-%Y [%H:%M] "))
  if MENU == nil then home()
   else
    if MENU[1] == true then M1()
    end
    if MENU[2] == true then M2()
    end
    if MENU[3] == true then M3()
    end
    if MENU[4] == true then M4()
    end
    if MENU[5] == true then M5()
    end
    if MENU[6] == true then M6()
    end
    if MENU[7] == true then M7()
    end
    if MENU[8] == true then M8()
    end
    if MENU[9] == true then M9()
    end
    if MENU[10] == true then M10()
    end
    if MENU[11] == true then M11()
    end
    if MENU[12] == true then M12()
    end
    if MENU[13] == true then M13()
    end
    if MENU[14] == true then M14()
    end
    if MENU[15] == true then M15()
    end
    if MENU[16] == true then M16()
    end
    if MENU[17] == true then M17()
    end
    if MENU[18] == true then M18()
    end
    if MENU[19] == true then M19()
    end
    if MENU[20] == true then M20()
    end
    if MENU[21] == true then M21()
    end
    if MENU[22] == true then M22()
    end
    if MENU[23] == true then M23()
    end
    if MENU[24] == true then M24()
    end
    if MENU[25] == true then M25()
    end
    if MENU[26] == true then M26()
    end
    if MENU[27] == true then M27()
    end
    if MENU[28] == true then M28()
    end
    if MENU[29] == true then M29()
    end
    if MENU[30] == true then M30()
    end
    if MENU[31] == true then M31()
    end
    if MENU[32] == true then home()
    end
  end
end


function M1()
  aimbot = gg.alert("AIMBOT","ON","OFF")
  if aimbot == 1 then
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x846BF40
    setValues(so + py, 32, "h40 00 00 1C C0 03 5F D6");
    gg.toast("ᴀɪᴍʙᴏᴛ ᴏɴ")
    turn1=ON
  end
  if aimbot == 2 then
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x846BF40
    setValues(so + py, 32, "hED 33 B9 6D EB 2B 01 6D");
    gg.toast("ᴀɪᴍʙᴏᴛ ᴏꜰꜰ")
    turn1=OFF
  end
end

function M2()
  wallhack = gg.alert("WALLHACK","ON","OFF")
  if wallhack == 1 then
    applyPatch('libunity.so', 0x5B6DAA8, "h1F 20 03 D5 E0 03 13 AA", 32);
    gg.toast("ᴡᴀʟʟʜᴀᴄᴋ ᴏɴ")
    turn2=ON
  end
  if wallhack == 2 then
    applyPatch('libunity.so', 0x5B6DAA8, "h80 00 00 36 E0 03 13 AA", 32);
    gg.toast("ᴡᴀʟʟʜᴀᴄᴋ ᴏꜰꜰ")
    turn2=OFF
  end
end

function M3()
  applyPatch('libunity.so', 0x8497D3C, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ ᴅᴏɴᴇ")
  turn3=ON
end

function M4()
  wallshot = gg.alert("WALLSHOT","ON","OFF")
  if wallshot == 1 then
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("2", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local result = gg.getResults(9999, nil, nil, nil, nil, nil, nil, nil, nil)
  if result[1] == nil then else
    gg.editAll("-9999999", gg.TYPE_FLOAT)
    gg.toast("ᴡᴀʟʟꜱʜᴏᴛ ᴏɴ")
    turn4=ON
  end
  end
  if wallshot == 2 then
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("-9999999", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(9999)
    gg.editAll("2", gg.TYPE_FLOAT)
    gg.toast("ᴡᴀʟʟꜱʜᴏᴛ ᴏꜰꜰ")
    turn4=OFF
  end
end

function M5()
  so = gg.getRangesList('libunity.so')[1].start
  py = 0x86578E4
  setValues(so + py, 32, "h20 4C 40 BC C0 03 5F D6");
  gg.toast("ɴᴏ ʀᴇᴄᴏɪʟ ᴅᴏɴᴇ")
  turn5=ON
end

function M6()
  applyPatch('libunity.so', 0x8655FF8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x8655FFC, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ɴᴏ ꜱᴘʀᴇᴀᴅ ᴅᴏɴᴇ")
  turn6=ON
end

function M7()
  so = gg.getRangesList('libunity.so')[1].start
  py = 0x844C31C
  setValues(so + py, 32, "h01 00 80 D2 C0 03 5F D6");
  gg.toast("ɴᴏ ꜱʜᴀᴋᴇ ᴅᴏɴᴇ")
  turn7=ON
end

function M8()
  Fastreload1 = 0x8616BA4
  Fastreload2 = 0x8616EB0
  il2cpp = gg.getRangesList('libunity.so')[1].start
  setValues(il2cpp + Fastreload1, 4, "~A8 LDR\t S0, [PC,#0x8]");
  setValues(il2cpp + Fastreload1 + 4, 4, "~A8 RET");
  setValues(il2cpp + Fastreload1 + 8, 16, 1.0E-5);
  setValues(il2cpp + Fastreload2, 4, "~A8 LDR\t S0, [PC,#0x8]");
  setValues(il2cpp + Fastreload2 + 4, 4, "~A8 RET");
  setValues(il2cpp + Fastreload2 + 8, 16, 1.0E-5);
  gg.toast("ɴᴏ ʀᴇʟᴏᴀᴅ ᴅᴏɴᴇ")
  turn8=ON
end

function M9()
  hitbox = gg.alert("HITBOX","ON","OFF")
  if hitbox == 1 then
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x861E394
    setValues(so + py, 32, "h20 01 80 D2 C0 03 5F D6");
    gg.toast("ʜɪᴛʙᴏx ᴏɴ")
    turn9=ON
  end
  if hitbox == 2 then
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x861E394
    setValues(so + py, 32, "hEE 0F 18 FC ED 33 01 6D");
    gg.toast("ʜɪᴛʙᴏx ᴏꜰꜰ")
    turn9=OFF
  end
end

function M10()
  applyPatch('libunity.so', 0x53941F8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x53941FC, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x53946BC, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x53946C0, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x53947D4, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5394D78, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5394D7C, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5395378, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x539537C, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ꜱᴍᴏᴏᴛʜ ꜰᴘꜱ ᴅᴏɴᴇ")
  turn10=ON
end

function M11()
  applyPatch('libunity.so', 0x89B471C, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ɴᴏ ᴘᴀʀᴀᴄʜᴜᴛᴇ ᴅᴏɴᴇ")
  turn11=ON
end

function M12()
  applyPatch('libunity.so', 0x4902398, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x490239C, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x490569C, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x49056A0, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x70BF564, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x70BF568, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ꜰᴀʀ ᴇxᴇᴄᴜᴛɪᴏɴ ᴅᴏɴᴇ")
  turn12=ON
end

function M13()
  applyPatch('libunity.so', 0x856F3A8, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴘʀᴇᴠᴇɴᴛ ᴏᴠᴇʀʜᴇᴀᴛ ᴅᴏɴᴇ")
  turn13=ON
end

function M14()
  applyPatch('libunity.so', 0x96D51F8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D51FC, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D5200, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D5410, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D5414, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D5418, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ꜰᴀꜱᴛ ꜱᴡᴛɪᴄʜ ᴅᴏɴᴇ")
  turn14=ON
end

function M15()
  applyPatch('libunity.so', 0x96D28CC, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D28D0, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D28D4, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D29D8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D29DC, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D29E0, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ꜰᴀꜱᴛ ꜱᴄᴏᴘᴇ ᴅᴏɴᴇ")
  turn15=ON
end

function M16()
  applyPatch('libunity.so', 0x96D4578, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D457C, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴏɴᴇ ᴄᴏɴꜱᴜᴍᴇ ʙᴜʟʟᴇᴛ ᴅᴏɴᴇ")
  turn16=ON
end

function M17()
  applyPatch('libunity.so', 0x96D6444, "h20 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x96D6448, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴇxᴛᴇɴᴅ ᴡᴇᴀᴘᴏɴ ʀᴀɴɢᴇ ᴅᴏɴᴇ")
  turn17=ON
end

function M18()
  applyPatch('libunity.so', 0x853C378, "hC0 03 5F D6 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x853C37C, "hC0 03 5F D6 C0 03 5F D6", 32);
  gg.toast("ᴜɴʟᴏᴄᴋ ꜰʀᴀᴍᴇʀᴀᴛᴇꜱ ᴅᴏɴᴇ")
  turn18=ON
end

function M19()
  applyPatch('libunity.so', 0x8552320, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x8540054, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴀɴᴛɪ ꜰᴘꜱ ᴅᴏɴᴇ")
  turn19=ON
end

function M20()
  applyPatch('libunity.so', 0x853C594, "h00 24 80 D2 C0 03 5F D6", 32);
  gg.toast("120 ꜰᴘꜱ ᴅᴏɴᴇ")
  turn20=ON
end


function M21()
  applyPatch('libunity.so', 0x8650ADC, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ʙᴜꜰꜰ ᴅᴀᴍᴀɢᴇ ᴅᴏɴᴇ")
  turn21=ON
end

function M22()
  applyPatch('libunity.so', 0x85E2404, "h01 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ʀᴀᴘɪᴅ ꜰɪʀᴇ ᴅᴏɴᴇ")
  turn22=ON
end

function M23()
  applyPatch('libunity.so', 0x4C5D4B8, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ʙʀ ᴛᴀɢꜱ ᴅᴏɴᴇ")
  turn23=ON
end

function M24()
  applyPatch('libunity.so', 0x701C550, "h20 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x701C554, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ꜱᴘᴇᴄᴛᴀᴛᴏʀ ᴛᴀɢꜱ ᴅᴏɴᴇ")
  turn24=ON
end


function M25()
  applyPatch('libunity.so', 0x4C5D55C, "h20 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x4C5D560, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ʀᴀᴅᴀʀ ᴍᴀᴘ ʙʀ ᴅᴏɴᴇ")
  turn25=ON
end

function M26()
  applyPatch('libunity.so', 0x849F644, "h00 2C 40 BC C0 03 5F D6", 32);
  gg.toast("ɴᴏ ꜰʟᴀꜱʜʙᴀɴɢ ᴅᴏɴᴇ")
  turn26=ON
end

function M27()
  applyPatch('libunity.so', 0x493A9CC, "h20 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x493A9D0, "h20 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴀᴅᴠᴀɴᴄᴇ ᴜᴀᴠ ᴅᴏɴᴇ")
  turn27=ON
end

function M28()
  applyPatch('libunity.so', 0x5A492D4, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5A492D8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5A65F6C, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5B967F8, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x5B967FC, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ᴡᴀʟᴋ ᴜɴᴅᴇʀ ᴡᴀᴛᴇʀ ᴅᴏɴᴇ")
  turn28=ON
end

function M29()
  speed = gg.prompt({"ꜱɴᴏᴡʙᴏᴀʀᴅ ꜱᴘᴇᴇᴅ [1; 150]"}, nil, {"number"})
  if speed and speed[1] then
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x5A9A074
    setValues(so + py, 32, "h40 00 00 1C C0 03 5F D6");
    setValues(so + py + 4, 32, "hC0 03 5F D6 00 00 7A 44");
    setValues(so + py + 8, 16, speed[1])
    so = gg.getRangesList('libunity.so')[1].start
    py = 0x5A9A11C
    setValues(so + py, 32, "h40 00 00 1C C0 03 5F D6");
    setValues(so + py + 4, 32, "hC0 03 5F D6 00 00 7A 44");
    setValues(so + py + 8, 16, speed[1])
    gg.toast("ꜱɴᴏᴡʙᴏᴀʀᴅ ʙᴏᴏꜱᴛ ᴅᴏɴᴇ")
    turn29=ON
  end
end

function M30()
  applyPatch('libunity.so', 0x89D2A94, "h00 00 80 D2 C0 03 5F D6", 32);
  applyPatch('libunity.so', 0x89D2A98, "h00 00 80 D2 C0 03 5F D6", 32);
  gg.toast("ʟᴏɴɢ ꜱʟɪᴅᴇ ᴅᴏɴᴇ")
  turn30=ON
end

function M31()
  Emulator = 0x4B70AC8
  il2cpp = gg.getRangesList('libunity.so')[1].start
  setValues(il2cpp + Emulator, 32, "h20 00 80 52 C0 03 5F D6");
  gg.toast("ᴍᴀᴛᴄʜ ᴡɪᴛʜ ᴇᴍᴜʟᴀᴛᴏʀ ᴀᴄᴛɪᴠᴀᴛᴇᴅ")
  turn31=ON
end

function exit()
  local exx = gg["alert"]("🎀 離開 • EXIT SCRIPT 🎀", ">>- EXIT -<<  ", "", "  >>- BACK -<<", nil)
  if exx == nil then home() else
    if exx == 1 then
      print("╭════••✧๑♡๑✧••════╮")
      print("                ʜᴀᴄᴋ ʙʏ 🐮BᴜΙ͠ᴛᴇʀ                       ")
      print("╰════••✧๑♡๑✧••════╯")
      gg["skipRestoreState"]()
      gg["clearResults"]()
      gg["clearList"]()
      gg["setVisible"](true)
      os["exit"]()
    end
    if exx == 3 then home()
    end
  end
end

while running do
  if gg.isVisible(true) then
    BUTTERCOW=1
    gg.setVisible(false)
  end
  if BUTTERCOW==1 then
    home()
    BUTTERCOW=-1
  end
end













