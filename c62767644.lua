--灰滅の劫火
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,3055018)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.stfilter(c,tp)
	return c:IsCode(3055018) and not c:IsForbidden() and (c:CheckUniqueOnField(tp) or c:CheckUniqueOnField(1-tp))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.stfilter,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local p=0
			if tc:CheckUniqueOnField(tp) and (not tc:CheckUniqueOnField(1-tp) or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
				p=tp
			else
				p=1-tp
			end
			local fc=Duel.GetFieldCard(p,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,p,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
function s.tgfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToGrave() and Duel.GetMZoneCount(1-tp,c,tp,LOCATION_REASON_TOFIELD)>0
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PYRO) and c:IsLevelAbove(8)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,tp)
			and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc1 and Duel.SendtoGrave(tc1,REASON_EFFECT)>0 and tc1:IsLocation(LOCATION_GRAVE)
		and tc2 and aux.NecroValleyFilter()(tc2) then
		Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
