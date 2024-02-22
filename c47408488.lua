--宝玉の樹
function c47408488.initial_effect(c)
	c:EnableCounterPermit(0x6)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c47408488.ctcon1)
	e2:SetOperation(c47408488.ctop1)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_MOVE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c47408488.regcon)
	e0:SetOperation(c47408488.regop)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c47408488.ctcon2)
	e3:SetOperation(c47408488.ctop2)
	c:RegisterEffect(e3)
	--place
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47408488,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c47408488.plcost)
	e4:SetTarget(c47408488.pltg)
	e4:SetOperation(c47408488.plop)
	c:RegisterEffect(e4)
end
function c47408488.cfilter(c)
	local type=c:GetOriginalType()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then type=c:GetPreviousTypeOnField() end
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 and c:IsSetCard(0x1034) and bit.band(type,TYPE_MONSTER)~=0
end
function c47408488.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47408488.cfilter,1,nil) and not Duel.IsChainSolving()
end
function c47408488.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x6,1)
end
function c47408488.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47408488.cfilter,1,nil) and Duel.IsChainSolving()
end
function c47408488.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(47408488,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function c47408488.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(47408488)>0
end
function c47408488.ctop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(47408488)
	e:GetHandler():AddCounter(0x6,1)
end
function c47408488.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetCounter(0x6))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47408488.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=e:GetHandler():GetCounter(0x6)
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=-1+ct
			and Duel.IsExistingMatchingCard(c47408488.plfilter,tp,LOCATION_DECK,0,ct,nil)
	end
end
function c47408488.plfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c47408488.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<e:GetLabel() then return end
	if ft>e:GetLabel() then ft=e:GetLabel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47408488.plfilter,tp,LOCATION_DECK,0,ft,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
