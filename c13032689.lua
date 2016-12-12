--エクシーズ・ユニット
function c13032689.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c13032689.filter)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c13032689.atkval)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13032689,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c13032689.rcon)
	e4:SetOperation(c13032689.rop)
	c:RegisterEffect(e4)
end
function c13032689.filter(c)
	return c:IsType(TYPE_XYZ)
end
function c13032689.atkval(e,c)
	return c:GetRank()*200
end
function c13032689.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and ep==e:GetOwnerPlayer() and e:GetHandler():GetEquipTarget()==re:GetHandler() and re:GetHandler():GetOverlayCount()>=ev-1
end
function c13032689.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct==1 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
