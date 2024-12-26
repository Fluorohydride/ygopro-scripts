--カオス・グレファー
---@param c Card
function c18859369.initial_effect(c)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18859369,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,18859369)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c18859369.sgcost)
	e2:SetTarget(c18859369.sgtg)
	e2:SetOperation(c18859369.sgop)
	c:RegisterEffect(e2)
end
function c18859369.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c18859369.tgfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c18859369.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c18859369.tgfilter2(c,attr)
	return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
		and not c:IsAttribute(attr)
end
function c18859369.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c18859369.tgfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,c18859369.tgfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetAttribute())
	Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c18859369.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18859369.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(c18859369.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c18859369.splimit(e,c)
	return c:IsCode(e:GetLabel())
end
