--連鎖召喚
function c90812044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c90812044.target)
	e1:SetOperation(c90812044.activate)
	c:RegisterEffect(e1)
end
function c90812044.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c90812044.filter(c,e,tp,rk)
	return c:IsType(TYPE_XYZ) and c:GetRank()<rk
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90812044.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c90812044.cfilter,tp,LOCATION_MZONE,0,nil)
	local rg,rk=g:GetMinGroup(Card.GetRank)
	if chkc then return rg:IsContains(chkc) end
	if chk==0 then return g:GetCount()>=2 and rg:IsExists(Card.IsCanBeEffectTarget,1,nil,e)
		and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c90812044.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=rg:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90812044.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local rk=tc:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90812044.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		sc:RegisterFlagEffect(90812044,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(sc)
		e2:SetCondition(c90812044.retcon)
		e2:SetOperation(c90812044.retop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c90812044.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(90812044)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c90812044.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
