--妖神－不知火
function c52711246.initial_effect(c)
	--limit SSummon
	c:SetSPSummonOnce(52711246)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52711246,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c52711246.target)
	e1:SetOperation(c52711246.operation)
	c:RegisterEffect(e1)
end
function c52711246.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c52711246.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52711246.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE)
end
function c52711246.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c52711246.filter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local b1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local b2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		local b3=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if tc:IsRace(RACE_ZOMBIE) and #b1>0 and Duel.SelectYesNo(tp,aux.Stringid(52711246,1)) then
			local t1=b1:GetFirst()
			while t1 do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(300)
				t1:RegisterEffect(e1)
				t1=b1:GetNext()
			end
		end
		if tc:IsAttribute(ATTRIBUTE_FIRE) and #b2>0 and Duel.SelectYesNo(tp,aux.Stringid(52711246,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t2=b2:Select(tp,1,1,nil)
			Duel.HintSelection(t2)
			Duel.Destroy(t2,REASON_EFFECT)
		end
		if tc:IsType(TYPE_SYNCHRO) and #b3>0  and Duel.SelectYesNo(tp,aux.Stringid(52711246,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t3=b3:Select(tp,1,1,nil)
			Duel.HintSelection(t3)
			Duel.Destroy(t3,REASON_EFFECT)
		end
	end
end
