--聖光の夢魔鏡
function c74665651.initial_effect(c)
	aux.AddCodeList(c,1050355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74665651,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,74665651)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c74665651.acttg)
	e2:SetOperation(c74665651.actop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c74665651.limcon)
	e3:SetValue(c74665651.atlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c74665651.limcon)
	e4:SetTarget(c74665651.tglimit)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c74665651.actfilter(c,tp)
	return c:IsCode(1050355) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c74665651.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74665651.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c74665651.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c74665651.actfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
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
function c74665651.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x131) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c74665651.limcon(e)
	return Duel.IsExistingMatchingCard(c74665651.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c74665651.limfilter(c,lv)
	return c:IsFaceup() and c:IsSetCard(0x131) and c:GetLevel()>lv
end
function c74665651.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x131) and Duel.IsExistingMatchingCard(c74665651.limfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function c74665651.tglimit(e,c)
	return c:IsSetCard(0x131)
		and Duel.IsExistingMatchingCard(c74665651.limfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
