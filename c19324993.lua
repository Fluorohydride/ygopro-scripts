--X・HERO ヘル・デバイサー
---@param c Card
function c19324993.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x8),2,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19324993,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,19324993)
	e1:SetCondition(c19324993.thcon)
	e1:SetCost(c19324993.thcost)
	e1:SetTarget(c19324993.thtg)
	e1:SetOperation(c19324993.thop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c19324993.atktg)
	e2:SetValue(c19324993.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(19324993,ACTIVITY_SPSUMMON,c19324993.counterfilter)
end
function c19324993.counterfilter(c)
	return c:IsSetCard(0x8)
end
function c19324993.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c19324993.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(19324993,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19324993.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c19324993.splimit(e,c)
	return not c:IsSetCard(0x8)
end
function c19324993.ffilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8)
		and Duel.IsExistingMatchingCard(c19324993.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c19324993.thfilter(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c19324993.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19324993.ffilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c19324993.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c19324993.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(c19324993.thfilter,tp,LOCATION_DECK,0,nil,tc)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c19324993.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsRace(RACE_FIEND)
end
function c19324993.atkval(e,c)
	return c:GetLevel()*100
end
