--闇黒の夢魔鏡
function c1050355.initial_effect(c)
	aux.AddCodeList(c,74665651)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1050355,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,1050355)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1050355.acttg)
	e2:SetOperation(c1050355.actop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c1050355.damcon)
	e3:SetOperation(c1050355.damop)
	c:RegisterEffect(e3)
	aux.RegisterEachTimeEvent(c,EVENT_SPSUMMON_SUCCESS,c1050355.cfilter2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c1050355.damcon2)
	e4:SetOperation(c1050355.damop2)
	c:RegisterEffect(e4)
end
function c1050355.actfilter(c,tp)
	return c:IsCode(74665651) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c1050355.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1050355.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c1050355.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c1050355.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c1050355.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x131) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c1050355.cfilter2(c,e,tp,eg)
	return c:IsSummonPlayer(1-tp)
		and Duel.IsExistingMatchingCard(c1050355.cfilter1,tp,LOCATION_MZONE,0,1,eg)
end
function c1050355.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1050355.cfilter2,1,nil,e,tp,eg) and not Duel.IsChainSolving()
end
function c1050355.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1050355)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c1050355.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1050355)>0
end
function c1050355.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1050355)
	local ct=e:GetHandler():GetFlagEffect(1050355)
	e:GetHandler():ResetFlagEffect(1050355)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
