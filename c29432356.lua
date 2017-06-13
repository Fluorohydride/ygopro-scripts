--智天の神星龍
function c29432356.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29432356,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,29432357)
	e1:SetTarget(c29432356.sctg)
	e1:SetOperation(c29432356.scop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c29432356.hspcon)
	e3:SetOperation(c29432356.hspop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c29432356.penop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29432356,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c29432356.spcost)
	e5:SetTarget(c29432356.sptg)
	e5:SetOperation(c29432356.spop)
	c:RegisterEffect(e5)
end
function c29432356.scfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc4) and not c:IsForbidden()
		and c:GetLeftScale()~=pc:GetLeftScale()
end
function c29432356.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29432356.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
end
function c29432356.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29432356,1))
	local g=Duel.SelectMatchingCard(tp,c29432356.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
end
function c29432356.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local rg=Duel.GetReleaseGroup(tp)
	return (g:GetCount()>0 or rg:GetCount()>0) and g:FilterCount(Card.IsReleasable,nil)==g:GetCount()
		and g:FilterCount(Card.IsSetCard,nil,0xc4)>=3
end
function c29432356.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
end
function c29432356.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(c29432356.checkop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c29432356.checkop(e,tp)
end
function c29432356.checkop(e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz~=nil and lpz:GetFlagEffect(29432356)<=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(29432356,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCountLimit(1,29432356)
		e1:SetCondition(c29432356.pencon1)
		e1:SetOperation(c29432356.penop1)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_PHASE+PHASE_END)
		lpz:RegisterEffect(e1)
		lpz:RegisterFlagEffect(29432356,RESET_PHASE+PHASE_END,0,1)
	end
	local olpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local orpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if olpz~=nil and orpz~=nil and olpz:GetFlagEffect(29432356)<=0
		and olpz:GetFlagEffectLabel(31531170)==orpz:GetFieldID()
		and orpz:GetFlagEffectLabel(31531170)==olpz:GetFieldID() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(29432356,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e2:SetRange(LOCATION_PZONE)
		e2:SetCountLimit(1,29432356)
		e2:SetCondition(c29432356.pencon2)
		e2:SetOperation(c29432356.penop2)
		e2:SetValue(SUMMON_TYPE_PENDULUM)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		olpz:RegisterEffect(e2)
		olpz:RegisterFlagEffect(29432356,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c29432356.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden() and c:IsSetCard(0xc4)
end
function c29432356.pencon1(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(c29432356.penfilter,1,nil,e,tp,lscale,rscale)
end
function c29432356.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_CARD,0,29432356)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(c29432356.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c29432356.penfilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		if ct<=0 then break end
		if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ct,nil)
		tg:Sub(g)
		sg:Merge(g)
		if g:GetCount()<ct then ft=0 break end
		ft=ft-g:GetCount()
		ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	end
	if ft>0 then
		local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft1,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg1:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
		if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft2,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg2:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c29432356.pencon2(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c29432356.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c29432356.penfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c29432356.penop2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_CARD,0,31531170)
	Duel.Hint(HINT_CARD,0,29432356)
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c29432356.penfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29432356.penfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c29432356.spcfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function c29432356.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c29432356.spcfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c29432356.spcfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c29432356.spfilter(c,e,tp)
	return c:IsSetCard(0xc4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29432356.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29432356.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29432356.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29432356.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
