--スワップリースト
---@param c Card
function c30968774.initial_effect(c)
	--reduce atk and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30968774,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,30968774)
	e1:SetCondition(c30968774.drcon)
	e1:SetTarget(c30968774.drtg)
	e1:SetOperation(c30968774.drop)
	c:RegisterEffect(e1)
	aux.CreateMaterialReasonCardRelation(c,e1)
end
function c30968774.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c30968774.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and rc:IsRelateToEffect(e) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30968774.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToChain() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		Duel.BreakEffect()
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
