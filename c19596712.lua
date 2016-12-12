--アビスケイル－ケートス
function c19596712.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c19596712.filter)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c19596712.negcon)
	e4:SetOperation(c19596712.negop)
	c:RegisterEffect(e4)
end
function c19596712.filter(c)
	return c:IsSetCard(0x74)
end
function c19596712.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE
		and re:IsActiveType(TYPE_TRAP) and Duel.IsChainDisablable(ev) 
end
function c19596712.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
