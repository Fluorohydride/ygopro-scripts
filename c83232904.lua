--道化の一座『極芸』
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(aux.exccon)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1dc) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.filter(c)
	return (c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		or c:IsType(TYPE_LINK))
		and c:IsLocation(LOCATION_EXTRA)
end
function s.filter2(c)
	return c:IsLocation(LOCATION_EXTRA)
end
function s.gcheck(g,tp,eft,ect)
	return g:FilterCount(s.filter,nil)<=eft and g:FilterCount(s.filter2,nil)<=ect
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetUsableMZoneCount(tp)
	local eft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft>0 then
		if ft>=2 then ft=2 end
		local ct=2
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
		local loc=LOCATION_DECK
		if ect>0 then loc=loc+LOCATION_EXTRA end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,loc,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,s.gcheck,false,1,ct,tp,eft,ect)
			if sg:GetCount()>0 then
				local exg=sg:Filter(s.filter,nil)
				sg:Sub(exg)
				if exg:GetCount()>0 then
					for tc in aux.Next(exg) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				local exg2=sg:Filter(s.filter2,nil)
				sg:Sub(exg2)
				if exg2:GetCount()>0 then
					for tc in aux.Next(exg2) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				if sg:GetCount()>0 then
					for tc in aux.Next(sg) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE) and rc:IsSummonLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function s.thfilter(c,rc)
	return c:GetEquipTarget()~=rc and c~=rc and c:IsAbleToHand()
end
function s.cfilter(c,tp)
	return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk) and Duel.CheckReleaseGroupEx(tp,s.cfilter,1,REASON_COST,true,nil,tp) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroupEx(tp,s.cfilter,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsOnField() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
