--D・レトロエンジン
function c20686759.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c20686759.filter)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c20686759.damcon)
	e3:SetTarget(c20686759.damtg)
	e3:SetOperation(c20686759.damop)
	c:RegisterEffect(e3)
end
function c20686759.filter(c)
	return c:IsSetCard(0x26)
end
function c20686759.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY)
end
function c20686759.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetPreviousEquipTarget():GetBaseAttack()
	if dam<0 then dam=0 end
	e:SetLabel(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function c20686759.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT,true)
	Duel.Damage(tp,e:GetLabel(),REASON_EFFECT,true)
	Duel.RDComplete()
end
