--魂喰らいの魔刀
function c5371656.initial_effect(c)
	aux.AddEquipProcedure(c,0,c5371656.filter,nil,nil,c5371656.target,c5371656.operation)
end
function c5371656.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3)
end
function c5371656.rfilter(c)
	local tpe=c:GetType()
	return bit.band(tpe,TYPE_NORMAL)~=0 and bit.band(tpe,TYPE_TOKEN)==0 and c:IsReleasable()
end
function c5371656.target(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c5371656.rfilter,tp,LOCATION_MZONE,0,Duel.GetFirstTarget())
	Duel.Release(rg,REASON_COST)
	e:SetLabel(rg:GetCount()*1000)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c5371656.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
