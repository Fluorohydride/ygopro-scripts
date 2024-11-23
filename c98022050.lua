--珠玉獣－アルゴザウルス
---@param c Card
function c98022050.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98022050,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98022050)
	e1:SetTarget(c98022050.destg)
	e1:SetOperation(c98022050.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c98022050.desfilter(c,tp,solve)
	return c:IsRace(RACE_DINOSAUR) and not c:IsCode(98022050) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
		and (solve or Duel.IsExistingMatchingCard(c98022050.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel()))
end
function c98022050.thfilter(c,lv)
	return ((c:GetOriginalLevel()==lv and c:IsRace(RACE_REPTILE+RACE_SEASERPENT+RACE_WINDBEAST))
		or (c:IsSetCard(0x10e) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c98022050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98022050.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c98022050.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98022050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c98022050.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,c98022050.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,true)
	end
	local tc=g:GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local lv=tc:GetOriginalLevel()
		if Duel.IsExistingMatchingCard(c98022050.thfilter,tp,LOCATION_DECK,0,1,nil,lv) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c98022050.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
