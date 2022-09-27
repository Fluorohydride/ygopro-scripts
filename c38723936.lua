--クイズ
function c38723936.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c38723936.cost)
	e1:SetTarget(c38723936.target)
	e1:SetOperation(c38723936.activate)
	c:RegisterEffect(e1)
end
function c38723936.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(CARD_QUESTION)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c38723936.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c38723936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c38723936.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c38723936.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c38723936.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	local last=g:GetFirst()
	local tc=g:GetNext()
	while tc do
		if tc:GetSequence()<last:GetSequence() then last=tc end
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(1-tp,TYPE_MONSTER,OPCODE_ISTYPE)
	if ac~=last:GetCode() then
		Duel.SpecialSummon(last,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Remove(last,POS_FACEUP,REASON_EFFECT)
	end
end
