--エーリアン・キッズ
function c64160836.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c64160836.ctcon)
	e1:SetOperation(c64160836.ctop)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	aux.RegisterEachTimeEvent(c,EVENT_SPSUMMON_SUCCESS,c64160836.cfilter,g)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c64160836.ctcon2)
	e0:SetOperation(c64160836.ctop2)
	e0:SetLabelObject(g)
	c:RegisterEffect(e0)
	--atk def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c64160836.adcon)
	e2:SetTarget(c64160836.adtg)
	e2:SetValue(c64160836.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
c64160836.counter_add_list={0x100e}
function c64160836.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp)
end
function c64160836.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64160836.cfilter,1,nil,e,tp) and not Duel.IsChainSolving()
end
function c64160836.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then
			tc:AddCounter(0x100e,1)
		end
		tc=eg:GetNext()
	end
end
function c64160836.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(64160836)>0
end
function c64160836.ctop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(64160836)
	local g=e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	for tc in aux.Next(g) do
		tc:AddCounter(0x100e,1)
	end
end
function c64160836.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c64160836.adtg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x100e)~=0 and bc:IsSetCard(0xc)
end
function c64160836.adval(e,c)
	return c:GetCounter(0x100e)*-300
end
