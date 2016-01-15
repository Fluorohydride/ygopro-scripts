--天使の涙
function c9032529.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9032529.target)
	e1:SetOperation(c9032529.activate)
	c:RegisterEffect(e1)
end
function c9032529.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c9032529.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9032529,0))
		local sg=hg:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,1-tp,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,2000,REASON_EFFECT)
		end
	end
end
