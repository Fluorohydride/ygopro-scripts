--プランキッズの大作戦
function c15447747.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,15447747)
	e2:SetCondition(c15447747.lkcon)
	e2:SetTarget(c15447747.lktg)
	e2:SetOperation(c15447747.lkop)
	c:RegisterEffect(e2)
	--shuffle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,15447748)
	e3:SetCondition(c15447747.atkcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c15447747.atktg)
	e3:SetOperation(c15447747.atkop)
	c:RegisterEffect(e3)
end
function c15447747.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c15447747.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x120)
end
function c15447747.lkfilter(c)
	return c:IsSetCard(0x120) and c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c15447747.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local el={}
		local mg=Duel.GetMatchingGroup(c15447747.matfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(el,e1)
		end
		local res=Duel.IsExistingMatchingCard(c15447747.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		for _,e in ipairs(el) do
			e:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c15447747.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local el={}
	local mg=Duel.GetMatchingGroup(c15447747.matfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(el,e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xg=Duel.SelectMatchingCard(tp,c15447747.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=xg:GetFirst()
	if tc then
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
	for _,e in ipairs(el) do
		e:Reset()
	end
end
function c15447747.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c15447747.tdfilter(c)
	return c:IsSetCard(0x120) and c:IsAbleToDeck()
end
function c15447747.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15447747.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c15447747.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local g=Duel.GetMatchingGroup(c15447747.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if #g==0 then return end
	local ct=math.min(#g,math.floor(tc:GetAttack()/100))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,ct,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():GetCount()
	if tc:IsFaceup() and tc:IsRelateToBattle() and ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
