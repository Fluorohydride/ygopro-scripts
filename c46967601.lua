--呪いのお札
function c46967601.initial_effect(c)
	aux.AddEquipProcedure(c)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46967601,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c46967601.damcon)
	e3:SetTarget(c46967601.damtg)
	e3:SetOperation(c46967601.damop)
	c:RegisterEffect(e3)
end
function c46967601.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if not ec then return end
	e:SetLabelObject(ec)
	e:SetLabel(ec:GetPreviousControler())
	return c:IsReason(REASON_LOST_TARGET) and ec:IsLocation(LOCATION_GRAVE) and ec:IsReason(REASON_DESTROY)
end
function c46967601.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabelObject():GetTextDefense()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(e:GetLabel())
	Duel.SetTargetParam(dam)
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,e:GetLabel(),dam)
end
function c46967601.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,g:GetFirst():GetTextDefense(),REASON_EFFECT)
	end
end
