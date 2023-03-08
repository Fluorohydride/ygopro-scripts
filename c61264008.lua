--土地ころがし
function c61264008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,61264008+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c61264008.target)
	e1:SetOperation(c61264008.activate)
	c:RegisterEffect(e1)
end
function c61264008.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c61264008.filter2(c,code)
	return c:IsType(TYPE_FIELD) and not c:IsCode(code)
end
function c61264008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and c61264008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61264008.filter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c61264008.filter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c61264008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ttp=tc:GetControler()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local g=Duel.GetOperatedGroup()
			local tc2=g:GetFirst()
			local code=tc2:GetOriginalCode()
			if Duel.MoveToField(tc2,1-ttp,1-ttp,LOCATION_FZONE,POS_FACEUP,true)~=0
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c61264008.filter2),1-ttp,LOCATION_GRAVE,0,1,nil,code)
				and Duel.SelectYesNo(tp,aux.Stringid(61264008,0)) then
				Duel.BreakEffect()
				local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61264008.filter2),1-ttp,LOCATION_GRAVE,0,1,1,nil,code)
				if #rg>0 then
					Duel.MoveToField(rg:GetFirst(),tp,ttp,LOCATION_FZONE,POS_FACEUP,true)
				end
			end
		end
	end
end
