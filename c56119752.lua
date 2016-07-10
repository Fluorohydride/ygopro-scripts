--プレゼントカード
function c56119752.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,56119752+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c56119752.target)
	e1:SetOperation(c56119752.activate)
	c:RegisterEffect(e1)
end
function c56119752.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,5)
end
function c56119752.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.BreakEffect()
		Duel.Draw(1-tp,5,REASON_EFFECT)
	end
end
