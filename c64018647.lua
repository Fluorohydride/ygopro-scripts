--リザレクション・ブレス
function c64018647.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--spsummon & equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64018647+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c64018647.condition)
	e1:SetTarget(c64018647.target)
	e1:SetOperation(c64018647.activate)
	c:RegisterEffect(e1)
end
function c64018647.cfilter(c)
	return c:IsFaceup() and c:IsCode(3285552)
end
function c64018647.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c64018647.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c64018647.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c64018647.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c64018647.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c64018647.eqfilter(c,tp,tc)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(tc) and aux.IsCodeListed(c,3285552)
end
function c64018647.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=tg:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if not g1 then return end
	for tc in aux.Next(g1) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
	local g2=Duel.GetMatchingGroup(c64018647.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(64018647,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sc=g2:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local mg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64018647.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp,sc)
		Duel.Equip(tp,mg:GetFirst(),sc)
	end
end
