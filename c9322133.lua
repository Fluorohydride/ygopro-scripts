--サイコ・イレイザー
function c9322133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9322133+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9322133.target)
	e1:SetOperation(c9322133.operation)
	c:RegisterEffect(e1)
end
function c9322133.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToGrave()
end
function c9322133.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9322133.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function c9322133.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9322133.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) then
			local atk=tc:GetBaseAttack()
			local def=tc:GetBaseDefense()
			local rec=atk>=def and atk or def
			if rec>0 then
				Duel.BreakEffect()
				Duel.Recover(1-tp,rec,REASON_EFFECT)
			end
		end
	end
end
