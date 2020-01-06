--覇王の逆鱗
function c84869738.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c84869738.condition)
	e1:SetTarget(c84869738.target)
	e1:SetOperation(c84869738.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c84869738.mattg)
	e2:SetOperation(c84869738.matop)
	c:RegisterEffect(e2)
end
function c84869738.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c84869738.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c84869738.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c84869738.desfilter(c)
	return not c84869738.cfilter(c)
end
function c84869738.spfilter(c,e,tp,g)
	if not (c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		return Duel.GetMZoneCount(tp,g)>0
	end
end
function c84869738.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c84869738.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0
		and Duel.IsExistingMatchingCard(c84869738.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c84869738.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c84869738.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function c84869738.gcheck(g,ft1,ft2,ft3,ect,ft)
	return aux.dncheck(g) and #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)<=ft1
		and g:FilterCount(c84869738.exfilter2,nil)<=ft2
		and g:FilterCount(c84869738.exfilter3,nil)<=ft3
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
end
function c84869738.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c84869738.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ect>0 and (ft2>0 or ft3>0) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c84869738.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=sg:SelectSubGroup(tp,c84869738.gcheck,false,1,4,ft1,ft2,ft3,ect,ft)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP)
end
function c84869738.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20f8) and c:IsType(TYPE_XYZ)
end
function c84869738.matfilter(c)
	return c:IsSetCard(0x20f8) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsCanOverlay()
end
function c84869738.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c84869738.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84869738.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c84869738.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c84869738.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84869738.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c84869738.matfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
