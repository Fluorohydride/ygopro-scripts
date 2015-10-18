--Forbidden Tome
function c3211439.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3211439.target)
	e1:SetOperation(c3211439.operation)
	c:RegisterEffect(e1)
end
function c3211439.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_FUSION) or
	Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_SYNCHRO) or
	Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,aux.Stringid(73988674,0),aux.Stringid(73988674,1),aux.Stringid(73988674,2))
	e:SetLabel(op)
end
function c3211439.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then 
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_FUSION)
	Duel.Destroy(sg,REASON_EFFECT)
	elseif e:GetLabel()==1 then 
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_SYNCHRO)
	Duel.Destroy(sg,REASON_EFFECT)
	else 
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_XYZ)
	Duel.Destroy(sg,REASON_EFFECT) end
end
