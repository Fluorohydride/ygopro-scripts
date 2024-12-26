--アダマシア・ラピュタイト
---@param c Card
function c46552140.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ROCK))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--resort
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46552140,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c46552140.sorttg)
	e4:SetOperation(c46552140.sortop)
	c:RegisterEffect(e4)
end
function c46552140.sorttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x140) end
end
function c46552140.sortop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(46552140,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,5,nil,0x140)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			tc=g:GetNext()
		end
		Duel.SortDecktop(tp,tp,g:GetCount())
	end
end
