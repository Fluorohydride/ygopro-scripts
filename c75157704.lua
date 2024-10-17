--双天の使命
---@param c Card
function c75157704.initial_effect(c)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75157704+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCondition(c75157704.condition)
	e1:SetCost(c75157704.cost)
	e1:SetTarget(c75157704.target)
	e1:SetOperation(c75157704.operation)
	c:RegisterEffect(e1)
end
function c75157704.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c75157704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c75157704.filter(c)
	return c:IsSetCard(0x14f) and not c:IsCode(75157704) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,true,false)~=nil
end
---dynamic target
function c75157704.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c75157704.filter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75157704.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c75157704.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
