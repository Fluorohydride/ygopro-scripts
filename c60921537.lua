--凶導の葬列
function c60921537.initial_effect(c)
	aux.AddCodeList(c,40352445,48654323)
	local e1=aux.AddRitualProcGreater2(c,c60921537.filter,LOCATION_HAND+LOCATION_GRAVE,c60921537.grfilter,nil,true,c60921537.extraop)
	e1:SetCountLimit(1,60921537+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c60921537.filter(c)
	return c:IsSetCard(0x145)
end
function c60921537.grfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c60921537.opfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c60921537.extraop(e,tp,eg,ep,ev,re,r,rp,tc)
	if not tc then return end
	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if Duel.IsExistingMatchingCard(c60921537.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,40352445)
		and Duel.IsExistingMatchingCard(c60921537.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,48654323)
		and (#g1~=0 or #g2~=0) and Duel.SelectYesNo(tp,aux.Stringid(60921537,0)) then
		Duel.BreakEffect()
		local g=nil
		if #g1~=0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(60921537,1),aux.Stringid(60921537,2))==0) then
			g=g1
		else
			g=g2
			Duel.ConfirmCards(tp,g,true)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
