--ヘルカイトプテラ
function c50834074.initial_effect(c)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c50834074.atcon)
	e1:SetValue(c50834074.atlimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50834074,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50834074)
	e2:SetTarget(c50834074.thtg)
	e2:SetOperation(c50834074.thop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50834074,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,50834075)
	e2:SetTarget(c50834074.sptg)
	e2:SetOperation(c50834074.spop)
	c:RegisterEffect(e2)
end
function c50834074.filter(c)
	return c:GetAttribute()~=ATTRIBUTE_WIND and c:IsFaceup()
end
function c50834074.atcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c50834074.filter,tp,0,LOCATION_MZONE,nil)
	return #g>=2
end
function c50834074.atlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:GetAttribute()~=ATTRIBUTE_WIND and c:IsControler(1-tp) and not c:IsImmuneToEffect(e)
end
function c50834074.thfilter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c50834074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50834074.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50834074.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50834074.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function c50834074.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50834074.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50834074.thfilter),tp,LOCATION_GRAVE,0,nil)
		if #g==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(50834074,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50834074.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end
