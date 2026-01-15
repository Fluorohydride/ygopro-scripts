--アーティファクト－ダグザ
function c7480763.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c7480763.lcheck)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7480763,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7480763)
	e1:SetCondition(c7480763.stcon)
	e1:SetTarget(c7480763.sttg)
	e1:SetOperation(c7480763.stop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7480763,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,7480764)
	e2:SetCondition(c7480763.spcon)
	e2:SetTarget(c7480763.sptg)
	e2:SetOperation(c7480763.spop)
	c:RegisterEffect(e2)
end
function c7480763.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c7480763.stcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler()
end
function c7480763.stfilter(c)
	return c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER) and c:IsSSetable()
end
function c7480763.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7480763.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c7480763.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c7480763.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local ct=Duel.SSet(tp,g)
		if ct~=0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabelObject(tc)
			e1:SetCondition(c7480763.descon)
			e1:SetOperation(c7480763.desop)
			if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				e1:SetValue(Duel.GetTurnCount())
				tc:RegisterFlagEffect(7480763,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1:SetValue(0)
				tc:RegisterFlagEffect(7480763,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
			end
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c7480763.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(7480763)~=0
end
function c7480763.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c7480763.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==1-tp and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c7480763.spfilter(c,e,tp)
	return c:IsSetCard(0x97) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c7480763.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c7480763.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c7480763.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c7480763.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
