--ドラグニティ－ジャベリン
function c80549379.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80549379.repcon)
	e1:SetOperation(c80549379.repop)
	c:RegisterEffect(e1)
end
function c80549379.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x29) and c:IsRace(RACE_WINDBEAST)
end
function c80549379.repcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsReason(REASON_DESTROY)
		and Duel.IsExistingMatchingCard(c80549379.filter,tp,LOCATION_MZONE,0,1,c)
end
function c80549379.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c80549379.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if Duel.Equip(tp,c,tc,false) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c80549379.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
	end
end
function c80549379.eqlimit(e,c)
	return c==e:GetLabelObject()
end
