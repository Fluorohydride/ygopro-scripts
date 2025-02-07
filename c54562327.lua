--Stake Your Soul！
function c54562327.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,54562327+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c54562327.cost)
	e1:SetTarget(c54562327.target)
	e1:SetOperation(c54562327.activate)
	c:RegisterEffect(e1)
end
function c54562327.filter(c,e,tp)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c54562327.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c54562327.spfilter(c,e,tp,pc)
	return c:IsSetCard(0x195) and c:IsAttribute(pc:GetAttribute()) and not c:IsCode(pc:GetCode())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54562327.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c54562327.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c54562327.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c54562327.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c54562327.activate(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or pc==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c54562327.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,pc):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(54562327,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c54562327.thcon)
		e1:SetOperation(c54562327.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c54562327.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(54562327)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c54562327.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
