--サイバネット・サーキット
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.get_zone(c,seq)
	local zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.replace(zone,0x1,seq+1) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.replace(zone,0x1,seq-1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,0) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,4) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,3) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then zone=bit.replace(zone,0x1,2) end
	return zone
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x18f)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
	for p=0,1 do
		local zone=tc:GetLinkedZone(p)&0xff
		local seq=tc:GetSequence()
		if tc:IsControler(p) then zone=zone|s.get_zone(c,seq) end
		if tc:IsControler(1-p) and seq>=5 then
			seq=11-seq
			zone=zone|s.get_zone(c,seq)
		end
		if Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone) then
			return true
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,tc)
	while #g>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		local avail_zone=0
		for p=0,1 do
			local zone=tc:GetLinkedZone(p)&0xff
			local seq=tc:GetSequence()
			if tc:IsControler(p) then zone=zone|s.get_zone(sc,seq) end
			if tc:IsControler(1-p) and seq>=5 then
				seq=11-seq
				zone=zone|s.get_zone(sc,seq)
			end
			local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
			local flag=(~flag_tmp)&0x7f
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,flag) then
				avail_zone=avail_zone|(flag<<(p==tp and 0 or 16))
			end
		end
		local sel_zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~avail_zone),sc:GetCode())
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		Duel.SpecialSummonStep(sc,0,tp,sump,false,false,POS_FACEUP,sel_zone)
		g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,tc)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) or #g==0
			or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			break
		end
	end
	Duel.SpecialSummonComplete()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function s.tdfilter(c)
	return c:IsSetCard(0x18f) and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_EXTRA)
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
