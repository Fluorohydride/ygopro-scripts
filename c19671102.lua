--メールの階段
function c19671102.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19671102,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c19671102.postg)
	e2:SetOperation(c19671102.posop)
	c:RegisterEffect(e2)
end
function c19671102.filter(c)
	return c:IsSetCard(0x10b) and c:IsDiscardable(REASON_EFFECT) and not c:IsHasEffect(19671102)
end
function c19671102.posfilter(c)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition())
		or (c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanTurnSet())
end
function c19671102.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19671102.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c19671102.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
end
function c19671102.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c19671102.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local pg=Duel.SelectMatchingCard(tp,c19671102.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if pg:GetCount()>0 then
			Duel.HintSelection(pg)
			local pc=pg:GetFirst()
			if pc:IsFacedown() then
				Duel.ChangePosition(pc,POS_FACEUP_ATTACK)
			else
				Duel.ChangePosition(pc,POS_FACEDOWN_DEFENSE)
			end
		end
	end
	if tc then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(19671102)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetLabel(code)
		e1:SetTarget(c19671102.dhlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c19671102.dhlimit(e,c)
	return c:IsCode(e:GetLabel())
end
