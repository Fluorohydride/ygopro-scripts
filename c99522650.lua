--沈黙の闘者－サイレント・マジシャン
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(s.indct)
	c:RegisterEffect(e3)
	--record draw count for selection
	if not s.rec then
		s.era=0
		s.visible=0
		s.rec={}
	end
	local prop=EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DRAW)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(prop)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
	local e4b=Effect.CreateEffect(c)
	e4b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4b:SetCode(EVENT_CHAINING)
	e4b:SetRange(LOCATION_MZONE)
	e4b:SetProperty(prop)
	e4b:SetOperation(s.chainop)
	c:RegisterEffect(e4b)
	local e4c=Effect.CreateEffect(c)
	e4c:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4c:SetCode(EVENT_CHAIN_END)
	e4c:SetRange(LOCATION_MZONE)
	e4c:SetProperty(prop)
	e4c:SetOperation(s.cendop)
	c:RegisterEffect(e4c)
	local e4d=Effect.CreateEffect(c)
	e4d:SetDescription(aux.Stringid(id,0))
	e4d:SetCategory(CATEGORY_DRAW)
	e4d:SetProperty(EFFECT_FLAG_DELAY)
	e4d:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4d:SetRange(LOCATION_MZONE)
	e4d:SetCode(EVENT_DRAW)
	e4d:SetCountLimit(2)
	e4d:SetCondition(s.drcon)
	e4d:SetTarget(s.drtg)
	e4d:SetOperation(s.drop)
	c:RegisterEffect(e4d)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.discon)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end
function s.spfilter(c,tp)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER) and c:IsLevelBelow(7)
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,s.spfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.spfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_SPSUMMON)
end
function s.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.drawcount(tp,ev,r,rp)
	if r==REASON_EFFECT and rp==1-tp and ev>0 then
		return ev
	end
	return 1
end
function s.openwin()
	if Duel.GetCurrentChain()==0 then
		s.era=s.era+1
		s.visible=s.era
	elseif Duel.GetFlagEffect(0,id)==0 then
		Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1)
		s.era=s.era+1
	end
end
function s.addrec(c,n)
	local fid=c:GetFieldID()
	local t=s.rec[fid]
	if not t then
		t={}
		s.rec[fid]=t
	end
	t[#t+1]={n=n,era=s.era}
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if s.seen~=eg then
		s.seen=eg
		s.openwin()
	end
	if ep==tp then return end
	s.addrec(e:GetHandler(),s.drawcount(tp,ev,r,rp))
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ev~=1 then return end
	if Duel.GetFlagEffect(0,id)~=0 then return end
	Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1)
	s.era=s.era+1
end
function s.cendop(e,tp,eg,ep,ev,re,r,rp)
	s.visible=s.era
	for fid,t in pairs(s.rec) do
		local nt={}
		for i=1,#t do
			if t[i].era==s.visible then
				nt[#nt+1]=t[i]
			end
		end
		s.rec[fid]=nt
	end
end
function s.available(c)
	local t=s.rec[c:GetFieldID()]
	local list={}
	if not t then return list end
	local tp=c:GetControler()
	for i=1,#t do
		local n=t[i].n
		if t[i].era==s.visible and Duel.IsPlayerCanDraw(tp,n) then
			list[#list+1]=n
		end
	end
	return list
end
function s.distinct(list)
	local seen={}
	local opts={}
	for i=1,#list do
		local n=list[i]
		if not seen[n] then
			seen[n]=true
			opts[#opts+1]=n
		end
	end
	return opts
end
function s.remove_one(c,n)
	local t=s.rec[c:GetFieldID()]
	if not t then return end
	for i=1,#t do
		if t[i].era==s.visible and t[i].n==n then
			table.remove(t,i)
			return
		end
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() or e:GetOwner()
	local list=s.available(c)
	if chk==0 then return #list>0 end
	local opts=s.distinct(list)
	local n=opts[1]
	if #opts>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		n=Duel.AnnounceNumber(tp,table.unpack(opts))
	else
		Duel.Hint(HINT_NUMBER,1-tp,n)
	end
	s.remove_one(c,n)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(n)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,n)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)>=6
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end
