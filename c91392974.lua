--出幻
function c91392974.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91392974,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CUSTOM+91392974)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,91392974+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c91392974.condition)
	e1:SetTarget(c91392974.target)
	e1:SetOperation(c91392974.operation)
	c:RegisterEffect(e1)
	if not c91392974.global_check then
		c91392974.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(c91392974.regcon)
		ge1:SetOperation(c91392974.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91392974.cfilter(c,tp)
	return c:IsPreviousSetCard(0x8) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c91392974.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c91392974.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c91392974.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c91392974.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+91392974,re,r,rp,ep,e:GetLabel())
end
function c91392974.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c91392974.filter(c,e,tp)
	return c:IsSetCard(0x5008) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91392974.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c91392974.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c91392974.atkfilter(c)
	return aux.nzatk(c) or aux.nzdef(c)
end
function c91392974.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c91392974.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c91392974.atkfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(91392974,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c91392974.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.BreakEffect()
		Duel.HintSelection(g2)
		local tc=g2:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(math.ceil(tc:GetBaseAttack()/2))
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(math.ceil(tc:GetBaseDefense()/2))
		tc:RegisterEffect(e2)
	end
end
