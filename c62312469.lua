--ダーク・ドリアード
function c62312469.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c62312469.atktg)
	e2:SetValue(c62312469.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--deck sort
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62312469,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c62312469.sttg)
	e4:SetOperation(c62312469.stop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c62312469.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c62312469.value(e,c)
	local tp=e:GetHandlerPlayer()
	local att=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct*200
end
function c62312469.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_WIND) end
end
function c62312469.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_WIND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_DECK,0,1,1,nil,ATTRIBUTE_EARTH)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_DECK,0,1,1,nil,ATTRIBUTE_WATER)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g3=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_DECK,0,1,1,nil,ATTRIBUTE_FIRE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g4=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_DECK,0,1,1,nil,ATTRIBUTE_WIND)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
		local tc=g1:GetFirst()
		while tc do
			Duel.MoveSequence(tc,0)
			tc=g1:GetNext()
		end
		Duel.SortDecktop(tp,tp,4)
	end
end
