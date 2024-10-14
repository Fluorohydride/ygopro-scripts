--受け継ぎし魂
---@param c Card
function c69145169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69145169,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69145169+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c69145169.cost)
	e1:SetTarget(c69145169.target)
	e1:SetOperation(c69145169.activate)
	c:RegisterEffect(e1)
	if not c69145169.global_check then
		c69145169.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c69145169.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c69145169.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p=tc:GetControler()
	if tc:GetFlagEffect(69145169)==0 then
		tc:RegisterFlagEffect(69145169,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.GetFlagEffect(p,69145169)==0 then
			Duel.RegisterFlagEffect(p,69145169,RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RegisterFlagEffect(p,69145170,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c69145169.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c69145169.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and (c:IsFaceup() or c:IsControler(tp))
		and Duel.IsExistingTarget(c69145169.filter,tp,0,LOCATION_MZONE,1,c)
end
function c69145169.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,69145170)==0
		and Duel.CheckReleaseGroup(tp,c69145169.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c69145169.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	--cannot attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c69145169.atkcon)
	e1:SetTarget(c69145169.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c69145169.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),69145169)~=0
end
function c69145169.atktg(e,c)
	return c:GetFlagEffect(69145169)==0
end
function c69145169.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69145169.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c69145169.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69145169.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c69145169.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c69145169.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c69145169.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c69145169.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
