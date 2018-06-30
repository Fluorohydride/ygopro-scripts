--スワップリースト
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
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c30968774.drcon)
	e2:SetOperation(c30968774.regop)
	c:RegisterEffect(e2)
end
function c30968774.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c30968774.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and rc:IsAttackAbove(500) and rc:GetFlagEffect(30968774)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30968774.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsAttackAbove(500) or rc:IsImmuneToEffect(e) or rc:GetFlagEffect(30968774)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
	if not rc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c30968774.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	rc:RegisterFlagEffect(30968774,RESET_EVENT+RESETS_STANDARD,0,1)
end
