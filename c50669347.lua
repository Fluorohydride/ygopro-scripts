--守護神－ネフティス
function c50669347.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x11f),2,2)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50669347,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50669347)
	e1:SetCondition(c50669347.condition)
	e1:SetTarget(c50669347.target)
	c:RegisterEffect(e1)
end
function c50669347.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50669347.thfilter1(c)
	return c:IsLevel(8) and c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c50669347.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c50669347.desfilter(c,e,tp,g)
	return c:IsFaceup() and c:IsSetCard(0x11f) and g:IsContains(c) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c50669347.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c50669347.spfilter(c,e,tp,dc)
	return c:IsSetCard(0x11f) and c:IsType(TYPE_MONSTER) and not c:IsOriginalCodeRule(dc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50669347.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c50669347.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c50669347.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,e:GetHandler():GetLinkedGroup())
	if chk==0 then return b1 or b2 end
	local op=-1
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(50669347,1),aux.Stringid(50669347,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(50669347,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(50669347,2))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(c50669347.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c50669347.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c50669347.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50669347.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50669347.thfilter2),tp,LOCATION_GRAVE,0,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50669347,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		end
	end
end
function c50669347.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dc=Duel.SelectMatchingCard(tp,c50669347.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,lg):GetFirst()
	if dc and Duel.Destroy(dc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50669347.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,dc):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
