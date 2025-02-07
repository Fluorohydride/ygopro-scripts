--ネフティスの輪廻
function c23459650.initial_effect(c)
	aux.AddCodeList(c,88176533,24175232)
	aux.AddRitualProcGreater2(c,c23459650.filter,LOCATION_HAND,nil,nil,false,c23459650.extraop)
end
function c23459650.filter(c,e,tp)
	return c:IsSetCard(0x11f)
end
function c23459650.mfilter(c)
	if c:IsPreviousLocation(LOCATION_MZONE) then
		local code,code2=c:GetPreviousCodeOnField()
		return code==88176533 or code==24175232 or code2==88176533 or code2==24175232
	end
	return c:IsCode(88176533,24175232)
end
function c23459650.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if mat:IsExists(c23459650.mfilter,1,nil) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(23459650,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
