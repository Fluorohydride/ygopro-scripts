--No.41 泥睡魔獣バグースカ
function c90590303.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c90590303.mtcon)
	e1:SetOperation(c90590303.mtop)
	c:RegisterEffect(e1)
	--indes/cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c90590303.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c90590303.indval)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c90590303.poscon)
	e4:SetTarget(c90590303.postg)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c90590303.discon)
	e5:SetOperation(c90590303.disop)
	c:RegisterEffect(e5)
end
c90590303.xyz_number=41
function c90590303.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90590303.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c90590303.tgcon(e)
	return e:GetHandler():IsAttackPos()
end
function c90590303.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c90590303.poscon(e)
	return e:GetHandler():IsDefensePos()
end
function c90590303.postg(e,c)
	return c:IsFaceup()
end
function c90590303.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	return e:GetHandler():IsDefensePos()
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and bit.band(pos,POS_DEFENSE)~=0
end
function c90590303.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
