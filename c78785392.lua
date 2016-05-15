--花合わせ
function c78785392.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,78785392+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c78785392.cost)
	e1:SetTarget(c78785392.target)
	e1:SetOperation(c78785392.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(78785392,ACTIVITY_SUMMON,c78785392.counterfilter)
	Duel.AddCustomActivityCounter(78785392,ACTIVITY_SPSUMMON,c78785392.counterfilter)
end
function c78785392.counterfilter(c)
	return c:IsSetCard(0xe6)
end
function c78785392.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(78785392,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(78785392,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c78785392.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c78785392.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe6)
end
function c78785392.filter(c,e,tp)
	return c:GetAttack()==100 and c:IsSetCard(0xe6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78785392.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.GetMatchingGroup(c78785392.filter,tp,LOCATION_DECK,0,nil,e,tp):GetClassCount(Card.GetCode)>3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_DECK)
end
function c78785392.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.min(4,Duel.GetLocationCount(tp,LOCATION_MZONE))
	local g=Duel.GetMatchingGroup(c78785392.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>3 and g:GetClassCount(Card.GetCode)>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		ct=ct-1
		while ct>0 and g:GetCount()>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
			g1:Merge(g2)
			ct=ct-1
		end
		local tc=g1:GetFirst()
		while tc do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetCode(EFFECT_UNRELEASABLE_SUM)
				e3:SetRange(LOCATION_MZONE)
				e3:SetValue(1)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3,true)
			end
			tc=g1:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
